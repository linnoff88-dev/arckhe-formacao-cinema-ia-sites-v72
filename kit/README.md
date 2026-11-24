# Kit — Sites cARCKHÉtográficos (Formação CARCKHÉ com IA, curso 5 de 6)

Página de produto fictícia (a lente **Aurora 35**) com filme na rolagem, uma cena Three.js e os scripts que conferem tudo por comando. Nada aqui chama modelo, API ou gerador de vídeo: os clipes de ensaio saem de uma foto com `ffmpeg`. Versões fixadas em 19/10/2026.

```bash
cd ~/projetos && git clone https://github.com/linnoff88-dev/formacao-cARCKHÉ-ia-sites-v72
cd formacao-cARCKHÉ-ia-sites-v72/kit
npm ci && npx playwright install chromium     # Playwright 1.64.0, three 0.186.1
bash scripts/portao.sh site                   # PORTÃO: 4/4 OK
```

| Pasta / arquivo | O que tem |
|---|---|
| `site/` | a página de exemplo: `index.html`, `site.css`, `site.js`, `frames/` (filme horizontal, 1024 px) e `frames-v/` (vertical, 720 px); `erro-*.html` são cópias com uma opção desligada de propósito |
| `site/vendor/` | `motor-rolagem.js` e `chave-movimento.js`, copiados sem mudança de [linnoff88-dev/site-movimento](https://github.com/linnoff88-dev/site-movimento) (commit d9a43a4, `skill/site-movimento/runtime/`) |
| `site-three/` | cena Three.js que desenha sob demanda; `vendor/` tem `three.module.js` + `three.core.js` da 0.186.1 (MIT) |
| `scripts/clipe.sh` | foto → clipe de ensaio com a câmera se aproximando (zoompan) |
| `scripts/quadros.sh` | clipe → `f_0001.jpg…` na taxa nativa + `manifest.json` |
| `scripts/conferir-quadros.py` | contagem × fps × duração, nomes com zeros, manifest |
| `scripts/peso.py` | peso por visitante (computador / celular), primeira pintura, orçamento |
| `scripts/servir.mjs` | servidor estático em 127.0.0.1 numa porta livre (escreve a URL) |
| `scripts/verificar.mjs` | contrato `?jump` + `__ready`: quadro certo e tela pintada em 0/50/100 %; `--celular`, `--reduzir` |
| `scripts/three-medir.mjs` | desenhos da cena parada, rolando, fora da tela e com reduzir movimento; teto de densidade |
| `scripts/cenas-modelo.mjs` | ensaio do filmarca sem modelo (cenas-modelo no lugar do passo `cenas`) |
| `scripts/conferir-video.py` | duração e tamanho de um MP4 (ffprobe) |
| `scripts/portao.sh` | peso + computador + celular + reduzir → `PORTÃO: 4/4 OK` |
| `filmarca/roteiro.json` | roteiro do filme da marca escrito só com fatos da página |
| `exemplos/` | fotos da lente (geradas localmente, sem marca), textos com erro para os portões de texto, trecho do vídeo na página |
| `blocos/`, `saidas/`, `capturar.sh` | os blocos "Terminal" do curso e as saídas capturadas (19/10/2026) |

Servidor: nunca use porta fixa nem `sleep`. Os blocos esperam a URL responder num laço:

```bash
node scripts/servir.mjs site > url.txt & S=$!
until U=$(cat url.txt) && [ -n "$U" ] && curl -s -o /dev/null "$U"; do sleep 0.3; done
node scripts/verificar.mjs "$U"; kill $S
```

Curso: https://linnoff88-dev.github.io/ · página do kit no ar: https://linnoff88-dev.github.io/ · conteúdo aberto e gratuito do ARCKHÉ AI.
