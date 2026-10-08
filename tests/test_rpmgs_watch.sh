#!/bin/bash
set -eu

topdir=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM
mkdir -p "$tmpdir/repo/.gear" "$tmpdir/bin"
export WATCH_TEST_LOG="$tmpdir/log" WATCH_TEST_MODE=ok
cat > "$tmpdir/bin/rpm-uscan" <<'MOCK'
#!/bin/bash
printf '%s\n' "$*" >> "$WATCH_TEST_LOG"
[ "$WATCH_TEST_MODE" != fail ] || exit 1
version=9.0
while [ "$#" -gt 0 ]; do
	if [ "$1" = --package ] && [ "$2" = second ]; then version=8.0; fi
	if [ "$1" = --download-version ]; then version="$2"; shift; fi
	shift
done
[ "$WATCH_TEST_MODE" != wrong ] || version=9.0
printf '<dehs>\n<upstream-version>%s</upstream-version>\n<upstream-url>https://upstream/source-%s.tar.gz?x=1&amp;y=2</upstream-url>\n</dehs>\n' "$version" "$version"
if [ "$WATCH_TEST_MODE" = uptodate ] || [ "$WATCH_TEST_MODE" = warning ]; then
	printf '<status>up to date</status>\n'
	[ "$WATCH_TEST_MODE" != warning ] || printf '<warnings>watch failed</warnings>\n'
	exit 1
fi
MOCK
chmod +x "$tmpdir/bin/rpm-uscan"
export PATH="$tmpdir/bin:$PATH"
cd "$tmpdir/repo"
cat > fixture.spec <<'SPEC'
Name: fixture
Version: 1.0
Release: alt1
Source: fixture-%version.tar.gz
# Source-url: https://obsolete/fixture-%version.tar.gz
SPEC
printf 'tar.gz: fixture\n' > .gear/rules
printf 'version=3\nhttps://upstream/ source-([0-9.]+).tar.gz\n' > .gear/autobuild.watch

# Run the real rpmgs main body. Stub only environment/IO helpers so the test
# exercises scheme selection, version changes and the existing import path.
cat > "$tmpdir/run" <<'HARNESS'
#!/bin/bash
fatal() { echo "$*" >&2; exit 1; }
get_root_git_dir() { pwd; }
get_gear_rules() { echo .gear/rules; }
is_gear() { return 0; }
make_temp_file() { mktemp; }
assure() { :; }
EPMCMD=assure
set_specdir() { SPECDIR=.; }
get_name() { sed -n 's/^Name: //p' "$1"; }
get_version() { sed -n 's/^Version: //p' "$1"; }
get_release() { echo alt1; }
get_raw_version() { get_version "$1"; }
set_version() { sed -i "s/^Version:.*/Version: $2/" "$1"; }
set_release() { :; }
eval_spec() { sed "s/%version/$(get_version "$1")/g" "$1"; }
get_var() { sed -n "s/^$1: //p"; }
build_rpms_name() { RPMSOURCEDIR="$PWD/sources"; }
rhas() { echo "$1" | grep -q "$2"; }
get_source_url() { GETSOURCEURL=https://fallback; }
get_source_git() { return 1; }
check_tarball() { return 1; }
download_to() { echo "download $1 $2" >> "$WATCH_TEST_LOG"; touch "$2"; DOWNLOADEDURL="$1"; }
download_any_tarball() { echo "direct $1" >> "$WATCH_TEST_LOG"; touch "$2"; }
commit_tarball() { echo "commit $1" >> "$WATCH_TEST_LOG"; }
source_postupdate_hook() { echo hook >> "$WATCH_TEST_LOG"; }
update_predownloaded() { :; }
echog() { :; }
warning() { echo "$*" >&2; }
parse_cmd_pre_spec() { LISTNAMES="${WATCH_TEST_NAMES:-fixture.spec}"; LISTARGS=''; LISTRPMARGS="$*"; }
mygetopts() { :; }
GSSKIPADDCHANGELOG=1
HARNESS
sed -n '/^prepare_watch_source()/,/^will_commit()/p' "$topdir/bin/rpmgs" | sed '$d' >> "$tmpdir/run"
sed -n '/^will_commit()/,$p' "$topdir/bin/rpmgs" >> "$tmpdir/run"

# The requested release is older than latest: never silently import latest.
bash "$tmpdir/run" 2.0 > "$tmpdir/output"
grep -q -- '--download-version 2.0' "$WATCH_TEST_LOG"
grep -Fq 'download https://upstream/source-2.0.tar.gz?x=1&y=2 ' "$WATCH_TEST_LOG"
grep -q '^commit .*fixture-2.0.tar.gz$' "$WATCH_TEST_LOG"
grep -qx hook "$WATCH_TEST_LOG"
grep -qx 'Version: 2.0' fixture.spec

: > "$WATCH_TEST_LOG"
bash "$tmpdir/run" > "$tmpdir/output"
! grep -q -- '--download-version' "$WATCH_TEST_LOG"
grep -q 'source-9.0.tar.gz' "$WATCH_TEST_LOG"
grep -qx 'Version: 9.0' fixture.spec

# A GitHub Source-url adjacent to Source is not the legacy Git-comment scheme.
sed -i '/^# Source-url:/d; /^Source:/i # Source-url: https://github.com/org/repo/archive/%version.tar.gz' fixture.spec
: > "$WATCH_TEST_LOG"
bash "$tmpdir/run" 2.1 > "$tmpdir/output"
grep -q -- '--download-version 2.1' "$WATCH_TEST_LOG"
grep -q 'source-2.1.tar.gz' "$WATCH_TEST_LOG"
sed -i 's/^Version:.*/Version: 9.0/' fixture.spec

# Independent watch resolution for each spec in a multi-spec invocation.
cp fixture.spec second.spec
sed -i 's/^Name:.*/Name: second/;s/^Version:.*/Version: 1.0/' second.spec
: > "$WATCH_TEST_LOG"
WATCH_TEST_NAMES='fixture.spec second.spec' bash "$tmpdir/run" > "$tmpdir/output"
! grep -q -- '--download-version' "$WATCH_TEST_LOG"
grep -qx 'Version: 8.0' second.spec

# Explicit current-release recovery still resolves and imports that release.
: > "$WATCH_TEST_LOG"
bash "$tmpdir/run" 9.0 > "$tmpdir/output"
grep -q -- '--download-version 9.0' "$WATCH_TEST_LOG"
grep -q '^commit .*fixture-9.0.tar.gz$' "$WATCH_TEST_LOG"

# A direct Source URL cannot bypass a recognized watch scheme.
sed -i 's|^Source:.*|Source: https://obsolete/fixture-%version.tar.gz|' fixture.spec
: > "$WATCH_TEST_LOG"
bash "$tmpdir/run" 2.5 > "$tmpdir/output"
grep -q 'source-2.5.tar.gz' "$WATCH_TEST_LOG"
! grep -q '^direct ' "$WATCH_TEST_LOG"
sed -i 's|^Source:.*|Source: fixture-%version.tar.gz|' fixture.spec
sed -i 's/^Version:.*/Version: 9.0/' fixture.spec

# rpm-uscan's no-new-release status 1 is accepted only without warnings.
: > "$WATCH_TEST_LOG"
WATCH_TEST_MODE=uptodate bash "$tmpdir/run" > "$tmpdir/output"
grep -q 'source-9.0.tar.gz' "$WATCH_TEST_LOG"
: > "$WATCH_TEST_LOG"
if WATCH_TEST_MODE=warning bash "$tmpdir/run" > "$tmpdir/output" 2>&1; then exit 1; fi
! grep -Eq '^(download|direct|commit)' "$WATCH_TEST_LOG"

# Watch failures and wrong versions stop before changing the spec or fallback.
for mode in fail wrong; do
	: > "$WATCH_TEST_LOG"
	if WATCH_TEST_MODE="$mode" bash "$tmpdir/run" 3.0 > "$tmpdir/output" 2>&1; then
		echo "unexpected success for $mode" >&2; exit 1
	fi
	! grep -Eq '^(download|direct|commit)' "$WATCH_TEST_LOG"
	grep -qx 'Version: 9.0' fixture.spec
done

# Existing Source-url and HEAD routes remain available without watch resolution.
: > "$WATCH_TEST_LOG"
bash "$tmpdir/run" HEAD > "$tmpdir/output"
! grep -q -- '--dehs' "$WATCH_TEST_LOG"
grep -q '^download https://fallback ' "$WATCH_TEST_LOG"
mv .gear/autobuild.watch .gear/disabled
: > "$WATCH_TEST_LOG"
bash "$tmpdir/run" 4.0 > "$tmpdir/output"
! grep -q -- '--dehs' "$WATCH_TEST_LOG"
grep -q '^download https://fallback ' "$WATCH_TEST_LOG"
mv .gear/disabled .gear/autobuild.watch

# VCS schemes must decline the resolver even with a watch present.
sed -n '/^prepare_watch_source()/,/^will_commit()/p' "$topdir/bin/rpmgs" | sed '$d' > "$tmpdir/helper"
get_root_git_dir() { pwd; }
get_gear_rules() { echo .gear/rules; }
is_gear() { return 0; }
. "$tmpdir/helper"
GSSETVERSION=5.0 SPECDIR=.
get_source_git() { return 1; }
get_source_url() { return 1; }
eval_spec() { cat "$1"; }
get_var() { sed -n "s/^$1: //p"; }
rhas() { echo "$1" | grep -q "$2"; }
for scheme in '# Source-git: https://upstream/repo.git' 'VCS: https://upstream/repo.git'; do
	cp fixture.spec vcs.spec
	printf '%s\n' "$scheme" >> vcs.spec
	if prepare_watch_source vcs.spec; then exit 1; fi
done
# Legacy adjacent git URL comments are recognized through the same helper.
get_source_git() { GETSOURCEGIT=https://github.com/upstream/project; }
if prepare_watch_source fixture.spec; then exit 1; fi
get_source_git() { return 1; }
mkdir -p .gear/upstream
printf upstream > .gear/upstream/remotes
if prepare_watch_source fixture.spec; then exit 1; fi
rm .gear/upstream/remotes
printf 'tar: @version@:.\n' > .gear/rules
if prepare_watch_source fixture.spec; then exit 1; fi
printf 'tar: .\n' > .gear/rules
if prepare_watch_source fixture.spec; then exit 1; fi

echo 'rpmgs watch tests passed'
