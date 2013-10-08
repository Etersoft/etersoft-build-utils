#!/bin/bash

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

SPEC=get_ver.spec
gen_spec()
{
cat <<EOF >$SPEC
Name: get_version_test
Release: alt1
Version: $TESTVER
Source: $SOURCEPATH%name-%version.tar.bz2
Summary: Test
Group: Other
License: Public License
%define major 1.0
%define ver 10
%define maj 1.0

%build
pushd txt
echo {1,2}text
%__subst "s|1|2|g" text/{1,eweew}
%__subst "s|1re er| erer2|g" text/{1,eweew} nono
mkdir ${LOCATION}/{loc1,dedt,ohi}
mkdir $LOCATION/{loc1,dedt,ohi}
popd

%description
Get version test
%changelog
* Date
- Hello
  * dsdkljd
* Date

EOF
}

TESTVER=0
SOURCEPATH=ftp://etersoft.ru/pub/Etersoft/TEST/
gen_spec
remove_bashism $SPEC
mv $SPEC $SPEC.new
gen_spec
diff -u $SPEC $SPEC.new
