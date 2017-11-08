#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
#load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

# TODO: move to lib
isnumber()
{
	#local num="$(("$*"))"
	echo "$*" | filter_strip_spaces | grep -q "^[0-9]\+$"
	#[ "$num" != "0" ]
}

check_arg()
{
	check "$1" "$(isnumber "$1" ; echo $?)" "$2"
}

check_arg "" "1"
check_arg " " "1"
check_arg "5" "0"
check_arg " 6" "0"
check_arg "7 " "0"
check_arg "12" "0"
check_arg "12 5" "1"
check_arg "12 q" "1"
check_arg "q" "1"
check_arg "q w" "1"
check_arg "52q" "1"
check_arg "q52" "1"
