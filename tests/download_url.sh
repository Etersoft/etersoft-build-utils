#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod web

download_url http://www.iozone.org/src/current/iozone3_303.tar.bz2 && echo "False positive" || echo "OK, failed"


