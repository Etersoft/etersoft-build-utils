#!/bin/bash
# Recover only the exact empty scaffold left before hsh-mkchroot chgrp.
set -eu
topdir=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
export RECOVERY_MODULE="$topdir/share/eterbuild/functions/hasher"
mkdir -p "$HOME/tmp/claude"
python3 - <<'TESTPY'
import os
from pathlib import Path
import select
import subprocess
import tempfile

script = '''
load_mod() { :; }
fatal() { echo "$*" >&2; exit 1; }
warning() { echo "$*" >&2; return 1; }
source "$RECOVERY_MODULE"
HASHERDIR="$1"
recover_incomplete_hasher_root
'''
with tempfile.TemporaryDirectory(prefix='hasher-recovery-', dir=Path.home() / 'tmp/claude') as tmp:
    base = Path(tmp)
    def scaffold(name):
        work = base / name
        for d in ('.host', '.in', 'dev'):
            (work / 'chroot' / d).mkdir(parents=True)
        return work
    def run(work):
        subprocess.run(['bash', '-eu', '-c', script, 'recovery', str(work)], check=True)
    broken = scaffold('broken')
    run(broken)
    assert not (broken / 'chroot').exists()
    backups = list(broken.glob('chroot-incomplete.*/chroot'))
    assert len(backups) == 1 and (backups[0] / '.host').is_dir()
    run(broken)  # idempotent; no extra backup or failure
    assert len(list(broken.glob('chroot-incomplete.*'))) == 1

    populated = scaffold('populated')
    (populated / 'chroot/dev/keep').write_text('preserve me')
    run(populated)
    assert (populated / 'chroot/dev/keep').read_text() == 'preserve me'
    complete = scaffold('initialized')
    (complete / 'chroot/.out').mkdir()
    run(complete)
    assert (complete / 'chroot/.out').is_dir()
    linked = scaffold('linked')
    (linked / 'chroot/dev').rmdir()
    (linked / 'chroot/dev').symlink_to(populated / 'chroot/dev')
    run(linked)
    assert (linked / 'chroot/dev').is_symlink()

    busy = scaffold('busy')
    holder = subprocess.Popen(['bash', '-eu', '-c',
        'enable -f /usr/lib/bash/lockf lockf; builtin lockf "$1"; echo locked; read -r release',
        'holder', str(busy)], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
    worker = None
    try:
        assert select.select([holder.stdout], [], [], 5)[0]
        assert holder.stdout.readline().strip() == 'locked'
        worker = subprocess.Popen(['bash', '-eu', '-c', script, 'recovery', str(busy)],
                                  stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        try:
            worker.wait(timeout=0.3)
            raise AssertionError('recovery did not wait for native hasher lock')
        except subprocess.TimeoutExpired:
            pass
        assert (busy / 'chroot').is_dir()
        holder.communicate('release\n', timeout=5)
        assert holder.returncode == 0
        _, error = worker.communicate(timeout=5)
        assert worker.returncode == 0, error
        assert not (busy / 'chroot').exists()
    finally:
        if holder.poll() is None:
            holder.kill()
        holder.communicate()
        if worker is not None:
            if worker.poll() is None:
                worker.kill()
            worker.communicate()
print('Hasher incomplete-root recovery checks passed')
TESTPY
