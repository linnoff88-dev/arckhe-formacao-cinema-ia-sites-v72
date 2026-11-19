K=~/projetos/formacao-cinema-ia-sites-v72/kit
curl -s -o /dev/null -w "%{http_code}\n" https://inematds.github.io/formacao-cinema-ia-sites-v72/kit/site/
node "$K/scripts/verificar.mjs" https://inematds.github.io/formacao-cinema-ia-sites-v72/kit/site/; echo "saída: $?"
