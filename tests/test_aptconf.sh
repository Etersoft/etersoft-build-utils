#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
. $ETERBUILDDIR/functions/hasher

print_tmp_aptconf $APTCONF
echo "-------------------------------"
print_tmp_aptconf /etc/apt/apt.conf.SS
