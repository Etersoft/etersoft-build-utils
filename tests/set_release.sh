#!/bin/sh

#. /etc/rpm/etersoft-build-functions

#. /usr/share/eterbuild/common

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}


get_release()
{
	echo $TESTREL
}

set_release()
{
	echo "$2"
}

# get 11 from alt11, 12.1 from alt12.1t
get_numrelease()
{
	get_release "$1" | sed -e "s|\([a-Z]*\)\([0-9.]\)[^0-9.]*|\2|"
}

# get alt from alt11
get_txtrelease()
{
	get_release "$1" | sed -e "s|\([a-Z]*\)\([0-9.]\).*|\1|"
}

# inc 2 release to 3
inc_release()
{
	BASERELEASE=$(get_numrelease $1)
	set_release "$i" $(get_txtrelease $1)$(($BASERELEASE + 1 ))
}

# inc 2.x to 2.(x+1) or 2 to 2.1
inc_subrelease()
{
	BASERELEASE=$(get_numrelease $1)
	MAJOR=`echo "$BASERELEASE" | sed -e "s|\..*||"`
	MINOR=`echo "$BASERELEASE" | sed -e "s|.*\.||"`
	[ "$MINOR" = "$BASERELEASE" ] && MINOR="0"
	set_release "$1" "$(get_txtrelease $1)${MAJOR}.$(($MINOR + 1 ))"
}

TESTREL=alt2
check get_release alt2 `get_release`

# simple release N
TESTREL=alt3
check get_numrelease 3 `get_numrelease`

TESTREL=alt4
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

TESTREL=alt5
check inc_subrelease "alt5.1" `inc_subrelease ""`

TESTREL=alt6.2
check inc_subrelease "alt6.3" `inc_subrelease ""`

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

