#!/bin/sh


if [ "$1" = "--detail" ] ; then
    for i in bin/* share/eterbuild/functions/* ; do
        echo
        echo "==== $i:"
        /usr/lib/rpm/shell.req $i
    done
    exit 0
fi


/usr/lib/rpm/shell.req bin/* share/eterbuild/functions/* | sort -u | tee ./check_et.log
git diff ./check_et.log
