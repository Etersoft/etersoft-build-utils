#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1 $TESTREL': result '$3' do not match with '$2'" || echo "OK for '$1 $TESTREL' with '$2'"
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
check inc_release "alt7.r5001" `inc_release ""`
check inc_subrelease "alt6.r5001.1" `inc_subrelease ""`


TESTREL=alt5
check inc_release "alt6" `inc_release ""`
check inc_subrelease "alt5.1" `inc_subrelease ""`

TESTREL=alt6.2
check inc_release "alt7" `inc_release ""`
check inc_subrelease "alt6.3" `inc_subrelease ""`

#TESTVER=1.5.7
#check inc_version "1.5.8" `inc_version ""`

TESTREL=alt6.eter51
check inc_release "alt7.eter51" `inc_release ""`
check inc_subrelease "alt6.eter51.1" `inc_subrelease ""`

TESTREL=alt5.14f23
check inc_release "alt6.14f23" `inc_release ""`

TESTREL=alt4.ff
check inc_release "alt5.ff" `inc_release ""`

TESTREL=alt3.git20110916
check inc_release "alt4.git20110916" `inc_release ""`
check inc_subrelease "alt3.git20110916.1" `inc_subrelease ""`

TESTREL=alt3.git20130916.2
check inc_release "alt4.git20130916" `inc_release ""`
check inc_subrelease "alt3.git20130916.3" `inc_subrelease ""`

TESTREL=alt2.M80P.3
check inc_release "alt2.M80P.4" `inc_release ""`
check inc_subrelease "alt2.M80P.3.1" `inc_subrelease ""`

TESTREL=alt3.git20110916
check inc_release "alt4.git20110916" `inc_release ""`

TESTREL=alt3.S1
check inc_release "alt4.S1" `inc_release ""`

# FIXME: strange behaviour
TESTREL=alt7.M70C.14
check inc_release "alt7.M70C.15" `inc_release ""`
check inc_subrelease "alt7.M70C.14.1" `inc_subrelease ""`

TESTREL=alt7.M70C.14 is_backported_release $TESTREL && echo "backported: $TESTREL" || echo "FAILED: $TESTREL"
TESTREL=alt7 is_backported_release $TESTREL && echo "not packported: $TESTREL" || echo "FAILED: $TESTREL"
#TESTREL=alt7.SS.14 is_backported_release $TESTREL && echo "backported: $TESTREL" || echo "FAILED: $TESTREL"
