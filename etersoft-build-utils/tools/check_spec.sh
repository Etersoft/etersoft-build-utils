#!/bin/sh
# copy specs to separate tree, make rpmcs and printout diff
. /etc/eterbuild/common

cd $RPMDIR

TMPSPEC=`mktemp -d`
OTMPSPEC=`mktemp -d`
cp -r SPECS/* $TMPSPEC
cp -r SPECS/* $OTMPSPEC
find $TMPSPEC -type f -name "*.spec" | xargs -n 1 rpmcs 2>&1 | tee $0.r.out
find $TMPSPEC -type f -name "*~" | xargs rm -f
find $OTMPSPEC -type f -name "*~" | xargs rm -f
diff -urN $OTMPSPEC $TMPSPEC >$0.out
rm -rf $TMPSPEC $OTMPSPEC
