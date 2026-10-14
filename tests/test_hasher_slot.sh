#!/bin/bash
# Test directory selection and CLI inheritance without invoking hasher.
set -eu

topdir=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
load_mod() { :; }
fatal() { echo "$*" >&2; exit 1; }
# Only bypass the installed hasher executable check; exercise the real selector.
source <(sed 's|HSH=/usr/bin/hsh|HSH=/bin/true|' "$topdir/share/eterbuild/functions/hasher")
HASHERBASEDIR=/tmp/hasher
MENVARG=-sisyphus
BUILDARCH=x86_64
HASHER_SLOT=
HASHER_AUTO_SLOTS=yes
set_hasherdir
[ "$HASHERDIR" = /tmp/hasher-sisyphus-64 ]
HASHER_SLOT=worker1
set_hasherdir
[ "$HASHERDIR" = /tmp/hasher-sisyphus-64-slot-worker1 ]
HASHER_SLOT=worker2
set_hasherdir
[ "$HASHERDIR" = /tmp/hasher-sisyphus-64-slot-worker2 ]
BUILDARCH=aarch64
set_hasherdir
[ "$HASHERDIR" = /tmp/hasher-sisyphus-aarch64-slot-worker2 ]
BUILDARCH=i586
set_hasherdir
[ "$HASHERDIR" = /tmp/hasher-sisyphus-slot-worker2 ]
if (HASHER_SLOT='../bad'; set_hasherdir) 2>/dev/null; then
	echo 'Invalid slot was accepted' >&2
	exit 1
fi
if (unset HASHER_AUTO_SLOTS; HASHER_SLOT=worker1; set_hasherdir) 2>/dev/null; then
	echo 'Explicit slot was accepted while slots are disabled' >&2
	exit 1
fi

# Load each real option parser, bypassing common initialization and main IO.
for command in rpmbsh myhsh loginhsh; do
	(
		set +u
		source <(sed '/^\. .*functions\/common$/d' "$topdir/bin/$command" |
			awk '/^set_girar_host / || /^parse_cmd_pre / || /^#parse_cmd_pre / { exit } { print }')
		HASHER_SLOT=environment
		OPTIND=1
		mygetopts -S cli_worker
		[ "$HASHER_SLOT" = cli_worker ]
		# Helpers launched by rpmbsh inherit the consumed option as environment.
		[ "$(bash -c 'printf %s "$HASHER_SLOT"')" = cli_worker ]
		case "$LISTRPMARGS" in *-S*|*cli_worker*) exit 1 ;; esac
		BUILDARCH=x86_64
		set_hasherdir
		[ "$HASHERDIR" = /tmp/hasher-sisyphus-64-slot-cli_worker ]
		if [ "$command" = loginhsh ]; then
			OPTIND=1
			mygetopts -t
			# Exercise the actual test/postfix selection block.
			source <(sed -n '/^if \[ -n "\$HASHERPOSTFIX" \]/,/^fi$/p' "$topdir/bin/loginhsh")
			[ "$HASHERDIR" = /tmp/hasher-sisyphus-64-slot-cli_worker-test ]
		fi
	)
done
# Exercise actual file locks in separate shells, without invoking hasher.
export -f load_mod fatal set_hasherdir hasher_slot_inherited acquire_hasher_slot
source <(sed -n '/^make_temp_file()/,/^}/p' "$topdir/share/eterbuild/functions/common")
rhas() { [[ $1 =~ $2 ]]; }
export -f make_temp_file rhas print_tmp_aptconf print_tmp_sourceslist prepare_aptconfig
python3 - <<'PY'
import os
from pathlib import Path
import subprocess
import tempfile
import time
import signal

def timed_out(signum, frame):
    raise TimeoutError("hasher slot test timed out")

signal.signal(signal.SIGALRM, timed_out)
signal.alarm(15)

workers = []
script = '''
acquire_hasher_slot "${MODE:-}"
printf '%s\\n' "$HASHERDIR"
# A helper must reuse both directory and open lock, even after config reload.
bash -c 'HASHER_SLOT=config; set_hasherdir; acquire_hasher_slot; printf "%s\\n" "$HASHERDIR"'
read -r release
'''

def start(base, slot='', mode='', auto_slots='yes'):
    env = dict(os.environ, HASHERBASEDIR=base, MENVARG='-test',
               BUILDARCH='x86_64', HASHER_SLOT=slot, MODE=mode)
    env.pop('HASHER_AUTO_SLOTS', None)
    if auto_slots is not None:
        env['HASHER_AUTO_SLOTS'] = auto_slots
    p = subprocess.Popen(['bash', '-eu', '-c', script], env=env,
                         stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                         text=True)
    workers.append(p)
    return p

def ready(p, expected):
    assert p.stdout.readline().strip() == expected
    assert p.stdout.readline().strip() == expected  # descendant, no deadlock

def release(p):
    p.communicate('release\n', timeout=5)
    assert p.returncode == 0

try:
    with tempfile.TemporaryDirectory(prefix='ebu-hasher-slot-') as tmp:
        base = tmp + '/hasher'
        normal = base + '-test-64'
        # Unconfigured and explicitly disabled builds wait for the base directory.
        import select
        for setting in (None, 'no'):
            first = start(base, auto_slots=setting)
            ready(first, normal)
            waiter = start(base, auto_slots=setting)
            time.sleep(0.1)
            assert not select.select([waiter.stdout], [], [], 0)[0]
            assert not Path(normal + '-slot-1.ebu-lock').exists()
            release(first)
            ready(waiter, normal)
            release(waiter)

        first = start(base)
        ready(first, normal)
        second = start(base)
        ready(second, normal + '-slot-1')
        release(second)
        third = start(base)
        ready(third, normal + '-slot-1')  # reuse after normal exit
        third.terminate()
        third.wait(timeout=5)
        fourth = start(base)
        ready(fourth, normal + '-slot-1')  # reuse after termination
        release(fourth)
        release(first)
        reused = start(base)
        ready(reused, normal)
        release(reused)

        explicit = start(base, slot='named')
        ready(explicit, normal + '-slot-named')
        waiter = start(base, slot='named')
        time.sleep(0.1)
        assert waiter.poll() is None
        # No output means it has not entered the occupied directory.
        import select
        assert not select.select([waiter.stdout], [], [], 0)[0]
        release(explicit)
        ready(waiter, normal + '-slot-named')
        release(waiter)

        fixed = start(base, mode='fixed')
        ready(fixed, normal)
        fixed_waiter = start(base, mode='fixed')
        time.sleep(0.1)
        assert not select.select([fixed_waiter.stdout], [], [], 0)[0]
        release(fixed)
        ready(fixed_waiter, normal)
        release(fixed_waiter)

        # Same branch, different arches and additional repos must not share apt files.
        fixture_sources = Path(tmp, 'sources.list.sisyphus')
        fixture_sources.write_text('rpm file:/repo i586 classic\n')
        fixture_conf = Path(tmp, 'apt.conf')
        fixture_conf.write_text(f'Dir::Etc::sourcelist "{fixture_sources}";\n')
        apt_workers = []
        for arch in ('x86_64', 'aarch64'):
            env = dict(os.environ, TMPDIR=tmp, OURTMPDIR=tmp,
                       MENV='sisyphus', APTCONF=str(fixture_conf), ETERBUILDETC='/etc/eterbuild',
                       BUILDARCH=arch, QUIETMODE='1',
                       ETERBUILD_APTREPO=f'rpm file:/extra-{arch} {arch} classic')
            p = subprocess.Popen(['bash', '-eu', '-c',
                'prepare_aptconfig; printf "%s\\n%s\\n" "$OURAPTCONF" "$OURSOURCES"; read -r release'],
                env=env, stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
            workers.append(p)
            conf, sources = [Path(p.stdout.readline().strip()) for _ in range(2)]
            apt_workers.append((p, arch, conf, sources))
        assert apt_workers[0][2:] != apt_workers[1][2:]
        for p, arch, conf, sources in apt_workers:
            assert conf.read_text() == f'Dir::Etc::sourcelist "{sources}";\n'
            expected = f'rpm file:/repo {arch} classic\n'
            assert sources.read_text().startswith(expected)
            assert f'extra-{arch}' in sources.read_text()
            other_arch = 'aarch64' if arch == 'x86_64' else 'x86_64'
            assert f'extra-{other_arch}' not in sources.read_text()
            release(p)
finally:
    for worker in workers:
        if worker.poll() is None:
            worker.kill()
            worker.wait()
PY
printf '%s\n' 'hasher slot tests: OK'
