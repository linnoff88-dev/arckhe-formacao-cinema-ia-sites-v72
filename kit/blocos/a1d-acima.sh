K=~/projetos/formacao-cinema-ia-sites-v72/kit
python3 "$K/scripts/peso.py" "$K/site" --orcamento 2 | tail -1; echo "saída: ${PIPESTATUS[0]}"
