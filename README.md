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
| `rpmgp -g <name>` | Clone git repository with package |
| `rpmgp -c <name>` | Check if package is published |

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
