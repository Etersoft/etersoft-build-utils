#!/bin/sh

for i in $(cat) ; do
    epm print srcpkgname from filename $i </dev/null
done
