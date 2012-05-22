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

PKGVENDOR=fedora
PKGFORMAT=rpm
DISTRVERSION=10

echo "PkgRepl:"
get_pkglist
echo
#check pkgrepl "fedora" `get_pkglist`

echo "GrpRepl:"
get_grplist
echo

check_repl()
{
	check $1 "`print_replace $1`" $2
}

echo "Replacement files for $PKGVENDOR/$DISTRVERSION (target $PKGFORMAT):"
check_repl rpm-build-compat rpm-build-altlinux-compat
check_repl libusb-devel libusb-devel


PKGVENDOR=ubuntu
PKGFORMAT=deb
DISTRVERSION=11.04

echo "Replacement files for $PKGVENDOR/$DISTRVERSION (target $PKGFORMAT):"

print_pkgrepl_list

check_repl rpm-build-compat rpm-build-altlinux-compat
check_repl libusb-devel libusb-dev


PKGVENDOR=mdv
DISTRVERSION=2010.1
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
