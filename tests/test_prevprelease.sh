#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

SPECNAME=get_ver.spec

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}

fill_spec()
{
cat <<EOF >$SPECNAME
Name: get_version_test
Version: 2.1
Release: $RELEASE
Summary: Test
Group: Other
License: Public License

%description
Get version test
EOF
}

check_prev()
{
	# from rpmbh:
	# General rule: always alt(N-1).MM.(N)
	RELEASE="$2"
	fill_spec
	RELEASE=$(get_release $SPECNAME)
	test -n "$RELEASE" || fatal "release missed"
	BASERELEASE=$(get_numrelease $SPECNAME)
	test -n "$BASERELEASE" || fatal "baserelease missed"
	local RES="$(get_txtrelease $SPECNAME)$(decrement_release $BASERELEASE).$MDISTR.$BASERELEASE"
	check "$2" "$1" "$RES"
}

MDISTR=M40
check_prev alt2.M40.3 alt3
check_prev alt2.M40.3.r201.2 alt3.r201.2
check_prev alt0.M40.1 alt1
check_prev alt0.M40.0 alt0

#rm -f $SPECNAME
