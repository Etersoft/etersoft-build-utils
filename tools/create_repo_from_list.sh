#!/bin/sh

# Etersoft (c) 2010
# Author: Vitaly Lipatov <lav@etersoft.ru>
# Public domain

# create repo from pkg list (from system or from list)
# need packages to be installed

# load common functions, compatible with local and installed script
. `dirname $0`/../share/eterbuild/functions/common
load_mod rpm

ORIGREPO=/var/ftp/pub/ALTLinux/5.0
DESTREPO=/var/ftp/pub/Etersoft/LINUX@Etersoft/branch/builder50
RPMSEXT=base
ARCHLIST="noarch i586 x86_64"

for i in $ARCHLIST; do
	mkdir -p $DESTREPO/$i/RPMS.$RPMSEXT
done

# Get pkg list
if [ -n "$1" ] ; then
	PKGLIST=$(cat "$1")
else
	PKGLIST=$(rpm -qa)
fi

for i in $PKGLIST ; do
	#PKGNAME=$(querypackage $i "" "%{name}-%{version}-%{release}")
	PKGNAME=$i
	# TODO: do package try instead query info
	PKGARCH=$(querypackage $i "" "%{arch}")
	REALFILE=$ORIGREPO/$PKGARCH/RPMS.classic/$PKGNAME.$PKGARCH.rpm
	#echo "$PKGNAME, real package: $REALFILE"
	test -e "$REALFILE" || { echo "ERROR: $REALFILE for $PKGNAME is missed" >&2 ; continue ; }
	ln $REALFILE $DESTREPO/$PKGARCH/RPMS.$RPMSEXT/$(basename $REALFILE)
done

for i in $ARCHLIST ; do
	mkdir -p $DESTREPO/$i/base
	echo
	echo "Genbasedir for $DESTREPO/$i"
	genbasedir -v --topdir=$DESTREPO $i $RPMSEXT
done
