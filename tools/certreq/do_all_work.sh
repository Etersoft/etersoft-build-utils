#!/bin/sh

BNAME="$1"
[ -n "$BNAME" ] || BNAME=rxclient

#HASHERLOG=/home/lav/RPM/log/rxclient-0.18-alt1.M70C.6-M70C.log
HASHERLOG=/home/lav/RPM/log/$BNAME*.log

[ -s "$(echo $HASHERLOG)" ] || exit 1

echo "Work with $HASHERLOG"

# список зависимостей, использованных при сборке
./get_build_reqs.sh $HASHERLOG >$BNAME.list

# получает пути к файлам пакетов
./get_pkg_paths.sh $BNAME.list >$BNAME.paths

# получает список файлов пакетов (как на диске)
./path_to_list.sh $BNAME.paths >$BNAME.files

# сохраняет список дополнительных пакетов, использованных при сборке
./list_only_missed.sh $BNAME.files >$BNAME.additions
