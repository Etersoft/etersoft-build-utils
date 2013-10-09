#!/bin/sh

# Run with rpm build log for test

. `dirname $0`/../share/eterbuild/functions/common
load_mod check

check_log $1
