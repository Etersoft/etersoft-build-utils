#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$3'"
}

check_AD()
{
	MENV='undetected'
	set_target_type $1
	check $1 $2 $MENV
}

check_AD M40 M40
check_AD M30 M30
check_AD M41 M41
check_AD M50P M50P
check_AD M60T M60T
check_AD M51 M51
check_AD E51 SS
check_AD  SS SS

