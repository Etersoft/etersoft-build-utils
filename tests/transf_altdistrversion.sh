#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

check_AD()
{
	check $1 $2 `get_altdistr_version $1`
}

check_MOD()
{
	check $1 $2 `get_altdistr_mod $1`
}


echo "Check get_altdistr_version"
check_AD M40 4.0
check_AD M30 3.0
check_AD M41 4.1
check_AD M50 5.0
check_AD  SS Sisyphus

echo "Check get_altdist_mod"
check_MOD 2.4 M24
check_MOD 3.0 M30
check_MOD 4.0 M40
check_MOD 4.1 M41
check_MOD 5.0 M50
check_MOD Sisyphus SS
