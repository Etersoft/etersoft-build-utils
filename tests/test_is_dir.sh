#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod strings

check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}

checkit()
{
	local RES
	is_dirpath "$1"
	RES=$?
	check "$1" "$2" "$RES"
}

checkit . 0
checkit text 1
checkit text/ 0
checkit /text 0
checkit /text/test 0
