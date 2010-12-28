#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod git


check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}

check 1 "-h" "$(drop_args "-h -U" U)"
check 2 "-h" "$(drop_args " -h -U " U)"
check 3 "-U" "$(drop_args " -h -U " h)"
check 4 "-U -i" "$(drop_args " -h -U -i" h)"
check 5 "" "$(drop_args " -h -U " h U)"
check 6 "" "$(drop_args " -h -U " U h)"
check 7 "-z" "$(drop_args "-v -n -z" v n)"
check 8 "" "$(drop_args "$*" v n)"
check 9 "" "$(drop_args "" f a t)"
