K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a5; cd "$E/filmarca"
export HYPERFRAMES_NO_TELEMETRY=1
cp "$K/filmarca/roteiro.json" "$E/filme/"
node "$K/scripts/cenas-modelo.mjs" . "$E/filme"
node bin/filmarca.mjs render "$E/filme" --formatos 16x9 --rascunho; echo "render: $?"
python3 "$K/scripts/conferir-video.py" "$E/filme/renders/aurora-35-pt-16x9.mp4" 17.5 1920x1080; echo "saída: $?"
