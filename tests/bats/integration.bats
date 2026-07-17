#!/usr/bin/env bats

# Integration tests - these require external dependencies
# and will be skipped if not available

load test_helper

setup() {
    load_mod repl
}

# --- tolocal_anyrepl (from test_repl_find.sh) ---

check_repl() {
    local pkg="$1"
    local expected="$2"
    tolocal_anyrepl "$pkg" $(print_pkgrepl_list) || TARGETPKGNAME="$pkg"
    [ "$TARGETPKGNAME" = "$expected" ]
}

@test "repl_find: RedOS libpixman-devel -> pixman-devel" {
    BUILDNAME=nx-libs
    DISTRNAME=RedOS
    PKGVENDOR=redos
    DISTRVERSION=7.3
    BUILDARCH=x86_64
    PKGFORMAT=rpm
    check_repl "libpixman-devel" "pixman-devel"
}

@test "repl_find: Fedora libusb-devel -> libusbx-devel" {
    DISTRNAME=Fedora
    PKGVENDOR=fedora
    DISTRVERSION=23
    BUILDARCH=x86_64
    PKGFORMAT=rpm
    BUILDNAME=test
    check_repl "libusb-devel" "libusbx-devel"
}

@test "repl_find: Fedora libkrb5-devel -> krb5-devel krb5-libs" {
    DISTRNAME=Fedora
    PKGVENDOR=fedora
    DISTRVERSION=23
    BUILDARCH=x86_64
    PKGFORMAT=rpm
    BUILDNAME=test
    check_repl "libkrb5-devel" "krb5-devel krb5-libs"
}

@test "repl_find: Ubuntu libusb-devel -> libusb-1.0-0-dev" {
    DISTRNAME=Ubuntu
    PKGVENDOR=ubuntu
    PKGFORMAT=deb
    DISTRVERSION=16.04
    BUILDARCH=x86_64
    BUILDNAME=wine
    check_repl "libusb-devel" "libusb-1.0-0-dev"
}

@test "repl_find: ArchLinux libusb-devel -> libusb" {
    DISTRNAME=ArchLinux
    PKGVENDOR=archlinux
    PKGFORMAT=pkg.gz
    DISTRVERSION=2012.04
    BUILDNAME=test
    check_repl "libusb-devel" "libusb"
}

@test "repl_find: Slackware libX11-devel -> libX11" {
    DISTRNAME=Slackware
    PKGVENDOR=slackware
    PKGFORMAT=pkg.gz
    DISTRVERSION=14
    BUILDNAME=test
    check_repl "libX11-devel" "libX11"
}

@test "repl_find: AstraLinux pkg-config -> pkgconfig" {
    DISTRNAME=AstraLinux
    PKGVENDOR=astra
    DISTRVERSION=orel
    BUILDARCH=x86_64
    PKGFORMAT=rpm
    BUILDNAME=wine-etersoft
    check_repl "pkg-config" "pkgconfig"
}

# --- filter_deb_pkgnames (from repl module) ---

@test "repl: filter_deb_pkgnames converts underscores" {
    result=$(echo "some_package" | filter_deb_pkgnames)
    [ "$result" = "some-package" ]
}

@test "repl: filter_deb_pkgnames converts -devel to -dev" {
    result=$(echo "libfoo-devel" | filter_deb_pkgnames)
    [ "$result" = "libfoo-dev" ]
}

@test "repl: filter_deb_pkgnames lowercases" {
    result=$(echo "LibFoo" | filter_deb_pkgnames)
    [ "$result" = "libfoo" ]
}
