#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
. $ETERBUILDDIR/functions/rpm

HASHERDIR=$HASHERDIR-SS
get_binpkg_list $HASHERDIR/repo/$DEFAULTARCH/RPMS.hasher asymptote-1.43-alt1.src.rpm
