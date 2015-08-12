#!/bin/sh

check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}

func()
{
	echo "$VAR"
}

is_obsoleted()
{
	test -z "$(find "$1" -cmin -1 2>/dev/null)"
}

touch test

is_obsoleted test && echo "OBSOLETED or missed" || echo "OK"
is_obsoleted /etc/fstab && echo "OBSOLETED or missed" || echo "OK"
is_obsoleted /var/empty/none && echo "OBSOLETED or missed" || echo "OK"


