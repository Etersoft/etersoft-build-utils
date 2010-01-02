#!/bin/sh
# copy specs to separate tree, make rpmcs and printout diff

# load common functions, compatible with local and installed script
. `dirname $0`/../share/eterbuild/functions/common
load_mod git

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

if_file_empty()
{
	NL=$(grep -v "^\$" "$1" | wc -l)
	test "$NL" -eq "0"
}

remove_if_empty()
{
	if if_file_empty "$1" ; then
		rm -f "$1"
	fi
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
	rpmgp -c $i | grep -q MISSED >$i.missed
	remove_if_empty $i.missed
	
	list_git_package $PKGNAME > $i.GIT.PUBLISHED
	# if present in git
	if [ -n "$GIRAR_USER" ] ; then
		GITURL="http://git.altlinux.org/people/$GIRAR_USER/packages/$PKGNAME.git"
		if GET -d $GITURL ; then
			echo
			echog "Published at $GITURL by $GIRAR_USER" >> $i.GIT.PUBLISHED
			echog "Please check this spec and move work to git" >> $i.GIT.PUBLISHED
		fi
	fi

	remove_if_empty $i.GIT.PUBLISHED

	if [ -r "$i.GIT.PUBLISHED" ] ; then
		ssh $GIRARHOST acl sisyphus $PKGNAME show 2>> $i.GIT.PUBLISHED
	fi
	
	#grep " $USER\$" $i.acl
done

