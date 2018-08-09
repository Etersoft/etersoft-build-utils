#!/bin/sh

BNAME="$1"
[ -n "$BNAME" ] || BNAME=rxclient

LOCALPATH=/var/ftp/pub/ALTLinux/c7/branch
URLREPO=http://ftp.basealt.ru/pub/distributions/ALTLinux/c7/branch

rm -f $BNAME.bin.list
rm -f $BNAME.src.list
rm -f $BNAME.src.list.tmp
rm -f $BNAME.common.list
rm -f $BNAME.common.url.list

# список путей найденных пакетов
for i in $(cat $BNAME.additions) ; do
    FPATH=$(grep /$i $BNAME.paths)
    URLPATH=$(echo $FPATH | sed -e "s|$LOCALPATH|$URLREPO|")
    SFPATH=$URLREPO/files/SRPMS/$(epm print srcpkgname from filename $FPATH)
    #wget $URLREPO -O $(basename $SFPATH)
    echo $URLPATH >>$BNAME.bin.list
    echo $SFPATH >>$BNAME.src.list.tmp
    echo $(basename $FPATH) $(basename $SFPATH) >>$BNAME.common.list
    echo $URLPATH $SFPATH >>$BNAME.common.url.list
done

cat $BNAME.src.list.tmp | sort -u > $BNAME.src.list
rm -f $BNAME.src.list.tmp
