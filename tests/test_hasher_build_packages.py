"""Explicit dependency providers must be passed as one safe hasher argument."""
import os
from pathlib import Path
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class HasherBuildPackages(unittest.TestCase):
    def run_arg(self, value):
        return subprocess.run(['bash', '-c', f'''
            load_mod() {{ :; }}
            error() {{ echo "$*" >&2; }}
            . {ROOT}/share/eterbuild/functions/hasher
            hasher_build_packages_arg
        '''], env=dict(os.environ, ETERBUILD_HASHER_BUILD_PACKAGES=value),
            text=True, capture_output=True)

    def test_keeps_default_build_packages(self):
        for value in ('wine-etersoft-devel-tools', 'wine32-etersoft-devel-tools,zlib-devel'):
            result = self.run_arg(value)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(result.stdout.strip(), '--pkg-build-list=+' + value)

    def test_empty_does_not_override_defaults(self):
        result = self.run_arg('')
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout, '')

    def test_rejects_shell_and_argument_injection(self):
        for value in ('pkg --verbose', 'pkg;echo', '$(touch /tmp/invalid)', '-pkg', 'pkg,,other'):
            with self.subTest(value=value):
                result = self.run_arg(value)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, '')
