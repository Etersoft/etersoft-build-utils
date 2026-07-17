#!/usr/bin/env bats

# Tests for package name replacement regex logic (from test_repl.sh)
# These test the perl regex used in tolocal_anyrepl

do_replace() {
    local altpkg="$1"
    local targetpkg="$2"
    local testline="$3"
    local expected="$4"
    local NRL="-e s!(.*Req.*?)${altpkg}( |,|}|\$)!\1${targetpkg}\2!g;
        -e s!(.*Req.*?)${altpkg}( |,|}|\$)!\1${targetpkg}\2!g;
    "
    result=$(echo "$testline" | perl -p "$NRL")
    [ "$result" = "$expected" ]
}

@test "repl: rpm-build not matching rpm-build-altlinux-compat" {
    do_replace "rpm-build" "rpm" \
        "BuildPreReq: rpm-build-altlinux-compat" \
        "BuildPreReq: rpm-build-altlinux-compat"
}

@test "repl: rpm-build matches standalone" {
    do_replace "rpm-build" "rpm" \
        "BuildPreReq: rpm-build rpm-build-altlinux-compat" \
        "BuildPreReq: rpm rpm-build-altlinux-compat"
}

@test "repl: rpm-build at end of line" {
    do_replace "rpm-build" "rpm" \
        "BuildPreReq: rpm-build-altlinux-compat rpm rpm-build" \
        "BuildPreReq: rpm-build-altlinux-compat rpm rpm"
}

@test "repl: rpm-build with comma separators" {
    do_replace "rpm-build" "rpm" \
        "BuildPreReq: rpm-build-altlinux-compat, rpm, rpm-build" \
        "BuildPreReq: rpm-build-altlinux-compat, rpm, rpm"
}

@test "repl: no match leaves line unchanged" {
    do_replace "rpm-build" "rpm" \
        "BuildPreReq: libstdc++" \
        "BuildPreReq: libstdc++"
}

@test "repl: libkrb5-devel -> krb5-devel" {
    do_replace "libkrb5-devel" "krb5-devel" \
        "%{?_with_krb:Requires: libkrb5-devel}" \
        "%{?_with_krb:Requires: krb5-devel}"
}
