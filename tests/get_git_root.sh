#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod git

get_root_git_dir

echo "test gear for curdir"
is_gear && echo "IS GEAR" || echo "IS NOT GEAR"

echo "test gear for root_git_dir"
is_gear $(get_root_git_dir) && echo "IS GEAR" || echo "IS NOT GEAR"

