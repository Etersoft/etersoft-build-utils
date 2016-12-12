#!/bin/sh -x

BRANCH=p8
CMD="ssh gear.alt"

$CMD task new $BRANCH
for i in $@ ; do
    $CMD task add copy $i
done

$CMD task run
