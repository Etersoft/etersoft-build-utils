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
check 3 "field2 field4" "`do_exclude_list "field1 field3" "$LIST2"`"
#check 4 "" "`do_exclude_list "field3 field[24]" "$LIST2"`"
check 5 "$LIST2" "`do_exclude_list "fiel" "$LIST2"`"
check 6 "$LIST2" "`do_exclude_list "" "$LIST2"`"
check "reg 1" "field1" "`regexp_exclude_list "field3 field[24]" "$LIST2"`"
check "reg 2" "$LIST2" "`regexp_exclude_list "fiel" "$LIST2"`"
check "reg 3" "field1 field3" "`regexp_exclude_list "field[24]" "$LIST2"`"

check "remove 1" "field1" "`remove_from_list "field2" "$LIST1"`"
check "remove 2" "" "`remove_from_list "field." "$LIST2"`"
check "remove 3" "list" "`remove_from_list "field." "$LIST2 list"`"
check "remove 3" "field2 field4" "`remove_from_list "field[13]" "$LIST2"`"
check "remove 4" "$LIST2" "`remove_from_list "fiel" "$LIST2"`"
#check "remove 5" "field4" "`remove_from_list "field2 field[13]" "$LIST2"`"
check "remove 6" "$LIST2" "`remove_from_list "" "$LIST2"`"

check "strip1" "test" "`strip_spaces " test "`"
check "strip2" "test" "`strip_spaces "test "`"
check "strip3" "test" "`strip_spaces " test"`"
