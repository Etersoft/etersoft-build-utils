#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod rpm hasher

MENV=SS
set_hasherdir

for i in `ls -1 $HASHERDIR/repo/SRPMS.hasher` ; do
	echo "get for $i:"
	get_binpkg_list $HASHERDIR/repo/$DEFAULTARCH/RPMS.hasher $(basename $i)
done
