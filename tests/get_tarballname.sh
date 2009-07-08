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
Version: $TESTVER
Source: %name-%version.tar.bz2
Summary: Test
Group: Other
License: Public License
%define major 1.0
%define ver 10
%define maj 1.0

%description
Get version test
EOF

RESGET=`get_tarballname $SPEC`
	[ "$RES" != "$RESGET" ] && echo "FATAL with 'get_tarballname': result '$RES' do not match with '$RESGET'" || echo "OK for 'get_tarballname' with '$RESGET'"
}

TESTVER=1.0.10
check_get_version get_version_test

rm -f $SPEC
