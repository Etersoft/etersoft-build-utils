#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec etersoft

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

%description
Get version test
EOF
}

check_get_version()
{
RES=$1
RESGET=`get_tarballname $SPEC`
	[ "$RES" != "$RESGET" ] && echo "FATAL with 'get_tarballname': result '$RES' do not match with '$RESGET'" || echo "OK for 'get_tarballname' with '$RESGET'"
}

TESTVER=1.0.10
SOURCEPATH=
gen_spec
check_get_version get_version_test

SOURCEPATH=ftp://etersoft.ru/pub/Etersoft/TEST/
echo "Source path $SOURCEPATH: "
gen_spec
get_etersoft_srpm_path $SPEC

SOURCEPATH=/var/ftp/pub/Etersoft/TEST/
echo "Source path $SOURCEPATH: "
gen_spec
get_etersoft_srpm_path $SPEC

SOURCEPATH=ftp.eter:/var/ftp/pub/Etersoft/TEST/
echo "Source path $SOURCEPATH: "
gen_spec
get_etersoft_srpm_path $SPEC

SOURCEPATH=ftp://somecompany.ru/Etersoft/TEST/
echo "Source path $SOURCEPATH: "
gen_spec
get_etersoft_srpm_path $SPEC

echo "TODO"
subst "s|Source:.*|Source: http://fp.ru/python-larch_1.20131130.orig.tar.gz|g" $SPEC
check_get_version python-larch

rm -f $SPEC

echo "Tarball"
get_tardir_from_rules || echo "No tarball"

echo "DONE"