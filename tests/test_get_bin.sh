#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod rpm hasher

MENVARG=$1
test -n "$MENVARG" || MENVARG=-SS
set_hasherdir

for i in `ls -1 $HASHERDIR/repo/SRPMS.hasher` ; do
	echo "get for $i:"
	LISTNAMES=`get_binpkg_list $HASHERDIR/repo/$BUILDARCH/RPMS.hasher $(basename $i)`
	echo $LISTNAMES
	echo "without ext: $(drop_pkg_extensions $LISTNAMES)"
done
