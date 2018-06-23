#!/bin/bash

# load common functions, compatible with local and installed script
. `dirname $0`/../share/eterbuild/functions/common
load_mod alt

#testfile=$(echo /var/ftp/pub/Etersoft/RX@Etersoft/testing/CentOS/6/nxclient-*.i586.rpm)
#testfile=$(echo /var/ftp/pub/Etersoft/RX@Etersoft/testing/CentOS/5/nxclient-*.i586.rpm)
testfile=$(echo /var/ftp/pub/Etersoft/WINE@Etersoft/2.0-testing/WINE/ALTLinux/Sisyphus/wine-etersoft-*.i586.rpm)
#testfile=$(echo /var/ftp/pub/Etersoft/RX@Etersoft/testing/ALTLinux/Sisyphus/rx-etersoft-*.i586.rpm)
REQLIST="$($ETERBUILDBIN/rpmreqs -p "$testfile")"
echo $REQLIST
echo "---"
trans_rpmdeps_to_pkgname $REQLIST
