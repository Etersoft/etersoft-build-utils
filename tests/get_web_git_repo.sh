#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod web strings repos

check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}

check git.alt "http://git.altlinux.org" $(get_git_url git.alt)
check git.eter "http://git.etersoft.ru" $(get_git_url git.eter)
check git.some "" $(get_git_url git.some)

test_repo()
{
	local PKGNAME=$2
	local REPOPATH=$(initial_letter $PKGNAME)/$PKGNAME.git
	local URL=$(get_git_url $1)/$3/$REPOPATH
	check_url "$URL" && echo "OK with $URL" || echo "URL $URL does not exists"
}

test_repo git.alt testdisk gears
test_repo git.alt testdisk srpms

