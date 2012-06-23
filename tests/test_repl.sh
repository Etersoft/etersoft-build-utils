#!/bin/sh

# Проблемы: из-за жадного .* заменяется только последний пакет в строке
#

check()
{
	local REPL
	echo
	echo "Source line: '$TEST1'"
	#REPL=`echo $TEST1 | sed -r -e $NRL`
	REPL=`echo $TEST1 | perl -pi "$NRL"`
	[ "$REPL1" != "$REPL" ] && echo "FATAL with '$NRL'  with result '$REPL'" || echo "OK with '$REPL'"
}

ALTPKGNAME="rpm-build"
TARGETPKGNAME="rpm"

NRL="-e s!(.*Req.*?)$ALTPKGNAME( |,|\$)!\1$TARGETPKGNAME\2!g;
	-e s!(.*Req.*?)$ALTPKGNAME( |,|\$)!\1$TARGETPKGNAME\2!g;
"

##NRL="s!\(.*Req.*\)$REPLRULE1\( |,|\$\)!\1$REPLRULE2\2!

TEST1="BuildPreReq: rpm-build-altlinux-compat"
REPL1="BuildPreReq: rpm-build-altlinux-compat"
check

TEST1="BuildPreReq: rpm-build rpm-build-altlinux-compat"
REPL1="BuildPreReq: rpm rpm-build-altlinux-compat"
check

TEST1="BuildPreReq: rpm-build-altlinux-compat rpm rpm-build"
REPL1="BuildPreReq: rpm-build-altlinux-compat rpm rpm"
check

TEST1="BuildPreReq: rpm-build-altlinux-compat, rpm, rpm-build"
REPL1="BuildPreReq: rpm-build-altlinux-compat, rpm, rpm"
check

TEST1="BuildPreReq: libstdc++"
REPL1="BuildPreReq: libstdc++"
check
