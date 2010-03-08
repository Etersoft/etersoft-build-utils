#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
. $ETERBUILDDIR/functions/rpm

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

for i in `ls -1 $RPMDIR/SRPMS` ; do
	PKGNAME=$RPMDIR/SRPMS/$i
	echo "get for $i:"
	install_srpm_package $PKGNAME
	SPECNAME=$RPMTOPDIR/SPECS/$(spec_by_srpm $PKGNAME)
	echo "spec: $SPECNAME"
	pack_srpm_package $SPECNAME
	echo Compare $PKGNAME $LISTBUILT
	# what the package with rpmdiff?
	rpmdiff $PKGNAME $RPMTOPDIR/SRPMS/$LISTBUILT
	exit 1
done
