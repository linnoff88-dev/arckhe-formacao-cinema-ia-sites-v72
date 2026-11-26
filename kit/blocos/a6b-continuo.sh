K=~/projetos/formacao-cARCKHÉ-ia-sites-v72/kit
E=${TMPDIR:-/tmp}/ensaio-sites/a6; SM=$E/site-movimento/skill/site-movimento/scripts
# dois clipes encadeados: o 2º começa exatamente onde o 1º terminou (zoom 1,25)
bash "$K/scripts/clipe.sh" "$K/exemplos/lente.jpg" "$E/c1.mp4" 4 1.0 1.25
bash "$K/scripts/clipe.sh" "$K/exemplos/lente.jpg" "$E/c2.mp4" 4 1.25 1.5
python3 "$SM/cortes.py" "$E/c1.mp4" "$E/c2.mp4" | sed "s#$E/##"; echo "cortes: ${PIPESTATUS[0]}"
rm -rf "$E/site"; cp -r "$K/site" "$E/site"
python3 "$SM/montar.py" "$E/site" "$E/c1.mp4:0:-1" "$E/c2.mp4:1:-1" | head -1 | sed "s#$E/##"
python3 "$SM/continuidade.py" "$E/site/frames" | sed "s#$E/##"; echo "saída: ${PIPESTATUS[0]}"
