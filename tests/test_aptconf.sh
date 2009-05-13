#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod hasher

# Create test apt.conf file
cat <<EOF >apt.conf.SS
// Test apt.conf
Dir::Etc::main "/dev/null";
Dir::Etc::parts "/var/empty";
Dir::Etc::SourceParts "/var/empty";

Dir::Etc::sourcelist "/etc/eterbuild/apt/sources.list.SS";
EOF

cat <<EOF >sources.list.SS
# Test sources.list
rpm file:/var/ftp/ pub/ALTLinux/Sisyphus/i586 classic
rpm file:/var/ftp/ pub/ALTLinux/Sisyphus/noarch classic
EOF

export APTCONFBASE=$(pwd)/apt.conf

parse_cmd_pre ""


prepare_aptconfig

echo
echo "apt $OURAPTCONF:"
cat $OURAPTCONF

echo
echo "sources $OURSOURCES:"
cat $OURSOURCES
