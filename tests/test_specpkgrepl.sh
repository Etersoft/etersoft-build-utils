#!/bin/sh

if [ -n "$1" ] ; then
    SPECNAME="$1"
else
    SPECNAME=specpkgr.spec
    cp -f specpkgr.spec.in $SPECNAME
fi

VERBOSE=1 TARGETARCH=i586 BASEARCH=x86_64 DISTRNAME=AstraLinux DISTRVERSION=orel bash ../bin/rpmbps $SPECNAME
