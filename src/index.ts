import express, { type Request, type Response } from 'express';
import { getHtml } from './html/get-html';
import { getManifest } from './html/pwa-manifest';
import path from 'path';
import { generateUniqueHash } from './utils/generate-unique-hash';

const app = express();
const port = 3000;

app.use('/assets', express.static(path.join(import.meta.dirname, '../assets')));

app.get('/', (req: Request, res: Response) => {
  const hash = generateUniqueHash();
  
  res.send(getHtml(hash));
});

app.get('/manifest/:manifestPathParameter', (req: Request, res: Response) => {
  const { params } = req
  const manifestFileName = params['manifestPathParameter']!
  res.json(getManifest(manifestFileName));
});

app.get('/:hash', (req: Request, res: Response) => {
  const { params } = req
  const hash = params['hash']!
  res.send(getHtml(hash));
});

app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
