import express, { type Request, type Response } from 'express';
import { getHtml } from './html/get-html';
import { getManifest } from './html/pwa-manifest';
import path from 'path';
import { generateUniqueHash } from './utils/generate-unique-hash';

const app = express();
const port = 3000;

// Logging middleware - one consolidated log per request and response
app.use((req: Request, res: Response, next) => {
  const startTime = Date.now();
  
  // Store metadata on request for later use
  (req as any).analyticsStartTime = startTime;
  
  // Log request - single consolidated JSON log
  const requestLog = {
    type: 'request',
    timestamp: new Date().toISOString(),
    method: req.method,
    url: req.originalUrl,
    path: req.path,
    queryParams: req.query,
    params: req.params,
    headers: {
      'user-agent': req.get('user-agent'),
      'referer': req.get('referer'),
      'content-type': req.get('content-type'),
      'accept': req.get('accept'),
    },
    ip: req.ip || req.socket.remoteAddress || 'unknown',
  };
  console.log(JSON.stringify(requestLog));

  // Capture response finish to log response
  res.on('finish', () => {
    const responseTime = Date.now() - startTime;
    const hash = (req as any).analyticsHash;
    
    // Log response - single consolidated JSON log
    const responseLog = {
      type: 'response',
      timestamp: new Date().toISOString(),
      method: req.method,
      path: req.path,
      queryParams: req.query,
      hash: hash || undefined,
      statusCode: res.statusCode,
      responseTime: `${responseTime}ms`,
      headers: {
        'content-type': res.get('content-type'),
      },
    };
    console.log(JSON.stringify(responseLog));
  });

  next();
});

app.use('/assets', express.static(path.join(import.meta.dirname, '../assets')));

app.get('/', (req: Request, res: Response) => {
  const hash = generateUniqueHash();
  
  // Store hash for response logging
  (req as any).analyticsHash = hash;

  res.send(getHtml(hash));
});

app.get('/manifest/:manifestPathParameter', (req: Request, res: Response) => {
  const { params } = req;
  const manifestFileName = params['manifestPathParameter']!;

  res.json(getManifest(manifestFileName));
});

app.get('/:hash', (req: Request, res: Response) => {
  const { params } = req;
  const hash = params['hash']!;
  
  // Store hash for response logging
  (req as any).analyticsHash = hash;

  res.send(getHtml(hash));
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
