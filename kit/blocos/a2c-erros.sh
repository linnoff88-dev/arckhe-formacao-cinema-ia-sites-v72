K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a2; mkdir -p "$E/poucos" "$E/sem-zero"
# erro 1: "uns quadros por segundo bastam" (6 por segundo de um clipe de 24)
ffmpeg -v error -i "$E/clipe.mp4" -vf "fps=6,scale=1024:-2" -q:v 6 "$E/poucos/f_%04d.jpg"
python3 "$K/scripts/conferir-quadros.py" "$E/poucos" "$E/clipe.mp4"; echo "saída: $?"
# erro 2: nome sem zeros à esquerda (f_%d em vez de f_%04d)
ffmpeg -v error -i "$E/clipe.mp4" -vf "scale=1024:-2" -q:v 6 "$E/sem-zero/f_%d.jpg"
python3 "$K/scripts/conferir-quadros.py" "$E/sem-zero" "$E/clipe.mp4"; echo "saída: $?"
