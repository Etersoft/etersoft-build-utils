#!/bin/sh
LIST="$1"
[ -n "$LIST" ] || LIST=list

REPO="/var/ftp/pub/ALTLinux/c7/branch/*/RPMS.classic"

for i in $(cat $LIST) ; do
    # print found files
    ls -1 $REPO/${i}*.rpm && continue
    echo "$i" >>$LIST.missed
done | grep -v "/i586/"
