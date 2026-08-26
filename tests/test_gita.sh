#!/bin/sh

set -eu

topdir=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM

cat >"$tmpdir/curl" <<'EOF'
#!/bin/sh
cat <<'JSON'
{"subtasks":{"40":{"pkgname":"createrepo_c","dir":"/people/lav/packages/createrepo_c.git"}}}
JSON
EOF

cat >"$tmpdir/ssh" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >>"$GITA_TEST_LOG"
EOF

chmod +x "$tmpdir/curl" "$tmpdir/ssh"
export GITA_TEST_LOG="$tmpdir/ssh.log"

check_repo_form()
{
	: >"$GITA_TEST_LOG"
	PATH="$tmpdir:$PATH" "$topdir/bin/gita" git.alt add 123 repo "$@"
	grep -Fx 'gear.alt task delsub 123 40' "$GITA_TEST_LOG" >/dev/null
}

check_repo_form /people/lav/packages/createrepo_c.git=1.2.4-alt2
check_repo_form /people/lav/packages/createrepo_c.git 1.2.4-alt2

echo "gita repo replacement tests passed"
