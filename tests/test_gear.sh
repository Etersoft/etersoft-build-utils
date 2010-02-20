#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod git alt

check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}


echo "Current git branch: $(get_current_branch)"

check 1 M40 $(get_type_by_git_branch_name 4.0)
check 1 M40 $(get_type_by_git_branch_name M40)
check 1 M50 $(get_type_by_git_branch_name p5)
check 1 M50 $(get_type_by_git_branch_name M50)
check 1 M50 $(get_type_by_git_branch_name 5.0)
check 1 M51 $(get_type_by_git_branch_name M51)
check 1 M51 $(get_type_by_git_branch_name 5.1)
check 1 "" $(get_type_by_git_branch_name master)
check 1 "" $(get_type_by_git_branch_name sisyphus)
