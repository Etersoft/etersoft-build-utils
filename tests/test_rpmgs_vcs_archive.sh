#!/bin/bash
set -eu
topdir=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT HUP INT TERM
# Load production resolver functions; real rpm macro expansion is intentional.
eval "$(sed -n '/^is_source_archive_url()/,/^# Source-url:/p' "$topdir/bin/rpmgs" | sed '$d')"
eval_spec() { rpmbuild -bE "$1"; }
get_var() { sed -n "s/^$1:[[:space:]]*//Ip" | head -n1; }
cat > "$tmpdir/package.spec" <<'SPEC'
Name: fixture
Version: 2.0
Release: alt1
Summary: Fixture
License: CC0
Group: Development/Other
Vcs: https://upstream/archive/%version/%name-%version.tar.gz?download=1
Source: %name-%version.tar
%description
Fixture
SPEC
GETSOURCEGIT=stale GETSOURCEURL=''
get_source_vcs "$tmpdir/package.spec" Source
[ -z "$GETSOURCEGIT" ]
[ "$GETSOURCEURL" = 'https://upstream/archive/2.0/fixture-2.0.tar.gz?download=1' ]
if get_source_vcs "$tmpdir/package.spec" Source1; then exit 1; fi
for url in 'https://upstream/source.tar.xz#hash' 'ftp://upstream/source.zip' 'https://upstream/source.tgz'; do
	is_source_archive_url "$url"
done
for url in 'https://upstream/repo.git' 'git://upstream/source.tar.gz' 'https://upstream/repository'; do
	if is_source_archive_url "$url"; then exit 1; fi
done
sed -i 's|^Vcs:.*|Vcs: https://upstream/%name.git|' "$tmpdir/package.spec"
GETSOURCEGIT='' GETSOURCEURL=''
get_source_vcs "$tmpdir/package.spec" Source0
[ "$GETSOURCEGIT" = 'https://upstream/fixture.git' ]
[ -z "$GETSOURCEURL" ]
echo 'rpmgs VCS archive tests passed'
