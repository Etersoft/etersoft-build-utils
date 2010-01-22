#!/bin/sh

# see libshell
. shell-quote

test1()
{
	echo "run with \'$@\'"
	echo 1 - $1
	echo 2 - $2
	echo 3 - $3
	test "$2" = "test string" || echo ERROR with $2
}

func()
{
	#test1 "$(quote_shell "$@")"
	cmd="$(quote_shell "$@")"
	test1 "$cmd"
	test1 "$@"
	test1 $@
}

func -m "test string"
