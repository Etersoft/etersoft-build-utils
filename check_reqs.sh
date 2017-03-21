#!/bin/sh
/usr/lib/rpm/shell.req bin/* share/eterbuild/functions/* | sort -u | tee ./check_et.log
git diff ./check_et.log
