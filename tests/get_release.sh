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

set_release()
{
	echo "$2"
}

get_mn_fromspec()
{
	# fix also in function/spec
	#MAJOR=`echo "$BASERELEASE" | sed -e "s|\..*||"`
	MAJOR=`echo "$BASERELEASE" | sed -e "s|\..*||"`
	#MAJOR=`echo "$BASERELEASE" | sed -e "s|^\([0-9a-zA-Z]*\)\..*|\1|"`
	#MAJOR=`echo "$BASERELEASE" | sed -e "s|^\([0-9a-zA-Z]*\)\..*|\1|"`
	MINOR=`echo "$BASERELEASE" | sed -e "s|.*\.||"`
	if [ "$
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
get_mn_fromspec
check MAJOR  27 $MAJOR
check MINOR 5 $MINOR

BASERELEASE=35
get_mn_fromspec
check MAJOR 35 $MAJOR
check MINOR "35" "$MINOR"

BASERELEASE=27.5.r12002
get_mn_fromspec
check MAJOR  27.5 $MAJOR
check MINOR r12002 $MINOR

BASERELEASE=27.5.2
get_mn_fromspec
check MAJOR  27.5 $MAJOR
check MINOR 2 $MINOR


