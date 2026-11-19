K=~/projetos/formacao-cinema-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a2; rm -rf "$E"; mkdir -p "$E"
bash "$K/scripts/clipe.sh" "$K/exemplos/lente.jpg" "$E/clipe.mp4" 6 1.0 1.35
