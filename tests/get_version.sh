#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

SPEC=get_ver.spec

check_get_version()
{
RES=$1
cat <<EOF >$SPEC
Name: get_version_test
Release: alt1
Summary: Test
Group: Other
License: Public License
%define major 1.0
%define ver 10
%define maj 1.0
Version: $TESTVER

%description
Get version test
EOF
RESGET=`get_version $SPEC`
	[ "$RES" != "$RESGET" ] && echo "FATAL with 'get_version': result '$RES' do not match with '$RESGET'" || echo "OK for 'get_version' with '$RESGET'"
}

TESTVER=1.0.10
check_get_version 1.0.10

# spec evals only on ALT
TESTVER=%major.10
check_get_version 1.0.10

TESTVER=%maj.%ver
check_get_version 1.0.10

rm -f $SPEC
