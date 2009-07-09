#!/bin/sh

# load common functions, compatible with local and installed script
NEEDETERBUILD=162
. /usr/share/eterbuild/eterbuild
load_mod spec etersoft

# Note: write spec name manually if autodetect is failed
SPECNAME=$(basename $(pwd)).spec

# publish to unstable by default
ALPHA=unstable
if [ "$1" = "-r" ] ; then
	ALPHA=$2
	shift 2
fi

# Note: write target path manually if autodetect is failed
#export ETERDESTSRPM=/var/ftp/pub/Etersoft/CIFS@Etersoft/$VERSION/sources
export ETERDESTSRPM=$(get_etersoft_srpm_path $SPECNAME $ALPHA)

rpmbs -s $SPECNAME || fatal "Can't build SRPMS"

# set last link (assume PROJECT/VERSION/sources dir structure)
set_last_link $ETERDESTSRPM/.. $(get_version $SPECNAME)
