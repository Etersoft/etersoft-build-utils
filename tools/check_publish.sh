#!/bin/sh
# copy specs to separate tree, make rpmcs and printout diff

# load common functions, compatible with local and installed script
. `dirname $0`/../share/eterbuild/functions/common

SPECLIST=`find $RPMDIR/SPECS -type f -name "*.spec"`
for i in $SPECLIST ; do
	if echo $i | grep -q HELP ; then
		continue
	fi
	LANG=C rpmgp -c $i 2>&1 | grep -v "^Note" | grep -v "^Checking" | grep -v "^Repository"
done
# | xargs -n 1 rpmcs 2>&1 | tee $0.r.out
