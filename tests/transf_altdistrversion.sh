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
check_AD M50P p5
check_AD M60T t6
check_AD  SS sisyphus

echo "Check get_altdist_mod"
check_MOD  p5 M50P
check_MOD  p6 M60P
check_MOD  t6 M60T
check_MOD  p9 M90P
check_MOD  c9f2 c9f2
check_MOD  c9 c9
check_MOD  p10 p10
check_MOD Sisyphus sisyphus
check_MOD sisyphuS sisyphus

check_GN M50P M50P
check_GN p5 M50P
check_GN p6 M60P
check_GN t6 M60T
check_GN p7 M70P
