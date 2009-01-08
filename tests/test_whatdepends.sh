#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common

get_wd()
{
	apt-cache whatdepends $1 | grep "^  [a-zA-Z]" | sed -e "s|^ *||g"
}
list_wd()
{
	for i in $@ ; do
		#echo i=$i
		get_wd `echo $i | sed "s|-[0-9].*||g"`
	done
}

	USEDBY=$(get_wd libmpfr)
	echo "Required by:"
	print_list $USEDBY
	echo "Second required by:"
	print_list `list_wd $USEDBY`
