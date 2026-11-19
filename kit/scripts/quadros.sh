#!/usr/bin/env bash
# quadros.sh — extrai TODOS os quadros de um clipe, na taxa nativa dele, para o site rolar.
# Uso: bash quadros.sh <clipe.mp4> <pasta> [largura=1024] [qualidade=6]
#   largura: 1024–1280 px no computador, 720 px no filme vertical do celular.
#   qualidade: -q:v do JPEG (2 = melhor e mais pesado, 31 = pior); 5–6 é o ponto do curso.
# Grava <pasta>/f_0001.jpg, f_0002.jpg… (zeros à esquerda: a ordem alfabética é a ordem do filme)
# e <pasta>/manifest.json {count, fps, largura}, que a página lê para saber quantos quadros pedir.
set -euo pipefail
CLIPE=$1; PASTA=$2; LARG=${3:-1024}; Q=${4:-6}
FPS=$(ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -of csv=p=0 "$CLIPE" | python3 -c "import sys; n,d=sys.stdin.read().strip().split('/'); print(round(int(n)/int(d)))")
mkdir -p "$PASTA"; rm -f "$PASTA"/f_*.jpg
# -fps_mode passthrough: um JPEG por quadro do clipe, sem duplicar nem pular.
ffmpeg -v error -i "$CLIPE" -vf "scale=${LARG}:-2" -fps_mode passthrough -q:v "$Q" "$PASTA/f_%04d.jpg"
python3 - "$PASTA" "$FPS" "$LARG" <<'PY'
import glob, json, os, sys
from PIL import Image
pasta, fps, larg = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
q = sorted(glob.glob(os.path.join(pasta, 'f_*.jpg')))
json.dump({'count': len(q), 'fps': fps, 'largura': larg}, open(os.path.join(pasta, 'manifest.json'), 'w'))
w, h = Image.open(q[0]).size
mb = f"{sum(os.path.getsize(f) for f in q) / 1e6:.1f}".replace('.', ',')
print(f"QUADROS: {len(q)} · {w}×{h} · {mb} MB · {fps} fps")
PY
