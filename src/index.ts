import express, { type Request, type Response } from 'express';
import { getHtml } from './html/get-html';
import { getManifest } from './html/pwa-manifest';
import path from 'path';
import { generateUniqueHash } from './utils/generate-unique-hash';

const app = express();
const port = 3000;

// Logging middleware for all requests to log method, path, query, and headers
app.use((req: Request, res: Response, next) => {
  console.log('--- Incoming Request ---');
  console.log('URL:', req.originalUrl);
  console.log('Method:', req.method);
  console.log('Path:', req.path);
  console.log('Query:', req.query);
  console.log('Headers:', req.headers);

  // Capture response info
  const oldSend = res.send;
  res.send = function (body?: any): Response {
    console.log('--- Outgoing Response ---');
    console.log('Status:', res.statusCode);
    // Try to log the actual response type safely
    if (typeof body === 'string') {
      console.log('Response Body (truncated):', body.length > 500 ? body.slice(0, 500) + '...[truncated]' : body);
    } else if (typeof body === 'object') {
      try {
        const bodyJson = JSON.stringify(body);
        console.log('Response Body (truncated):', bodyJson.length > 500 ? bodyJson.slice(0, 500) + '...[truncated]' : bodyJson);
      } catch {
        console.log('Response Body: [Non-serializable object]');
      }
    } else {
      console.log('Response Body:', body);
    }
    return oldSend.apply(this, arguments as any);
  };

  next();
});

app.use('/assets', express.static(path.join(import.meta.dirname, '../assets')));

app.get('/', (req: Request, res: Response) => {
  const hash = generateUniqueHash();
  
  // Log request parameters specific to this endpoint
  console.log('Route: /');
  console.log('Params:', req.params);
  console.log('Query:', req.query);

  res.send(getHtml(hash));
});

app.get('/manifest/:manifestPathParameter', (req: Request, res: Response) => {
  const { params } = req;
  const manifestFileName = params['manifestPathParameter']!;
  console.log('Route: /manifest/:manifestPathParameter');
  console.log('Params:', params);
  console.log('manifestPathParameter:', manifestFileName);
  console.log('Query:', req.query);

  res.json(getManifest(manifestFileName));
});

app.get('/:hash', (req: Request, res: Response) => {
  const { params } = req;
  const hash = params['hash']!;
  console.log('Route: /:hash');
  console.log('Params:', params);
  console.log('Hash:', hash);
  console.log('Query:', req.query);

  res.send(getHtml(hash));
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
