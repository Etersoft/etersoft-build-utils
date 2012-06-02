#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
#load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

echo "$(usearg -f TEST)"
echo "$(usearg -f TEST MORE)"
echo "$(usearg -f $TEST)"
TEST=124
echo "$(usearg -f $TEST)"
