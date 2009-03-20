#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}


get_release()
{
	#echo "Warning: Error test %test" >&2
	echo $TESTREL
}

set_release()
{
	echo "$2"
}



TESTREL=alt5
check inc_subrelease "alt5.1" `inc_subrelease ""`

TESTREL=alt6.2
check inc_subrelease "alt6.3" `inc_subrelease ""`


TESTREL=alt5
check inc_release "alt6" `inc_release ""`

TESTREL=alt6.2
check inc_release "alt7" `inc_release ""`

