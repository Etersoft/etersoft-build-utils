#!/bin/sh

for i in nx rxclient rx-etersoft ; do
    ./do_all_work.sh $i
    ./do_all_work_next.sh $i
done
