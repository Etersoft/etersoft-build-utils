#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod git

get_remote_git_list

#REMOTELIST=$(get_remote_git_list)
#if [ "$(echo $REMOTELIST | cut -d" " -f1)" = "$REMOTELIST" ]  ; then
#    echo "diag a one name"
#fi

if is_one_girar_name "$(get_remote_git_list)" ; then
	echo "diag as one name"
fi
