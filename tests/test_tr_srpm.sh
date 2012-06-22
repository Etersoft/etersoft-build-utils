#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
. $ETERBUILDDIR/functions/rpm
. $ETERBUILDDIR/functions/buildsrpm

install_srpm_package()
{
	uni_rpminstall $1
}

pack_srpm_package()
{
	LISTNAMES=$1 pack_src_rpm
}

export IGNOREGEAR=1

RPMTOPDIR=$RPMDIR/BP
SRPMSDIR=/var/ftp/pub/Etersoft/Sisyphus/sources

for PKGNAME in `ls -1 $SRPMSDIR/it*` ; do
	test -f $PKGNAME || continue
	echo "get for $PKGNAME:"
	install_srpm_package $PKGNAME
	SPECNAME=$RPMTOPDIR/SPECS/$(spec_by_srpm $PKGNAME)
	echo "spec: $SPECNAME"
	pack_srpm_package $SPECNAME
	echo Compare $PKGNAME $LISTBUILT
	# what the package with rpmdiff?
	rpmdiff $PKGNAME $LISTBUILT
	exit 1
done
