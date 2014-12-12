#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
#load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

check "-f TEST" "$(usearg -f TEST)" "-f TEST"
check "-f 'TEST MORE'" "$(usearg -f 'TEST MORE')" "-f TEST MORE"
check "-f 'TEST MORE'" "$(usearg -f TEST MORE)" "-f TEST"
check "-f 'TEST TEST'" "$(usearg -f TEST TEST)" ""
check "TEST=$TEST-f \$TEST" "$(usearg -f $TEST)" ""
TEST=124
check "TEST=$TEST -f \$TEST" "$(usearg -f $TEST)" "-f 124"
