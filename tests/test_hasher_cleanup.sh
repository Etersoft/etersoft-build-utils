#!/bin/bash
# Test cleanup_hasher_dir: a free dir is cleaned and kept, a dir in use is skipped without waiting.
set -eu

topdir=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'kill $holder 2>/dev/null || :; rm -rf "$work"' EXIT

load_mod() { :; }
fatal() { echo "$*" >&2; exit 1; }
info() { echo "$*" >&2; }
echog() { echo "$*"; }
docmd() { "$@"; }
source "$topdir/share/eterbuild/functions/hasher"
# a fake hsh: records its arguments and removes what --cleanup-only removes
HSH=$work/hsh
cat >"$HSH" <<'EOF'
#!/bin/sh
echo "$*" >>"$(dirname "$0")/calls"
for dir; do :; done
rm -rf "$dir/chroot" "$dir/aptbox"
EOF
chmod +x "$HSH"

for dir in free free-test busy busy-test empty; do
	mkdir -p "$work/$dir/repo" "$work/$dir/cache"
done
for dir in free free-test busy busy-test; do
	mkdir -p "$work/$dir/chroot" "$work/$dir/aptbox"
done
touch "$work/free.ebu-lock" "$work/busy.ebu-lock"
flock "$work/busy.ebu-lock" sleep 30 &
holder=$!
sleep 0.3

for dir in free free-test busy busy-test empty; do
	timeout 5 bash -c "$(declare -f cleanup_hasher_dir info echog docmd); HSH=$HSH; cleanup_hasher_dir $work/$dir"
done

# cleaned, the dir with repo and cache stays
for dir in free free-test; do
	[ -d "$work/$dir/repo" ] && [ -d "$work/$dir/cache" ]
	[ ! -e "$work/$dir/chroot" ] && [ ! -e "$work/$dir/aptbox" ]
done
# in use (the -test dir by its build dir's lock): untouched
for dir in busy busy-test; do
	[ -d "$work/$dir/chroot" ]
done
# nothing to clean: hsh is not called
grep -q -- "--cleanup-only --no-wait-lock $work/free\$" "$work/calls"
grep -q -- "--cleanup-only --no-wait-lock $work/free-test\$" "$work/calls"
[ "$(wc -l <"$work/calls")" = 2 ]
echo OK
