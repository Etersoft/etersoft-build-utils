#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec rpm

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

check_pkg()
{
	check "$1" $(get_pkgname_from_filename "$1") "$2"
}

check_pkg pkg-1.0.spec pkg
check_pkg pkg-source-1.0.spec pkg-source
check_pkg pkg-source-less-1.0.spec pkg-source-less
check_pkg pkg123-1.0.spec pkg123
