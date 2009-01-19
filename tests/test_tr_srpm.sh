#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
. $ETERBUILDDIR/functions/rpm

install_srpm_package()
{
	uni_rpminstall $1
}

pack_srpm_package()
{
	LISTNAMES=$1
	pack_src_rpm
}

spec_by_srpm()
{
	local PKGNAME=$1
	echo $(rpm -qp --queryformat "%{NAME}" $PKGNAME).spec
}

export IGNOREGEAR=1

TMPBPDIR=$RPMDIR/BP
RPMTOPDIR=$TMPBPDIR

for i in `ls -1 $RPMDIR/SRPMS` ; do
	PKGNAME=$RPMDIR/SRPMS/$i
	echo "get for $i:"
	install_srpm_package $PKGNAME
	SPECNAME=$RPMDIR/BP/SPECS/$(spec_by_srpm $PKGNAME)
	echo "spec: $SPECNAME"
	pack_srpm_package $SPECNAME
	echo Compare $PKGNAME $LISTBUILT
	rpmdiff $PKGNAME $RPMDIR/BP/SRPMS/$LISTBUILT
	exit 1
done
