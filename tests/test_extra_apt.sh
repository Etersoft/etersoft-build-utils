#!/bin/bash

# load common functions, compatible with local and installed script
. `dirname $0`/../share/eterbuild/functions/common
load_mod alt

REQLIST="bash /bin/sh coreutils curl diffutils eject /etc/rc.d/init.d /etc/udev/rules.d findutils fonts-ttf-core glibc-locales glibc-nss glibc-pthread grep gzip less libasound.so.2 libc.so.6 libcups libdl.so.2 libfontconfig.so.1 libfreetype.so.6 libglib-2.0.so.0 libgmodule-2.0.so.0 libgobject-2.0.so.0 libgstapp-0.10.so.0 libgstreamer-0.10.so.0 libgthread-2.0.so.0 libICE libieee1284.so.3 liblber-2.4.so.2 liblcms.so.1 libldap_r-2.4.so.2 /lib/ld-linux.so.2 libmpg123.so.0 libm.so.6 libncurses libopenal.so.1 libpthread.so.0 libresolv.so.2 libSM.so.6 libssl libudev.so.0 libusb-1.0.so.0 libuuid libX11.so.6 libXext.so.6 libxml2.so.2 libXpm.so.4 libXrender libz.so.1 mount perl-base procps psmisc rtld /sbin/modprobe sed sh tar termutils unzip /usr/bin/env /usr/sbin/groupadd /usr/sbin/post_service /usr/sbin/preun_service webclient wget which xdg-utils xlsfonts xrandr xz"
#REQLIST="bash /bin/sh coreutils curl diffutils eject /etc/rc.d/init.d /etc/udev/rules.d findutils glibc-locales glibc-nss glibc-pthread grep gzip less libasound.so.2 libc.so.6 libcups libdl.so.2 libfontconfig.so.1 libfreetype.so.6 libglib-2.0.so.0 libgmodule-2.0.so.0 libgobject-2.0.so.0 libgstapp-0.10.so.0 libgstreamer-0.10.so.0 libgthread-2.0.so.0 libICE libieee1284.so.3 liblber-2.4.so.2 liblcms.so.1 libldap_r-2.4.so.2 /lib/ld-linux.so.2 libmpg123.so.0 libm.so.6 libncurses libopenal.so.1 libpthread.so.0 libresolv.so.2 libSM.so.6 libssl libudev.so.0 libusb-1.0.so.0 libuuid libX11.so.6 libXext.so.6 libxml2.so.2 libXpm.so.4 libXrender libz.so.1 mount perl-base procps psmisc rtld /sbin/modprobe sed sh tar termutils unzip /usr/bin/env /usr/sbin/groupadd /usr/sbin/post_service /usr/sbin/preun_service webclient wget which xdg-utils xlsfonts xrandr xz"

LANG=C apt-get -m install --print-uris $REQLIST 2>&1 | grep "is a virtual package provided by" | cut -f2 -d" " | sort -u
