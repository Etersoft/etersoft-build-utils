#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec rpm

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

print_spec()
{
	echo "%define SourceUrl$1 $2"
}

check_url()
{
	check "$1" "$(print_spec "$3" "$4" | grep -i "^%define ${2}Url${3} " | head -n 1 | sed -e "s/ *\$//g" | sed -e "s/^%define[ \t].*[ \t]//g")" $4
}

check_url 1 "Source" ""  "http://ftp.ealtlinx.ru/dddd/dddd.tar.bz2"
check_url 2 "Source" "0" "http://ftp.ealtlinx.ru/dddd/dddd.tar.bz2"
check_url 3 "Source" "0" "http://ftp.ealtlinx.ru/dddd/dddd.tar.bz2 "
