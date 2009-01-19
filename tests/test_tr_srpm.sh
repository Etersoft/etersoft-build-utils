#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
. $ETERBUILDDIR/functions/rpm

prepare_unpacked_package()
{
	local TMPBPDIR=$RPMDIR/BP
	mkdir -p $TMPBPDIR
	rpm -iv --define "_srcrpmdir $TMPBPDIR/SRPMS" $1

}

install_srpm_package()
{
	local TMPBPDIR=$RPMDIR/BP
	mkdir -p $TMPBPDIR
	rpm -iv --define "_topdir $TMPBPDIR" $1
}

pack_srpm_package()
{
	local TMPBPDIR=$RPMDIR/BP
	LISTNAMES=$1
	export RPMTOPDIR=$TMPBPDIR
	#rm $TMPBPDIR/SOURCES/apache*
	pack_src_rpm
}

export IGNOREGEAR=1

for i in `ls -1 $RPMDIR/SRPMS` ; do
	PKGNAME=$RPMDIR/SRPMS/$i
	echo "get for $i:"
	install_srpm_package $PKGNAME
	SPECNAME=$RPMDIR/BP/SPECS/$(rpm -qp --queryformat "%{NAME}" $PKGNAME).spec
	echo "spec: $SPECNAME"
	pack_srpm_package $SPECNAME
	exit 1
done
