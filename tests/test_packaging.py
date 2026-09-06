"""Build in an isolated copy and verify installed resources, not just source text."""
import re
import shutil
import subprocess
import tempfile
import unittest
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
NAMES = {'change-management','client-deliverables','due-diligence','engagement-pricing',
         'engagement-setup','financial-modeling','implementation-planning','org-design',
         'process-excellence','project-closeout','project-governance','proposal-development',
         'strategic-analysis','thought-leadership','workshop-facilitation','writing-style'}

def links(root):
    failures = []
    for path in root.rglob('*.md'):
        for target in re.findall(r'\]\(([^)]+)\)', path.read_text()):
            if re.match(r'\w+://|#|mailto:', target):
                continue
            target = target.split('#')[0]
            if not (path.parent / target).is_file():
                failures.append(f'{path.relative_to(root)} -> {target}')
    return failures

class PackagingTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix='consulting build ')
        self.addCleanup(self.tmp.cleanup)
        self.repo = Path(self.tmp.name)
        shutil.copytree(ROOT/'skills', self.repo/'skills')
        shutil.copytree(ROOT/'dist/dispatcher', self.repo/'dist/dispatcher')
        shutil.copyfile(ROOT/'build.sh', self.repo/'build.sh')

    def build(self, success=True):
        result = subprocess.run(['bash', str(self.repo/'build.sh')], capture_output=True, text=True)
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        if success:
            with zipfile.ZipFile(self.repo/'dist/management-consulting.skill') as archive:
                archive.extractall(self.repo/'extracted')
            return self.repo/'extracted/management-consulting'

    def test_source_and_bundle_resources_resolve(self):
        self.assertEqual({p.name for p in (self.repo/'skills').iterdir()}, NAMES)
        self.assertEqual(links(self.repo/'skills'), [])
        bundle = self.build()
        self.assertEqual(links(bundle), [])
        self.assertEqual(len(list(bundle.rglob('SKILL.md'))), 1)
        self.assertEqual({p.stem for p in (bundle/'references').glob('*.md')}, NAMES-{'writing-style'})
        for name in NAMES:
            for folder in ('references','scripts','assets'):
                source = self.repo/'skills'/name/folder
                if not source.exists():
                    continue
                for file in source.rglob('*'):
                    if file.is_file():
                        copied = bundle/'references'/name/folder/file.relative_to(source)
                        self.assertTrue(copied.is_file(), str(copied))
                        self.assertEqual(copied.read_bytes().replace(b'\r\n',b'\n'),file.read_bytes().replace(b'\r\n',b'\n'))
        style = (self.repo/'skills/writing-style/SKILL.md').read_text().split('---',2)[2].strip()
        self.assertIn(style, (bundle/'SKILL.md').read_text())
        self.assertFalse(any(p.name == 'reviews' for p in bundle.rglob('*')))

    def test_same_named_resources_and_binary_assets_survive(self):
        for name in ('strategic-analysis','financial-modeling'):
            resource = self.repo/'skills'/name/'references/same.md'
            resource.write_text(name+'\n')
            assets = self.repo/'skills'/name/'assets'
            assets.mkdir()
            (assets/'test.bin').write_bytes(bytes(range(256)))
        bundle = self.build()
        for name in ('strategic-analysis','financial-modeling'):
            self.assertEqual((bundle/'references'/name/'references/same.md').read_text(),name+'\n')
            self.assertEqual((bundle/'references'/name/'assets/test.bin').read_bytes(),bytes(range(256)))

    def test_crlf_checkout_builds_equivalent_text(self):
        for p in list((self.repo/'skills').rglob('*.md')) + [self.repo/'dist/dispatcher/SKILL.md']:
            p.write_bytes(p.read_bytes().replace(b'\r\n',b'\n').replace(b'\n',b'\r\n'))
        bundle = self.build()
        self.assertEqual(links(bundle), [])
        self.assertTrue(all(b'\r\n' not in p.read_bytes() for p in bundle.rglob('*.md')))

    def test_malformed_skill_fails_build(self):
        (self.repo/'skills/strategic-analysis/SKILL.md').write_text('Missing frontmatter\n')
        self.build(success=False)

    def test_unclosed_frontmatter_fails_build(self):
        (self.repo/'skills/strategic-analysis/SKILL.md').write_text('---\nname: strategic-analysis\n')
        self.build(success=False)

    def test_additional_skill_entrypoint_in_resources_fails_build(self):
        (self.repo/'skills/strategic-analysis/references/SKILL.md').write_text('unexpected skill')
        self.build(success=False)


# This also runs on macOS/Linux when PowerShell is available. No PowerShell
# dependency is introduced for standalone skills or the Desktop bundle.
class OpenAIPackagingTests(unittest.TestCase):
    def test_openai_archive_matches_sources(self):
        import os
        import json
        executable = os.environ.get('CONSULTING_TEST_PWSH') or shutil.which('pwsh')
        if not executable:
            self.skipTest('PowerShell unavailable; set CONSULTING_TEST_PWSH to its executable')
        with tempfile.TemporaryDirectory(prefix='consulting openai ') as temp:
            root = Path(temp)
            for folder in ('skills','assets','.claude-plugin','.codex-plugin'):
                shutil.copytree(ROOT/folder,root/folder)
            for name in ('LICENSE','PRIVACY.md','TERMS.md','README.md','build-openai.ps1'):
                shutil.copyfile(ROOT/name,root/name)
            # A private review must stay outside the upload even when present.
            (root/'reviews').mkdir()
            (root/'reviews/private.md').write_text('not for release')
            output = root/'output with spaces/plugin.zip'
            result = subprocess.run([executable,'-NoProfile','-File',str(root/'build-openai.ps1'),'-OutputPath',str(output)],capture_output=True,text=True)
            self.assertEqual(result.returncode,0,result.stdout+result.stderr)
            with zipfile.ZipFile(output) as archive:
                archive.extractall(root/'extracted')
                self.assertFalse(any('/reviews/' in n for n in archive.namelist()))
            bundle=root/'extracted/management-consulting'
            self.assertEqual({p.parent.name for p in bundle.glob('skills/*/SKILL.md')},NAMES)
            self.assertEqual(links(bundle/'skills'),[])
            for source in (root/'skills').rglob('*'):
                if source.is_file():
                    self.assertEqual(source.read_bytes(),(bundle/'skills'/source.relative_to(root/'skills')).read_bytes())
            versions=[]
            for kind in ('.claude-plugin','.codex-plugin'):
                manifest=json.loads((bundle/kind/'plugin.json').read_text())
                self.assertEqual(manifest['name'],'management-consulting')
                versions.append(manifest['version'])
            self.assertEqual(len(set(versions)),1)
            codex=json.loads((bundle/'.codex-plugin/plugin.json').read_text())
            for field in ('composerIcon','logo'):
                self.assertTrue((bundle/codex['interface'][field]).is_file())

if __name__ == '__main__':
    unittest.main()
