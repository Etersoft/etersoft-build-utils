#!/bin/sh
HASHERLOG="$1"
[ -n "$HASHERLOG" ] || HASHERLOG=/home/lav/RPM/log/rxclient-0.18-alt1.M70C.6-M70C.log

# last [0-9\:* - remove epoch
grep "rpmi.*installed" $HASHERLOG | sed -e "s|.*rpmi: ||" -e "s| installed.*||" -e "s|[0-9]*:||"
