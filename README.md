# etersoft-build-utils

A set of helper utilities for RPM package building on ALT Linux and other RPM-based distributions.

[Документация на русском / Russian documentation](README.ru.md)

## Installation

```bash
apt-get install etersoft-build-utils
```

## Configuration

Set target distribution in `~/.config/eterbuild`:

```bash
MENV=p11     # for ALT Linux p11
MENV=p10     # for ALT Linux p10
MENV=SS      # for Sisyphus
```

## Main Commands

### Building packages

| Command | Description |
|---------|-------------|
| `rpmbb [spec]` | Build binary package |
| `rpmbs [spec]` | Create source RPM |
| `rpmbsh [spec]` | Build package in hasher (isolated environment) |
| `rpmbph -b <branch> [spec]` | Backport package to another branch |

### Source management

| Command | Description |
|---------|-------------|
| `rpmgs [spec]` | Download sources from spec file |
| `rpmgs -C [spec] [version]` | Update to a new version without adding a changelog entry |
| `rpmgp -g <name>` | Clone git repository with package |
| `rpmgp -c <name>` | Check if package is published |

For a gear package with a local tarball rule and a watch file (for example,
`.gear/autobuild.watch`), `rpmgs` uses `rpm-uscan` to find the source archive.
An explicit version selects that exact release with `--download-version`;
without a version it selects the latest release. The archive is imported using
existing gear rules and hooks. Watch errors stop the update. Explicit VCS/script
schemes, upstream remotes and `HEAD` keep their existing update paths.

### Git/GIRAR operations

| Command | Description |
|---------|-------------|
| `gita` / `gitask` | GIRAR task management wrapper |
| `gita ls` | List your tasks |
| `gita new [branch]` | Create new task |
| `gita add <cmd> <pkg>` | Add subtask |
| `gita run [task]` | Run task |
| `gita log [task]` | Show build log |
| `gita wait [task]` | Wait for task to complete |
| `gita acl <pkg> [add\|del <user>]` | Show/modify package ACL |

### Spec file utilities

| Command | Description |
|---------|-------------|
| `rpmcs [spec]` | Cleanup spec (foreign spec adoption) |
| `rpmlog [spec ...]` | Update version and changelog in one or several spec files |
| `rpmurl [spec]` | Open URL from spec in browser |
| `rpmbugs [spec]` | Open bug list for package |

### Hasher utilities

| Command | Description |
|---------|-------------|
| `loginhsh` | Log in to hasher shell |
| `myhsh` | Manage hasher environment |
| `runinhsh` | Run command inside hasher |

Additional hasher directories are disabled by default: concurrent builds wait
for the usual directory. To enable them, set `HASHER_AUTO_SLOTS=yes` in
`~/.config/eterbuild` (or the system configuration).
Concurrent `rpmbsh` and `myhsh` builds then automatically use separate directories.
The first build uses the usual directory; other active builds use `-slot-1`,
`-slot-2`, and so on. A directory lock covers both the build and subsequent
installation test, and is released when the processes exit. Child helpers
reuse the selected directory. Hasher selects the available user pair itself.

With `HASHER_AUTO_SLOTS=yes`, an explicit slot is optional, for example when
inspecting a particular worker:

```bash
HASHER_SLOT=worker1 rpmbsh -t package.spec
rpmbsh -S worker2 -t package.spec
loginhsh -S worker1 -t
```

`rpmbsh`, `myhsh` and `loginhsh` accept `-S SLOT` (letters, digits, `_`, `-`)
or `HASHER_SLOT`. An explicit slot waits for its directory to become free.
Standalone `loginhsh`, `myhsh -p`, `myhsh -r`, and rebuilds with `-e` keep
using the requested directory; they never select another worker's directory.
The test directory adds `-test` after the selected build directory.
Before a build (`myhsh`, `rpmbsh`) and when initializing (`loginhsh -i`) it recognizes the exact empty scaffold left by
an interrupted `hsh-mkchroot` before its ownership setup completed. Under hasher's
native directory lock it preserves that scaffold in `chroot-incomplete.XXXXXX`
inside the work directory, then lets hasher choose a user pair and initialize
normally. Populated, symlinked and unrecognized chroots are left to hasher.
`loginhsh -c` cleans the work directory and its `-test` one (chroot and aptbox),
keeping the directory with its repo and cache; `loginhsh -c -a` cleans every
hasher directory. A directory in use by a build is skipped, not waited for.

### Build helpers

| Command | Description |
|---------|-------------|
| `jmake` | Make with parallel build and ccache |
| `dmake` | Distributed make |

## Common Options

- `-s` — sign package
- `-u` / `-U` — upload to Incoming/Backports
- `-i` — install after build
- `-r` — update build requirements
- `-h` — show help

## Package Replacement Rules

Rules for cross-distribution package name mapping (used by `rpmbph`):

```
alt-package-name|foreign-package-name
```

Rule files in `share/eterbuild/pkgrepl/`:
- `pkgrepl.rpm` — base rules
- `pkgrepl.<distro>` — distribution-specific rules
- `pkgrepl.<distro>.<version>` — version-specific rules

## Requirements

- `~/.rpmmacros` — RPM macros configuration
- `~/.gnupg/` — GPG keys for signing
- `~/.ssh/` — SSH keys for git.alt access
- `git.alt` alias in `~/.ssh/config`

## Documentation

- [ALT Linux Wiki (Russian)](http://www.altlinux.org/Etersoft-build-utils_howto)

## Author

Vitaly Lipatov <lav@etersoft.ru>

## License

Apache 2.0
