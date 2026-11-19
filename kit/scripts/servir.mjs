// servir.mjs — servidor estático só para testar a página na sua máquina (127.0.0.1, sem dependências).
// Uso: node servir.mjs <pasta> [porta]
// Sem porta, o sistema escolhe uma livre (porta 0) e a 1ª linha da saída é a URL. Nunca adivinhe a porta:
// numa máquina com outros serviços, a 8080 ou a 8090 podem ser de outro programa e o teste mede a página errada.
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';

const raiz = path.resolve(process.argv[2] ?? '.');
const porta = Number(process.argv[3] ?? 0);
const TIPOS = {
  '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.mjs': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8', '.json': 'application/json', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg',
  '.png': 'image/png', '.webp': 'image/webp', '.avif': 'image/avif', '.svg': 'image/svg+xml',
  '.mp4': 'video/mp4', '.webm': 'video/webm', '.woff2': 'font/woff2', '.vtt': 'text/vtt',
};

const srv = http.createServer((req, res) => {
  const url = new URL(req.url, 'http://x');
  let f = path.join(raiz, decodeURIComponent(url.pathname));
  if (!f.startsWith(raiz)) { res.writeHead(403).end(); return; }
  if (fs.existsSync(f) && fs.statSync(f).isDirectory()) f = path.join(f, 'index.html');
  fs.readFile(f, (err, dados) => {
    if (err) { res.writeHead(404, { 'content-type': 'text/plain' }).end('404'); return; }
    res.writeHead(200, { 'content-type': TIPOS[path.extname(f).toLowerCase()] ?? 'application/octet-stream', 'cache-control': 'no-store' });
    res.end(dados);
  });
});
srv.listen(porta, '127.0.0.1', () => console.log(`http://127.0.0.1:${srv.address().port}/`));
