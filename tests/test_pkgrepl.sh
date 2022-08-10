#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod repl

SPECNAME=specpkgr.spec
cp -f specpkgr.spec.in $SPECNAME
touch ~/RPM/SOURCES/specpkgr.source

export VERBOSE=1
export IGNOREGEAR=1
#sh ../bin/rpmbph -n -M51 specpkgr.spec

#export ROOTDIR=/net/os/stable/CentOS/7
#sh ../bin/rpmbph -n specpkgr.spec

check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result 
'$3' do not match with 
'$2'" || echo "OK for '$1' with '$2'"
}

#print_pkgrepl_list


LISTBUILDDEP=`print_buildreq $SPECNAME`
check "BuildDep" "imake xorg-cf-files libxml2-devel gccmakedep python3-module-test rpm-build-compat gcc4.1 gcc" "$LISTBUILDDEP"

echo -
LISTREQDEP=`print_pkgreq $SPECNAME`
check "Reqs" "binutils dbus-tools-gui expect foomatic-db-engine libcups libkrb5-devel libstdc++ libXrender libXi libXext libX11 libICE libXcomposite libXcursor libXinerama libXrandr netcat nx openssl /usr/bin/xvt Xdialog" "$LISTREQDEP"
