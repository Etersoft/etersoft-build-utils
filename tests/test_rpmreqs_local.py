from pathlib import Path
import os
import subprocess
import tempfile
import unittest
ROOT = Path(__file__).resolve().parents[1]

class LocalFileRequirements(unittest.TestCase):
    def run_resolver(self, packages, requirements):
        with tempfile.TemporaryDirectory() as tmp:
            root=Path(tmp); repo=root/'repo with spaces'; repo.mkdir()
            for filename, (name, files) in packages.items():
                (repo/filename).write_text(name+'\n'+'\n'.join(files)+'\n')
            source=(ROOT/'bin/rpmreqs').read_text()
            function=source.split('resolve_local_file_requirements()\n',1)[1].split('\nconvert_pkgfile_to_pkgname()',1)[0]
            stub='''rpm() {
  if [ "$1" = -qpl ]; then tail -n +2 "$2";
  else head -n 1 "${@: -1}"; fi
}
'''
            result=subprocess.run(['bash'],input=stub+'resolve_local_file_requirements()\n'+function+
                                  '\nresolve_local_file_requirements\nprintf "%s\\n%s\\n" "$REQLIST" "$LOCALPKGNAMES"\n',
                                  text=True,capture_output=True,check=True,
                                  env=dict(os.environ,RPMREQS_PACKAGE_DIRS=str(repo),REQLIST=requirements))
            return [line.split() for line in result.stdout.splitlines()]

    def test_resolves_both_architectures_without_changing_other_requires(self):
        for arch in ('i586','x86_64'):
            result=self.run_resolver({'nxssh-1.'+arch+'.rpm':('nxssh',['/usr/bin/nxssh'])},
                                     '/usr/bin/nxssh /bin/sh libX11.so.6 libfoo')
            self.assertEqual(result,[['/bin/sh','libX11.so.6','libfoo'],['nxssh']])

    def test_ambiguous_provider_is_left_to_existing_resolver(self):
        result=self.run_resolver({'a.rpm':('a',['/bin/example']),'b.rpm':('b',['/bin/example'])},'/bin/example')
        self.assertEqual(result,[['/bin/example'],[]])

    def test_multiple_versions_of_same_provider_are_unambiguous(self):
        result=self.run_resolver({'a-1.rpm':('a',['/bin/example']),'a-2.rpm':('a',['/bin/example'])},'/bin/example')
        self.assertEqual(result,[[],['a']])

if __name__=='__main__': unittest.main()
