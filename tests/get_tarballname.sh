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

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
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

subst "s|Source:.*|Source: http://fp.ru/python-larch_1.20131130.orig.tar.gz|g" $SPEC
check_get_version python-larch
subst "s|Source:.*|Source0: http://fp.ru/python-larch_1.20131130.orig.tar.gz|g" $SPEC
check_get_version python-larch

[ -n "$1" ] && SPEC="$1"

build_rpms_name $SPEC

#echo "Tarball from rules"
#get_tardir_from_rules tar wine-staging-2.4.0.tar || echo "No tarball"
#get_tardir_from_rules tar || echo "No tarball"
#get_tardir_from_rules tar.gz || echo "No tarball"

echo "Test ostree"
# TODO: fake .gear
cd /home/lav/Projects/git-alt/containers/ostree
SPEC=ostree.spec
build_rpms_name $SPEC

check_tarball()
{
    local TARBALL="$1"
    local TARDIR=$(get_tardir_from_rules "$(get_ext $TARBALL)" $(basename "$TARBALL"))
    check "$1" "$(basename $TARDIR)" "$2"
}
check_tarball ostree-2017.8.tar ostree
check_tarball libglnx.tar libglnx
check_tarball bsdiff.tar bsdiff

# TODO: в rules может задаваться другой name архива

echo "DONE"
