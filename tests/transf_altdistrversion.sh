#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$3'"
}

check_AD()
{
	check $1 $2 `get_altdistr_version $1`
}

check_MOD()
{
	check $1 $2 `get_altdistr_mod $1`
}

check_GN()
{
	check $1 $2 `get_type_by_git_branch_name $1`
}

echo "Check get_altdistr_version"
check_AD M40 4.0
check_AD M30 3.0
check_AD M41 4.1
check_AD M50 p5
check_AD M51 5.1
check_AD  SS sisyphus

echo "Check get_altdist_mod"
check_MOD 2.4 M24
check_MOD 3.0 M30
check_MOD 4.0 M40
check_MOD 4.1 M41
check_MOD 5.0 M50
check_MOD 5.1 M51
check_MOD  p5 M50
check_MOD  p6 M60
check_MOD Sisyphus SS
check_MOD sisyphuS SS

check_GN M50 M50
check_GN 5.0 M50
check_GN p5 M50
check_GN p7 M70
