#!/bin/sh

check()
{
	[ "$2" != "$3" ] && echo "FATAL with '$1': result '$2' do not match with '$3'" || echo "OK for '$1' with '$2'"
}

RESTEXT="Summary: test & test"
RT="$(echo "$RESTEXT" | sed -e 's|\&|\\&|g')"
check "sed with &" "$(echo "Summary: test" | sed -e "s|Summary: .*|$RT|g")" "$RESTEXT"
