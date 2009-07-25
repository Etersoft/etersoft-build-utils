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

VENDOR=Fedora
TARGET=rpm
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

echo "Correct replacement checking for $VENDOR/$DISTRVERSION (target $TARGET):"
check_repl rpm-build-compat rpm-build-altlinux-compat
check_repl libusb-devel libusb-devel


VENDOR=Debian
TARGET=deb
DISTRVERSION=5.0

echo "Correct replacement checking for $VENDOR/$DISTRVERSION (target $TARGET):"
check_repl rpm-build-compat rpm-build-altlinux-compat
check_repl libusb-devel libusb-dev
