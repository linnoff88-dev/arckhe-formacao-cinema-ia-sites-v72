E=${TMPDIR:-/tmp}/ensaio-sites/a3; rm -rf "$E"; mkdir -p "$E"; cd "$E"
git clone -q https://github.com/inematds/scroll-film-studio && git -C scroll-film-studio checkout -q 9d64875; echo "clone: $?"
cd scroll-film-studio/skills/scroll-film-studio
ls; ls references scripts
sed -n 2p SKILL.md
