#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1 $TESTREL': result '$3' do not match with '$2'" || echo "OK for '$1 $TESTREL' with '$2'"
}


get_release()
{
	echo $TESTREL
}

# capture the release set_release would write to the spec
set_var()
{
	echo "$3"
}


# empty second arg resets release to <prefix>1 (used by rpmlog -n/-v)
TESTREL=eter2
check set_release "eter1" `set_release spec`

TESTREL=eter1
check set_release "eter1" `set_release spec`

TESTREL=alt5
check set_release "alt1" `set_release spec`

TESTREL=alt6.2
check set_release "alt1" `set_release spec`

TESTREL=alt3.git20110916
check set_release "alt1" `set_release spec`

# explicit second arg is written as is
TESTREL=eter2
check set_release "eter5" `set_release spec eter5`
