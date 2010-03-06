#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
#load_mod spec

check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}

for GEAR in git.alt git.eter ; do
	for BRANCH in sisyphus 5.1 5.0 4.1 4.0 3.0 ; do
		RSYNCPATH=$(get_rsync_path $GEAR $BRANCH)
		echo
		check_rsync $RSYNCPATH && echo "OK with $RSYNCPATH for $GEAR $BRANCH" || echo "FAILED with $RSYNCPATH for $GEAR $BRANCH"
	done
done
