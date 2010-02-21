#!/bin/sh -x
# Vitaly Lipatov (c) 2005
# TODO: DONER is not set :(
# in - request letter
# out - no
# 24.09.05 fixed file attaching

export EMAIL="Vitaly Lipatov <lav@etersoft.ru>"
export LANG=ru_RU.KOI8-R
export RPMDIR=$HOME/RPM
DONER=""

function prepare_mail()
{
    formail -r -k -t -A"X-Loop: lav@etersoft.ru"
    if [ -z "$PACKAGE" ] ; then
	cat <<EOF
Please fill request letter with one line:
    spec package_name
or
    spec full_name_of_package_file.src.rpm
or
    nosrc name/fullname for nosrc.rpm retrieve
-- 
Your spec bash robot from Sisyphus repository
EOF
    else
        cat <<EOF
Request accepted for package(s) '$PACKAGE'
and will send to '${ASKER}' in next mail.
EOF
    cd "$upload" || exit 1
    for i in $PACKAGE ; do
		echo "Package: $i"
		rpmgp -n $i
		cat ${i}* | rpm2cpio | cpio -i "*.spec"
		if [ -n "${PACKAGESRC}" ] ; then
			rpm -i ${i/\.rpm/}*.rpm
			for n in $RPMDIR/SPECS/*.spec ; do
				rpmbuild -bs --nosource '0' --nodeps $n
			done
		fi
    done
    cd -
    fi
    export DONER
}

upload=`mktemp -d $HOME/tmp/getspec.XXX`
cat > $HOME/getspec.ask
PACKAGE=`cat $HOME/getspec.ask | grep "^spec " | sed -e "s|^spec ||g"`
PACKAGESRC=`cat $HOME/getspec.ask | grep "^nosrc " | sed -e "s|^nosrc ||g"`
test -n "$PACKAGESRC" && PACKAGE=$PACKAGESRC
ASKER=`cat $HOME/getspec.ask | grep "^From: " | sed -e "s|^From: ||g"`

cat $HOME/getspec.ask | prepare_mail | mutt -H  -

# -s "Answer to spec request from Sisyphus"
#echo $DONER $ASKER $PACKAGE
if [ -n "$PACKAGE" ] ; then
	LF=""
	for i in $upload/*.spec ; do
	    test -f "$i" && LF="$LF -a $i"
	done
	test -z "$PACKAGESRC" && test -n "$LF" && mutt "$ASKER" -s "Requested spec for $PACKAGE" $LF
fi
if [ -n "$PACKAGESRC" ] ; then
	LF=""
	# TODO: races
	for i in $RPMDIR/SRPMS/*.nosrc.rpm ; do
	    test -f "$i" && LF="$LF -a $i"
	done
	test -n "$LF" && mutt "$ASKER" -s "Requested nosrc.rpm for $PACKAGE" $LF
fi
echo "`date` asked $PACKAGE from $ASKER, sent '$LF'" >>getspec.log
#rm -rf "$upload"
rm -rf "$RPMDIR/SRPMS/"
rm -rf "$RPMDIR/SOURCES/"
rm -rf "$RPMDIR/SPECS/"
