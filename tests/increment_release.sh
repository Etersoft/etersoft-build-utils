#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}


get_release()
{
	#echo "Warning: Error test %test" >&2
	echo $TESTREL
}

get_version()
{
	echo $TESTVER
}

set_release()
{
	echo "$2"
}

set_version()
{
	echo "$2"
}


TESTREL=alt5
check inc_subrelease "alt5.1" `inc_subrelease ""`

TESTREL=alt6.2
check inc_subrelease "alt6.3" `inc_subrelease ""`

# FIXME: strange behaviour
TESTREL=alt6.r5001
check inc_subrelease "alt6.r5001" `inc_subrelease ""`


TESTREL=alt5
check inc_release "alt6" `inc_release ""`

TESTREL=alt6.2
check inc_release "alt7" `inc_release ""`

TESTVER=1.5.7
check inc_version "1.5.8" `inc_version ""`
