#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod strings

LIST1="field1 field2"
LIST2="field1 field2 field3 field4"
LIST3="field"

check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}

check 1 "field3 field4" "`do_exclude_list "$LIST1" "$LIST2"`"
check 2 "" "`do_exclude_list "$LIST2" "$LIST1"`"
check 3 "field" "`do_exclude_list "$LIST1" "$LIST3"`"
