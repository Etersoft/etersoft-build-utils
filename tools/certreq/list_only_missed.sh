#!/bin/sh

LIST="$1"
[ -n "$LIST" ] || LIST=pkgs.list

for i in $(cat $LIST) ; do
    pkg=$(echo $i | sed -e "s|alt.*|alt|")
    grep -q -- $pkg c7-disk.list && continue
    #grep $pkg pkgs.list
    #grep $pkg $LIST
    echo "$i"
done
