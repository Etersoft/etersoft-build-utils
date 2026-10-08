#!/bin/bash
# Integration test using installed ALT rpm-uscan and a loopback HTTP fixture.
set -eu
command -v rpm-uscan >/dev/null || { echo 'SKIP: rpm-uscan is not installed'; exit 0; }
topdir=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
python3 - "$topdir" <<'PY'
import http.server
import pathlib
import subprocess
import sys
import tempfile
import threading

class Releases(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'<a href="source-2.0.tar.gz">2.0</a>'
                         b'<a href="source-9.0.tar.gz">9.0</a>')

    def log_message(self, *args):
        pass

server = http.server.HTTPServer(('127.0.0.1', 0), Releases)
threading.Thread(target=server.serve_forever, daemon=True).start()
rpmgs = pathlib.Path(sys.argv[1], 'bin/rpmgs').read_text()
helper = rpmgs.split('\nprepare_watch_source()\n', 1)[1].split('\nwill_commit()\n', 1)[0]
with tempfile.TemporaryDirectory() as temp:
    root = pathlib.Path(temp)
    (root / '.gear').mkdir()
    (root / '.gear/rules').write_text('tar.gz: fixture\n')
    (root / '.gear/autobuild.watch').write_text(
        'version=3\nhttp://127.0.0.1:%d/ source-([0-9.]+).tar.gz\n' % server.server_port)
    (root / 'fixture.spec').write_text('Source: fixture-%version.tar.gz\n')
    script = '''
get_root_git_dir() { pwd; }
get_gear_rules() { echo .gear/rules; }
is_gear() { return 0; }
get_source_git() { return 1; }
get_source_url() { return 1; }
eval_spec() { cat "$1"; }
get_var() { sed -n "s/^$1: //p"; }
rhas() { echo "$1" | grep -q "$2"; }
get_name() { echo fixture; }
get_version() { echo "${WATCH_CURRENT_VERSION:-1.0}"; }
make_temp_file() { mktemp; }
assure() { :; }
fatal() { echo "$*" >&2; exit 1; }
EPMCMD=assure SPECDIR=.
prepare_watch_source()
''' + helper + '''
GSSETVERSION="$1"
prepare_watch_source fixture.spec
printf '%s\\n%s\\n' "$GSSETVERSION" "$WATCHSOURCEURL"
'''
    for requested, expected in [('2.0', '2.0'), ('', '9.0')]:
        result = subprocess.run(['bash', '-c', script, 'test', requested],
                                cwd=root, text=True, capture_output=True)
        assert result.returncode == 0, result.stderr + result.stdout
        lines = result.stdout.splitlines()
        assert lines == [expected, 'http://127.0.0.1:%d/source-%s.tar.gz'
                         % (server.server_port, expected)], lines
    # Both implicit up-to-date and explicit current-release recovery work.
    for requested in ['', '9.0']:
        result = subprocess.run(['bash', '-c', 'WATCH_CURRENT_VERSION=9.0\n' + script,
                                 'test', requested], cwd=root, text=True, capture_output=True)
        assert result.returncode == 0, result.stderr + result.stdout
        assert result.stdout.splitlines()[0] == '9.0', result.stdout
    result = subprocess.run(['bash', '-c', script, 'test', '3.0'],
                            cwd=root, text=True, capture_output=True)
    assert result.returncode != 0, 'missing release was accepted'
server.shutdown()
print('rpmgs real rpm-uscan integration tests passed')
PY
