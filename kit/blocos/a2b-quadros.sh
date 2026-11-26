K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a2
bash "$K/scripts/quadros.sh" "$E/clipe.mp4" "$E/quadros" 1024 6
ls "$E/quadros" | head -3
python3 "$K/scripts/conferir-quadros.py" "$E/quadros" "$E/clipe.mp4"; echo "saída: $?"
