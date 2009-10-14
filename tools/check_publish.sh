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

	USEDBY=$(get_wd `basename $i .spec`)
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

	if rpmgp -c $i | grep -q MISSED ; then
		rpmgp -c $i >$i.missed
	else
		rm -f $i.$missed
	fi
done

