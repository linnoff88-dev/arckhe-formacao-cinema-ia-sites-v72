K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a7; rm -rf "$E/site"; cp -r "$K/site" "$E/site"
python3 "$K/scripts/peso.py" "$E/site" --orcamento 3 | grep -E "^celular|orçamento"
# o filme vertical de novo: 600 px de largura e JPEG -q:v 8 (era 720 px e 6)
bash "$K/scripts/clipe.sh" "$K/exemplos/lente.jpg" "$E/v.mp4" 6 1.0 1.35 1080x1920
bash "$K/scripts/quadros.sh" "$E/v.mp4" "$E/site/frames-v" 600 8
python3 "$K/scripts/peso.py" "$E/site" --orcamento 3 --inicial 0.5 | grep -E "^celular|orçamento|teto"; echo "saída: ${PIPESTATUS[0]}"
