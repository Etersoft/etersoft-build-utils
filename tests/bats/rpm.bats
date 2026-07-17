#!/usr/bin/env bats

load test_helper

setup() {
    load_mod rpm
}

# --- get_pkgname_from_filename (from get_packagename.sh) ---

@test "get_pkgname_from_filename: simple spec" {
    result=$(get_pkgname_from_filename "pkg-1.0.spec")
    [ "$result" = "pkg" ]
}

@test "get_pkgname_from_filename: spec with hyphens" {
    result=$(get_pkgname_from_filename "pkg-source-1.0.spec")
    [ "$result" = "pkg-source" ]
}

@test "get_pkgname_from_filename: spec with multiple hyphens" {
    result=$(get_pkgname_from_filename "pkg-source-less-1.0.spec")
    [ "$result" = "pkg-source-less" ]
}

@test "get_pkgname_from_filename: numeric name" {
    result=$(get_pkgname_from_filename "pkg123-1.0.spec")
    [ "$result" = "pkg123" ]
}

@test "get_pkgname_from_filename: name with bracket" {
    result=$(get_pkgname_from_filename "pkg123[_-]1.0.spec")
    [ "$result" = "pkg123" ]
}

@test "get_pkgname_from_filename: name with glob" {
    result=$(get_pkgname_from_filename "pkg*.spec")
    [ "$result" = "pkg" ]
}

@test "get_pkgname_from_filename: rpm with complex version" {
    result=$(get_pkgname_from_filename "libpq5.2-9.0eter-9.0.4-alt14.i586.rpm")
    [ "$result" = "libpq5.2-9.0eter" ]
}

@test "get_pkgname_from_filename: deb package" {
    result=$(get_pkgname_from_filename "postgre-etersoft9.0_9.0.4-eter14ubuntu_i386.deb")
    [ "$result" = "postgre-etersoft9.0" ]
}

@test "get_pkgname_from_filename: svn version" {
    result=$(get_pkgname_from_filename "libgnustep-opal-r37181-alt3.svn20131001")
    [ "$result" = "libgnustep-opal" ]
}

@test "get_pkgname_from_filename: dotted version" {
    result=$(get_pkgname_from_filename "libopencv2.4-2.4.13.3-alt2.x86_64")
    [ "$result" = "libopencv2.4" ]
}
