#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
#load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

check_docmd()
{
	check "$1" " \$ $1" "$(docmd $1 | head -n1)"
}


func()
{
docmd ls $@
docmd ls "$@"
ls "$@"
}

#func 1 "1 2"
#func 1 2 3

TERMOUTPUT=

check_docmd "true false"
check_docmd "true -n"
