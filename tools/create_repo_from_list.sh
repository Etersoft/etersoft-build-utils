#!/bin/sh

# Etersoft (c) 2010
# Author: Vitaly Lipatov <lav@etersoft.ru>
# Public domain

# create repo from pkg list (from system or from list)
# need packages to be installed

# load common functions, compatible with local and installed script
#. `dirname $0`/../share/eterbuild/functions/common
#load_mod rpm

ORIGREPO=/var/ftp/pub/ALTLinux/5.0
DESTREPO=/var/ftp/pub/Etersoft/LINUX@Etersoft/5.0/asu
RPMSEXT=base
# FIXME: no support for list arch
ARCHLIST="i586 noarch"

for i in $ARCHLIST; do
	mkdir -p $DESTREPO/$i/RPMS.$RPMSEXT
done

if [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
	echo "create new repo in $DESTREPO based on packages installed in the current system"
	exit
fi

# Get pkg list
if [ -n "$1" ] ; then
	PKGLIST=$(cat "$1")
else
	PKGLIST=$(rpm -qa)
fi

for i in $PKGLIST ; do
	#PKGNAME=$(querypackage $i "" "%{name}-%{version}-%{release}")
	#PKGARCH=$(querypackage $i %{arch}")
	PKGNAME=$i
	PKGARCH=""
	for i in $ARCHLIST ; do
		REALFILE=$ORIGREPO/$i/RPMS.classic/$PKGNAME.$i.rpm
		test -e "$REALFILE" && { PKGARCH=$i ; break ; }
	done

	# Если не нашли с данной версией, ищем без версии
	if false && [ -z "$PKGARCH" ] ; then
		for i in $ARCHLIST ; do
			REALFILE=$ORIGREPO/$i/RPMS.classic/$i.$i.rpm
			test -e "$REALFILE" && { PKGARCH=$i ; break ; }
		done
	fi

	#echo "$PKGNAME, real package: $REALFILE"
	test -e "$REALFILE" || { echo "ERROR: $PKGNAME is missed" >&2; continue ; }
	DESTFILE=$DESTREPO/$PKGARCH/RPMS.$RPMSEXT/$(basename $REALFILE)
	test -e "$DESTFILE" && continue
	ln "$REALFILE" "$DESTFILE"
done

for i in $ARCHLIST ; do
	mkdir -p $DESTREPO/$i/base
	echo
	echo "Genbasedir for $DESTREPO/$i"
	genbasedir -v --topdir=$DESTREPO $i $RPMSEXT
done
