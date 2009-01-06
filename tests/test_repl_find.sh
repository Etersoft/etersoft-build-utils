#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod repl

# Проблемы: из-за жадного .* заменяется только последний пакет в строке
#
check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}


get_pkglist()
{
VENDOR=Fedora
TARGET=rpm
DISTRVERSION=10
for i in `print_pkgrepl_list` ; do
	echo $(basename $i)
done
}

get_grplist()
{
VENDOR=Fedora
TARGET=rpm
DISTRVERSION=10
for i in `print_grprepl_list` ; do
	echo $(basename $i)
done
}

echo "PkgRepl:"
get_pkglist
echo
check pkgrepl "fedora" `get_pkglist`

echo "GrpRepl:"
get_grplist
echo
