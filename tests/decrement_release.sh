#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

check_dec()
{
	check $1 `decrement_release $1` $2
}

check_dec 39 38
check_dec 39.1 38
check_dec 39cvs 38
check_dec 39.1cvs 38
check_dec cvs 0
