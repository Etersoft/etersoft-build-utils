#!/bin/sh

check()
{
        [ "$2" != "$3" ] && echo "FATAL with '$1': result '$3' do not match with '$2'" || echo "OK for '$1' with '$2'"
}

func()
{
	echo "$VAR"
}

VAR=
check VAR-empty "" $(func)
VAR=test
check VAR-fill "test" $(func)

VAR=
check VAR-setbefore "again" $(VAR=again func)
check VAR-emptyafter "" $(func)

# stranges only for function
VAR=try func
check VAR-emptyaftertry "" $(func)

VAR=
VAR=try true
check VAR-emptyaftertry2 "" $(func)
