Name: etersoft-build-utils
Version: 1.5.4
Release: alt1

Summary: A set of build rpm utilities

License: Public domain
Group: Development/Other
Url: http://www.freesource.info/wiki/AltLinux/Razrabotchiku/SborkaPaketov

Packager: Vitaly Lipatov <lav@altlinux.ru>

# git-clone http://git.altlinux.org/people/lav/packages/etersoft-build-utils.git
Source: %name-%version.tar

BuildArchitectures: noarch

%define altcompat_ver 0.95

# C compiler is required in rpm-build; we do not require C++ here
Requires: rpm-build rpm-build-compat >= %altcompat_ver
BuildRequires: rpm-build-compat >= %altcompat_ver

%if %_vendor == "alt"
Requires: sisyphus_check rsync openssh-clients srpmcmp
%else
# ALT has it in RPM
BuildRoot: %{_tmppath}/%{name}-%{version}
%endif

%description
This package contains a set of helper utils for RPM building process.
See info in Russian
on %url.

RECOMMENDED packages: gcc-c++ perl-libwww ccache elinks mutt hasher curl

%prep
%setup -q

%build
%make

%install
# install to datadir and so on
%makeinstall
%find_lang %name

%files -f %name.lang
%doc AUTHORS README TODO NEWS QuickHelp* 
%doc tools/upload-to-alt tools/ls-incoming tools/check_spec.sh
%_bindir/*
%_datadir/eterbuild/
# for backward compatibility (will removed in 2.0)
%_sysconfdir/rpm/etersoft-build-functions
%dir %_sysconfdir/eterbuild/
%dir %_sysconfdir/eterbuild/apt/
%config(noreplace) %_sysconfdir/eterbuild/apt/apt.conf.*
%config(noreplace) %_sysconfdir/eterbuild/apt/sources.list.*
%config(noreplace) %_sysconfdir/eterbuild/config
%config(noreplace) %_sysconfdir/eterbuild/repos

%changelog
* Tue Jan 06 2009 Vitaly Lipatov <lav@altlinux.ru> 1.5.4-alt1
- introduce eterbuild/eterbuild script for public use
- cleanup code, remove obsoleted functions
- add support set version via rpmgs
- fix build result detecting

* Sun Jan 04 2009 Vitaly Lipatov <lav@altlinux.ru> 1.5.3-alt1
- add IGNOREGEAR env var support
- detect package arch from spec
- rpmgp: use getopt, add -d options for download package (list only by default)

* Sat Dec 13 2008 Vitaly Lipatov <lav@altlinux.ru> 1.5.2-alt1
- really 1.5.2, cleanup code
- rewrite rpmgp: use getopt, add -d options for download package
- use gear via vars, do not require it

* Thu Dec 11 2008 Vitaly Lipatov <lav@altlinux.ru> 1.5.1-alt2
- add get_version, fix inc_release, inc_subrelease
- clean up code (thanks Slava Semushin for comments)
- fix rpmbb -r (buildreq) with git

* Sat Dec 06 2008 Vitaly Lipatov <lav@altlinux.ru> 1.5.1-alt1
- APTCONF sets used apt.conf if defined
- add support for x86_64 build with generic i586 sources.list
- set git tag during rpmbs -s
- fix release checking in universal manner
- skip sisyphus_check if build from git
- update QuickHelp, remove unneeded comments
- fix __python_ and so on incorrect replacement
- disable __subst and libtoolize/autoconf and so on replacement
- fix _datadir/doc replacement (altbug #16604)
- use fonts-ttf-liberation from loginhsh

* Wed Oct 29 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.9-alt1
- add macroses from rpm-build-fonts
- support Mandriva 2009
- update pkgrepl rules
- bin/rpmrb: fix to use rpmrb without version
- bin/rpmgp: fix package download

* Sun Jul 20 2008 Vitaly Lipatov <lav@altlinux.ru> 1.5.0-alt1
- build from git, move install commands to makefile
- move /etc/rpm/etersoft-build-config to /etc/eterbuild/config
- move /etc/rpm/etersoft-build-functions to /usr/share/eterbuild/common
- update README, TODO

* Thu Jul 17 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.8-alt1
- bin/rpmgp: add support for get src.rpm from various rpm repos
- do not override CC/CXX, disable ccache detecting
- add support for M42
- update pkgrepl rules

* Thu Jul 03 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.7-alt1
- bin/rpmbs: add -z support (legacy compression)
- bin/rpmcs: disable change source tarball name by default
- bin/rpmbugs: use Sisyphus product for bugzilla
- bin/rpmbph: create rpms with legacy compression without spec line

* Fri Jun 27 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.6-alt1
- bin/rpmbph: use gzip method for backported src.rpm
- improve rpmqf to support links and files in the current dir
- update pkgrepl rules

* Fri Jun 13 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.5-alt1
- fix M41 build (fix bug #15969)
- add M41 support to rpmbph

* Thu May 29 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.4-alt1
- fix M40 upload to updates
- rpmurl: add -p option for open sisyphus.ru page for the package

* Sat May 10 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.3-alt1
- add M41 (backport/update) support
- fix missed defattr injecting in rpmbph
- run add_changelog separately for each spec (fix altbug #15495) in rpmgs
- disable attr removing, remove only defattr(-,root,root) in rpmcs
- fix defattr injecting (add missed |) in rpmbph (thanks to boris@)

* Mon Mar 24 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.2-alt1
- do not replace source ext in git repo case
- add more rules for removing %%_macroses
- fix Group replacement

* Sat Feb 23 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.1-alt1
- fix Group replacement
- add python macroses support in rpmcs
- small fixes

* Sat Jan 19 2008 Vitaly Lipatov <lav@altlinux.ru> 1.4.0-alt1
- cleanup spec
- add rpm-build repl for SUSE
- use perl -pe for replacing, small fixes
- clean up rpmcs code
- fix bug #13974

* Fri Jan 11 2008 Vitaly Lipatov <lav@altlinux.ru> 1.3.5-alt3
- fix prepare_tarball function
- fix rpmbph for curret distro detect

* Thu Jan 10 2008 Vitaly Lipatov <lav@altlinux.ru> 1.3.5-alt2
- fix rpmcs hang
- fix rpmbph on ALT spec changelogs
- more correctly clean pkgreqs

* Thu Jan 10 2008 Vitaly Lipatov <lav@altlinux.ru> 1.3.5-alt1
- add -l key to rpmgp (lists buildreqs for the spec)
- big update of pkg replacement files (Xorg, NX, Postgres...)
- introduce rpmunmets script for unmets detect in fresh packages
- improve BuildReq handling in rpmbph
- fix replace package names only in *Req* and *Group* spec lines in rpmcs
- add -o key to rpmbs for nosrc.rpm generating

* Thu Dec 27 2007 Vitaly Lipatov <lav@altlinux.ru> 1.3.4-alt3
- fix replacements only in *Req* and Group* lines
- small fixes
- update replacemens for NX build

* Thu Dec 13 2007 Vitaly Lipatov <lav@altlinux.ru> 1.3.4-alt2
- remove empty tags (buildreq and so on)
- add perl-devel and python-devel replacements
- fix ALT Linux 3.0 replacements

* Thu Nov 08 2007 Vitaly Lipatov <lav@altlinux.ru> 1.3.4-alt1
- write package release as in ALT
- fix rpmbph to support %%{_vendor}, %%_vendor, eter in release
- use bash for rpmbph, rpmbs
- major update replacement list (check by Wine build)
- add replacements for modularized XOrg packages
- rename mandriva tag release to mdv
- fix rpmbph for legacy mktemp using
- add gconf_schema_install replacement to rpmcs (fix bug #13614)

* Wed Nov 07 2007 Vitaly Lipatov <lav@altlinux.ru> 1.3.3-alt1
- add support to upload to incoming/Update (-U option)
- update replacement list (special Mandriva rules)
- add tbz2 tarball support
- fix build log greping
- update README

* Sun Oct 28 2007 Vitaly Lipatov <lav@altlinux.ru> 1.3.2-alt1
- small fixes in rpmbph scripts
- update replacement list
- add support for Incoming/Updates (-U key instead -u for upload)

* Tue Sep 25 2007 Vitaly Lipatov <lav@altlinux.ru> 1.3.1-alt1
- fix rpmbph on ALT, add error handling in rpmcs
- add git support in mkpatch, use .orig firstly
- add some rules for Debian, Mandriva, common rules for rpm, deb

* Sat Sep 08 2007 Vitaly Lipatov <lav@altlinux.ru> 1.3-alt1
- improve rpmbph to support any target system
- use replacement lists in rpmbph and rpmcs
- add git support in mkpatch

* Mon Aug 06 2007 Vitaly Lipatov <lav@altlinux.ru> 1.2-alt1
- fix rpmbb for use with gear (thanks to php-coder@)
- improve rpmcs
- fix pack_src_rpm()

* Mon Jul 10 2007 Vitaly Lipatov <lav@altlinux.ru> 1.1.9-alt1
- alpha version, all systems support in rpmbph
- add all rpm based system initial support in rpmbph
- add parallel bzip (pbzip2) support
- add -r (remote) option to rpmrb

* Wed May 30 2007 Vitaly Lipatov <lav@altlinux.ru> 1.1.8-alt1
- add support for ALT Linux 4.0 backports
- remove hasher from requires, add check for hsh
- set download timeouts against sf.net mirrors lags
- cleanup chroot after loginhsh using

* Fri Mar 16 2007 Vitaly Lipatov <lav@altlinux.ru> 1.1.7-alt1
- rpmrb: remove minor version if only major used (fix bug #11103)
- detect sticky tag when recheckout from cvs
- use alt1 release as default for new release
- myhsh: use --mountpoints=/proc,/dev/pts by default

* Thu Jan 18 2007 Vitaly Lipatov <lav@altlinux.ru> 1.1.6-alt1
- small changes, remove hack for glibc-i686 requires
- fix check url in rpmurl

* Wed Dec 27 2006 Vitaly Lipatov <lav@altlinux.ru> 1.1.5-alt1
- add test with bzip -t for tarballs
- use bash for rpmbb (due dash problem on Ubuntu 6.10)
- fix some replacements in rpmbph
- disable ccache warning

* Sun Nov 19 2006 Vitaly Lipatov <lav@altlinux.ru> 1.1.4-alt1
- add initial support for gear/git
- add local mode for prepare_tarball (without cvs using)
- fix temp dir create, fix project directory name using
- fix nice using
- update library replacing to rpmbph
- fix mkpatch behaviour
- some hasher args fixes
- some bugfixes

* Tue May 23 2006 Vitaly Lipatov <lav@altlinux.ru> 1.1.3-alt1
- smallfix release (see NEWS)
- improve hasher using (disable buildtime, support for x86_64)
- improve mkpatch

* Sun Apr 09 2006 Vitaly Lipatov <lav@altlinux.ru> 1.1.2-alt1
- add mkpatch for make patch against one file in source tree
- remove -v from hsh args by default (fix bug #9387)
- some improvements (see NEWS)

* Wed Mar 08 2006 Vitaly Lipatov <lav@altlinux.ru> 1.1.1-alt1
- bugfix release (see NEWS)

* Sun Mar 05 2006 Vitaly Lipatov <lav@altlinux.ru> 1.1-alt1
- some improvements (see NEWS), small bugfixes
- use apt.conf.SS/sources.list.SS by default now
- add check_spec.sh for compare rpmcs results with original specs
- remove elinks, perl-libwww, ccache requires (thanks mithraen@ for Uwaga)

* Tue Feb 21 2006 Vitaly Lipatov <lav@altlinux.ru> 1.0-alt1
- welcome to future improvement release (see NEWS)
- add functions for release small project (publish and rpmish)
- add nice to rpmbuild
- improve to more compatibility with other Linux distros

* Wed Feb 15 2006 Vitaly Lipatov <lav@altlinux.ru> 0.99.9-alt1
- some improvements (see NEWS)
- add fixes for ignore /etc/apt/sources.list.d/*
- add requires for rpm-build-*-compat
- test on various Linux distros (see README)
- fix Source URL
- temporarely disabled requires for rpm-build-compat

* Sat Jan 28 2006 Vitaly Lipatov <lav@altlinux.ru> 0.99.8-alt1
- some improvements (see NEWS)
- remove rpmlint from the package requires
- add console output in rpmbugs (f.i. use rpmbugs bug_number)
- add support for rpm-build-compact (for backports support)

* Wed Jan 04 2006 Vitaly Lipatov <lav@altlinux.ru> 0.99.7-alt1
- some improvements (see NEWS)
- remove cbuildreq

* Tue Dec 27 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99.6-alt3
- fix small mistakes in scripts

* Mon Dec 26 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99.6-alt2
- fix use loginhsh

* Mon Dec 26 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99.6-alt1
- add M31 build support
- remove gcc-c/c++ dependencies
- rename bashbsh to loginhsh
- disable mail report (was broken feature)

* Sat Dec 24 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99.5-alt1
- add requires for rpm-build-altlinux-compat for non ALT system
- change Incoming host from incoming to devel
- some improvement (see NEWS)

* Mon Dec 05 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99.4-alt1
- change group to Development/Other
- minor fixes

* Sat Nov 26 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99.3-alt1
- minor fixes (prepare for 1.0 release)

* Wed Nov 16 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99.2-alt1
- minor fixes
- support for test install into hasher

* Fri Nov 04 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99.1-alt1
- new version (major option parsing rewrite)
- ls-incoming added

* Sat Oct 15 2005 Vitaly Lipatov <lav@altlinux.ru> 0.99-alt1
- new version (bug fix release)
- upload-to-alt script restored

* Sun Sep 18 2005 Vitaly Lipatov <lav@altlinux.ru> 0.98-alt1
- new version (code rewrite, more smart options)
- remove upload-to-alt scripts (use -u option for rpmbs(h) instead)

* Sun Sep 11 2005 Vitaly Lipatov <lav@altlinux.ru> 0.97-alt1
- new version (more utilites, improve usability)

* Sat Sep 10 2005 Vitaly Lipatov <lav@altlinux.ru> 0.96-alt1
- new version

* Wed Sep 07 2005 Vitaly Lipatov <lav@altlinux.ru> 0.95-alt1
- new version (code rewrite)

* Tue Sep 06 2005 Vitaly Lipatov <lav@altlinux.ru> 0.94-alt1
- bugfix release (fix BUILDROOT, update translation)

* Mon Sep 05 2005 Vitaly Lipatov <lav@altlinux.ru> 0.93-alt1
- new version (code rewrite, more functionality, see README)

* Sat Sep 03 2005 Vitaly Lipatov <lav@altlinux.ru> 0.92-alt1
- new version (see NEWS)

* Wed Aug 24 2005 Vitaly Lipatov <lav@altlinux.ru> 0.91-alt1
- new version (small changes)

* Wed Aug 03 2005 Vitaly Lipatov <lav@altlinux.ru> 0.9-alt0.3
- fix unexpanded macros again

* Sat Jul 30 2005 Vitaly Lipatov <lav@altlinux.ru> 0.9-alt0.2
- fix bug #7491 (unexpanded macros)

* Sun Jun 05 2005 Vitaly Lipatov <lav@altlinux.ru> 0.9-alt0.1
- add requires for C/C++ compilers
- add russian translation for script messages

* Fri Apr 15 2005 Vitaly Lipatov <lav@altlinux.ru> 0.7-alt1
- new release (other repository support)

* Sat Apr 09 2005 Vitaly Lipatov <lav@altlinux.ru> 0.6-alt1
- bugfix release
- fix missing rpm-build-functions

* Wed Mar 09 2005 Vitaly Lipatov <lav@altlinux.ru> 0.5-alt1
- new release

* Mon Feb 28 2005 Vitaly Lipatov <lav@altlinux.ru> 0.4-alt0.1
- first build for ALT Linux Sisyphus
