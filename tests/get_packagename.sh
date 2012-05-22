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
check_pkg pkg123[_-]1.0.spec pkg123
check_pkg pkg*.spec pkg
check_pkg libpq5.2-9.0eter-9.0.4-alt14.i586.rpm libpq5.2-9.0eter
check_pkg postgre-etersoft9.0_9.0.4-eter14ubuntu_i386.deb postgre-etersoft9.0