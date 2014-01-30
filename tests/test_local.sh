#!/bin/sh

func()
{
	echo "1"
	echo "2"
	echo "3"
}

test_func()
{
	local var=$(func)
	echo "$var"
}

test_func
[ "$(test_func)" = "1 2 3" ] || echo "Error with local!"

