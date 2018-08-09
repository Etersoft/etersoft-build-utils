#!/bin/sh

LIST="$1"
[ -n "$LIST" ] || LIST=paths.txt

cat $LIST | sed -e "s|.*/||" | sort -u

