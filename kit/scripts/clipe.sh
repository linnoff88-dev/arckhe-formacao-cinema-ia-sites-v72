#!/usr/bin/env bash
# clipe.sh — faz um clipe de ENSAIO a partir de uma foto parada: a câmera se aproxima devagar (zoom), sem gerador
# de vídeo e sem crédito. Serve para treinar o caminho clipe → quadros → página antes de gastar com um gerador.
# Uso: bash clipe.sh <foto.jpg> <saida.mp4> [segundos=6] [zoom_ini=1.0] [zoom_fim=1.35] [LARGURAxALTURA=1920x1080]
# Ex.: bash clipe.sh lente.jpg clipe.mp4 6 1.0 1.35
#      bash clipe.sh lente.jpg vertical.mp4 6 1.0 1.35 1080x1920   (9:16: recorta o centro da foto)
set -euo pipefail
FOTO=$1; SAIDA=$2; SEG=${3:-6}; Z0=${4:-1.0}; Z1=${5:-1.35}; TAM=${6:-1920x1080}
W=${TAM%x*}; H=${TAM#*x}; FPS=24; N=$(python3 -c "print(round($SEG*$FPS))")
# Ampliar a foto 2x antes do zoompan tira o tremido do zoom (o zoompan arredonda a posiçêo em pixels inteiros).
ffmpeg -v error -y -loop 1 -i "$FOTO" -vf \
  "scale=${W}*2:${H}*2:force_original_aspect_ratio=increase,crop=${W}*2:${H}*2,zoompan=z='${Z0}+(${Z1}-${Z0})*on/(${N}-1)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${N}:s=${W}x${H}:fps=${FPS},format=yuv420p" \
  -frames:v "$N" -c:v libx264 -crf 18 -preset medium -r $FPS "$SAIDA"
ffprobe -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate:format=duration -of json "$SAIDA" |
  python3 -c "import json,sys; d=json.load(sys.stdin); s=d['streams'][0]; n,q=s['r_frame_rate'].split('/'); seg=f\"{float(d['format']['duration']):.1f}\".replace('.', ','); print(f\"$(basename "$SAIDA"): {seg} s · {round(int(n)/int(q))} fps · {s['width']}×{s['height']}\")"
