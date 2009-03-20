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


TESTREL=alt2
check get_release alt2 `get_release`

# simple release N
TESTREL=alt3
check get_numrelease 3 `get_numrelease`

TESTREL=alt36
check get_numrelease 36 `get_numrelease`

TESTREL=alt4
check get_txtrelease alt `get_txtrelease`

TESTREL=alt36
check get_txtrelease alt `get_txtrelease`

# simple release N
TESTREL=alt3test
check Tget_numrelease 3 `get_numrelease`

TESTREL=alt4test
check Tget_txtrelease alt `get_txtrelease`

# release N.N
TESTREL=alt3.1
check get_numrelease 3.1 `get_numrelease`

TESTREL=alt4.2
check get_txtrelease alt `get_txtrelease`

BASERELEASE=27.5
MAJOR=`echo "$BASERELEASE" | sed -e "s|\..*||"`
MINOR=`echo "$BASERELEASE" | sed -e "s|.*\.||"`

check MAJOR  27 $MAJOR
check MINOR 5 $MINOR

BASERELEASE=35
MAJOR=`echo "$BASERELEASE" | sed -e "s|\..*||"`
MINOR=`echo "$BASERELEASE" | sed -e "s|.*\.||"`

check MAJOR 35 $MAJOR
check MINOR "35" "$MINOR"

