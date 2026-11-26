E=${TMPDIR:-/tmp}/ensaio-sites/a6; rm -rf "$E"; mkdir -p "$E"; cd "$E"
git clone -q https://github.com/linnoff88-dev/site-movimento && git -C site-movimento checkout -q d9a43a4; echo "clone: $?"
bash site-movimento/skill/site-movimento/tests/motores-contrato.sh; echo "saída: $?"
