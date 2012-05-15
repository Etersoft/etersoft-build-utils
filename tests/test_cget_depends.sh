#!/bin/bash

# load common functions, compatible with local and installed script
. `dirname $0`/../share/eterbuild/functions/common
load_mod alt

#testfile=$(echo /var/ftp/pub/Etersoft/RX@Etersoft/testing/CentOS/6/nxclient-*.i586.rpm)
testfile=$(echo /var/ftp/pub/Etersoft/RX@Etersoft/testing/ALTLinux/Sisyphus/rx-etersoft-*.i586.rpm)
trans_rpmdeps_to_pkgname $testfile
