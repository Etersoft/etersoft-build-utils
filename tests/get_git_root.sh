#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod git

get_root_git_dir

echo "test gear for curdir"
is_gear && echo "IS GEAR" || echo "IS NOT GEAR"

echo "test gear for root_git_dir"
is_gear $(get_root_git_dir) && echo "IS GEAR" || echo "IS NOT GEAR"

echo
echo -n "get_repo_name: "
get_repo_name

echo -n "get_gear_name: "
get_gear_name

echo -n "get_remote_repo_name: "
get_remote_repo_name
