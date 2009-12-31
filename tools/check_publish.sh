#!/bin/sh
# copy specs to separate tree, make rpmcs and printout diff

# load common functions, compatible with local and installed script
. `dirname $0`/../share/eterbuild/functions/common

get_wd()
{
	apt-cache whatdepends $1 | grep "^  [a-zA-Z]" | sed -e "s|^ *||g" | grep -v $1
}
list_wd()
{
	for i in $@ ; do
		#echo i=$i
		get_wd `echo $i | sed "s|-[0-9].*||g"`
	done
}

print_usedby()
{
	echo "Required by:"
	print_list $USEDBY
	echo "Second required by:"
	for i in `list_wd $USEDBY | sort -u` ; do
		# skip repeated
		echo $USEDBY | grep -q $i && continue
		echo "    $i"
	done
}


[ -n "$SPECLIST" ] || SPECLIST=`find $RPMDIR/SPECS -type f -name "*.spec"`

for i in $SPECLIST ; do
	if echo $i | grep -q HELP ; then
		continue
	fi
	echo $i
	#LANG=C rpmgp -c $i 2>&1 | grep -v "^Note" | grep -v "^Checking" | grep -v "^Repository"

	PKGNAME=`basename $i .spec`
	USEDBY=$(get_wd $PKGNAME)
	if [ -n "$USEDBY" ] ; then 
		print_usedby $i $USEDBY >$i.usedby
		#[ -n "`cat $i.usedby`" ] || 
	else
#		if [ -r $i.usedby ] ; then
#			echo "$i do not required anymore"
#		else
			rm -f $i.usedby
#		fi
	fi
	rpmbugs -t $i | grep -v "CLO.*FIX" | grep "@altlinux" >$i.bugs
	test -s $i.bugs || rm -f $i.bugs

	# if missed on ftp
	if rpmgp -c $i | grep -q MISSED ; then
		rpmgp -c $i >$i.missed
	else
		rm -f $i.$missed
	fi
	
	# if present in git
	if [ -n "$GIRAR_USER" ] ; then
		GITURL="http://git.altlinux.org/people/$GIRAR_USER/packages/$i.git"
		if GET -d $GITURL ; then
			echog "Published at $GITURL" > $i.GIT.PUBLISHED
			echog "Please check this spec and move work to git" >> $i.GIT.PUBLISHED
			ssh $GEARHOST find-package $i >> $i.GIT.PUBLISHED
		fi
	fi

	
	# TODO:
	#ssh git.alt acl sisyphus $PKGNAME show > $i.acl
	#grep " $USER\$" $i.acl
done

