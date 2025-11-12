import { generateUniqueHash } from "../utils/generate-unique-hash";
import { getManifest } from "./pwa-manifest";

export const getHtml = (hash: string) => {

  const manifestFileName = `${hash}.json`
  const manifest = getManifest(manifestFileName)
  const manifestUrl = `/manifest/${manifestFileName}?${hash}`
  return `
    <!DOCTYPE html>
    <html>
      <head>
        <title>Basic PWA</title>
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
        <meta name="apple-mobile-web-app-title" content="Basic PWA">
        <link rel="apple-touch-icon" href="/assets/gallery_icon_1024_1024.png?${hash}">
        <link rel="manifest" href="${manifestUrl}">
      </head>
      <body>
        <h1>Hello, from your Express server!</h1>
        <h2>Your Unique Hash is: ${hash}</h2>
        <h2>PWA Manifest URL: ${manifestUrl}</h2>
        <h2>Manifest Start URL: ${manifest.start_url}</h2>
        <h2>Manifest Icon: ${manifest.icons[0]!.src}</h2>
        <script>
          document.addEventListener('DOMContentLoaded', () => {
            const infoDiv = document.createElement('div');
            const url = window.location.href;
            const params = window.location.search;
            infoDiv.innerHTML = \`
              <p>Current URL: \${url}</p>
              <p>Query Parameters: \${params}</p>
            \`;
            document.body.appendChild(infoDiv);
          });
        </script>
      </body>
    </html>
  `;
};
