#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod hasher

parse_cmd_pre ""


print_tmp_aptconf $APTCONF
echo "-------------------------------"
#print_tmp_aptconf /etc/apt/apt.conf.SS

print_tmp_sourceslist $APTCONF

prepare_aptconfig

echo
echo "apt $OURAPTCONF:"
cat $OURAPTCONF

echo
echo "sources $OURSOURCES:"
cat $OURSOURCES
