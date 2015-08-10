#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod repl

# Проблемы: из-за жадного .* заменяется только последний пакет в строке
#
check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with expected '$3'" || echo "OK for '$1' with '$2'"
}

print_replace()
{
	tolocal_anyrepl $1 `print_pkgrepl_list` || TARGETPKGNAME="$1"
	echo -n "$TARGETPKGNAME"
}


get_pkglist()
{
for i in `print_pkgrepl_list` ; do
	echo $(basename $i)
done
}

get_grplist()
{
for i in `print_grprepl_list` ; do
	echo $(basename $i)
done
}

check_repl()
{
	check "$1" "`print_replace $1`" "$2"
}

# global
BUILDNAME=wine


DISTRNAME=Ubuntu
PKGVENDOR=ubuntu
PKGFORMAT=deb
DISTRVERSION=11.04

echo "Replacement files for $PKGVENDOR/$DISTRVERSION (target $PKGFORMAT):"

print_pkgrepl_list

check_repl rpm-build-compat rpm-build-altlinux-compat
check_repl libusb-devel libusb-1.0-0-dev
check_repl libstdc++ libstdc++


DISTRNAME=Mandriva
PKGVENDOR=mdv
DISTRVERSION=2011
BUILDARCH=x86_64
PKGFORMAT=rpm
#FINDPKG=$PKGREPLBASE.pkgrepl.$VENDOR.$DISTRVERSION
#( ls -1 $PKGREPLBASE/pkgrepl.$VENDOR* | grep -v x86_64 ; echo $FINDPKG ) | sort -u | grep "^$FINDPKG\$" -B1000 | sort -r

echo
echo "Replacement files for $PKGVENDOR/$DISTRVERSION (target $PKGFORMAT):"
echo "Package:"
print_pkgrepl_list
echo "Group:"
print_grprepl_list


DISTRNAME=ArchLinux
PKGVENDOR=archlinux
PKGFORMAT=pkg.gz
DISTRVERSION=2012.04

echo "Replacement files for $PKGVENDOR/$DISTRVERSION (target $PKGFORMAT):"

print_pkgrepl_list

check_repl rpm-build-intro rpm-build-altlinux-compat
check_repl libusb-devel libusb
check_repl libX11 libx11

############################# Slackware ##########################

DISTRNAME=Slackware
PKGVENDOR=slackware
PKGFORMAT=pkg.gz
DISTRVERSION=14

echo "Replacement files for $PKGVENDOR/$DISTRVERSION (target $PKGFORMAT):"

print_pkgrepl_list

check_repl libX11-devel libX11

############################# Fedora ##########################
DISTRNAME=Fedora
PKGVENDOR=fedora
DISTRVERSION=21
BUILDARCH=x86_64
PKGFORMAT=rpm

echo
echo "Replacement files for $PKGVENDOR/$DISTRVERSION (target $PKGFORMAT):"
print_pkgrepl_list

check_repl fontconfig-devel "fontconfig-devel fontconfig-devel(x86-32)"
check_repl unknown-devel "unknown-devel unknown-devel(x86-32)"
BUILDARCH=i586
check_repl fontconfig-devel "fontconfig-devel"
check_repl unknown-devel "unknown-devel"
BUILDARCH=x86_64
BUILDNAME=test
check_repl fontconfig-devel "fontconfig-devel"
check_repl unknown-devel "unknown-devel"

check_repl rpm-build-compat rpm-build-altlinux-compat
check_repl libusb-devel libusbx-devel



############################# SUSE ##########################
BUILDNAME=wine

DISTRNAME=SUSE
PKGVENDOR=suse
DISTRVERSION=12.3
BUILDARCH=x86_64
PKGFORMAT=rpm

echo
echo "Replacement files for $PKGVENDOR/$DISTRVERSION (target $PKGFORMAT):"
print_pkgrepl_list

check_repl libgphoto2-devel "libgphoto2-devel"
check_repl libgphoto2-6 "libgphoto2-6-32bit"
