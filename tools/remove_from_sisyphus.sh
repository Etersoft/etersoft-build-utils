#!/bin/sh -x

CMD="ssh gear.alt"
#CMD="ssh git.eter"

$CMD task new
for i in $@ ; do
    $CMD task add del $i
done

$CMD task run
