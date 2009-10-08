#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod tarball

# see rpmbs for using it

copy_tarball_to_tar_bz2 dd.tar tdd.tar.bz2
copy_tarball_to_tar_bz2 dd.tar.bz2 tdd.tar.bz2
copy_tarball_to_tar_bz2 dd.tar.gz tdd.tar.bz2
