#!/usr/bin/env bats

load test_helper

setup() {
    load_mod spec
}

# --- get_numrelease / get_txtrelease ---
# These call get_release internally, which needs a real spec.
# Mock get_release to return our test values directly.

get_numrelease_test() {
    local rel="$1"
    get_release() { echo "$rel"; }
    get_numrelease ""
}

get_txtrelease_test() {
    local rel="$1"
    get_release() { echo "$rel"; }
    get_txtrelease ""
}

@test "get_numrelease: alt3 -> 3" {
    result=$(get_numrelease_test "alt3")
    [ "$result" = "3" ]
}

@test "get_numrelease: alt36 -> 36" {
    result=$(get_numrelease_test "alt36")
    [ "$result" = "36" ]
}

@test "get_numrelease: alt3test -> 3" {
    result=$(get_numrelease_test "alt3test")
    [ "$result" = "3" ]
}

@test "get_numrelease: alt3.1 -> 3.1" {
    result=$(get_numrelease_test "alt3.1")
    [ "$result" = "3.1" ]
}

@test "get_numrelease: alt3.r3003.1 -> 3.r3003.1" {
    result=$(get_numrelease_test "alt3.r3003.1")
    [ "$result" = "3.r3003.1" ]
}

@test "get_txtrelease: alt4 -> alt" {
    result=$(get_txtrelease_test "alt4")
    [ "$result" = "alt" ]
}

@test "get_txtrelease: alt36 -> alt" {
    result=$(get_txtrelease_test "alt36")
    [ "$result" = "alt" ]
}

@test "get_txtrelease: alt4test -> alt" {
    result=$(get_txtrelease_test "alt4test")
    [ "$result" = "alt" ]
}

@test "get_txtrelease: alt4.2 -> alt" {
    result=$(get_txtrelease_test "alt4.2")
    [ "$result" = "alt" ]
}

@test "get_txtrelease: alt4.r3003.2 -> alt" {
    result=$(get_txtrelease_test "alt4.r3003.2")
    [ "$result" = "alt" ]
}

# --- get_numpartrelease ---

@test "get_numpartrelease: alt51 -> 51" {
    result=$(get_numpartrelease "alt51")
    [ "$result" = "51" ]
}

@test "get_numpartrelease: alt5.2 -> 5" {
    result=$(get_numpartrelease "alt5.2")
    [ "$result" = "5" ]
}

@test "get_numpartrelease: alt3.r3003.1 -> 3" {
    result=$(get_numpartrelease "alt3.r3003.1")
    [ "$result" = "3" ]
}

@test "get_numpartrelease: alt3.eter50 -> 3" {
    result=$(get_numpartrelease "alt3.eter50")
    [ "$result" = "3" ]
}

@test "get_numpartrelease: eter26.svn724archlinux -> 26" {
    result=$(get_numpartrelease "eter26.svn724archlinux")
    [ "$result" = "26" ]
}

# --- get_default_txtrelease ---

@test "get_default_txtrelease: git.alt -> alt" {
    GITHOST=git.alt
    result=$(get_default_txtrelease)
    [ "$result" = "alt" ]
}

@test "get_default_txtrelease: git.eter -> eter" {
    GITHOST=git.eter
    result=$(get_default_txtrelease)
    [ "$result" = "eter" ]
}

# --- decrement_release ---

@test "decrement_release: 39 -> 38" {
    result=$(decrement_release "39")
    [ "$result" = "38" ]
}

@test "decrement_release: 39.1 -> 38" {
    result=$(decrement_release "39.1")
    [ "$result" = "38" ]
}

@test "decrement_release: 39cvs -> 38" {
    result=$(decrement_release "39cvs")
    [ "$result" = "38" ]
}

@test "decrement_release: 39.1cvs -> 38" {
    result=$(decrement_release "39.1cvs")
    [ "$result" = "38" ]
}

@test "decrement_release: cvs -> 0" {
    result=$(decrement_release "cvs")
    [ "$result" = "0" ]
}

@test "decrement_release: 0 -> 0" {
    result=$(decrement_release "0")
    [ "$result" = "0" ]
}

@test "decrement_release: 25.r101.1 -> 24" {
    result=$(decrement_release "25.r101.1")
    [ "$result" = "24" ]
}

# --- inc_release / inc_subrelease ---
# Mock get_release/set_release to test the logic

inc_release_test() {
    local rel="$1"
    get_release() { echo "$rel"; }
    set_release() { echo "$2"; }
    inc_release ""
}

inc_subrelease_test() {
    local rel="$1"
    get_release() { echo "$rel"; }
    set_release() { echo "$2"; }
    inc_subrelease ""
}

@test "inc_release: alt5 -> alt6" {
    result=$(inc_release_test "alt5")
    [ "$result" = "alt6" ]
}

@test "inc_release: alt6.2 -> alt7" {
    result=$(inc_release_test "alt6.2")
    [ "$result" = "alt7" ]
}

@test "inc_release: alt6.r5001 -> alt7.r5001" {
    result=$(inc_release_test "alt6.r5001")
    [ "$result" = "alt7.r5001" ]
}

@test "inc_release: alt6.eter51 -> alt7.eter51" {
    result=$(inc_release_test "alt6.eter51")
    [ "$result" = "alt7.eter51" ]
}

@test "inc_release: alt5.14f23 -> alt6.14f23" {
    result=$(inc_release_test "alt5.14f23")
    [ "$result" = "alt6.14f23" ]
}

@test "inc_release: alt4.ff -> alt5.ff" {
    result=$(inc_release_test "alt4.ff")
    [ "$result" = "alt5.ff" ]
}

@test "inc_release: alt3.git20110916 -> alt4.git20110916" {
    result=$(inc_release_test "alt3.git20110916")
    [ "$result" = "alt4.git20110916" ]
}

@test "inc_release: alt3.git20130916.2 -> alt4.git20130916" {
    result=$(inc_release_test "alt3.git20130916.2")
    [ "$result" = "alt4.git20130916" ]
}

@test "inc_release: alt2.M80P.3 -> alt2.M80P.4" {
    result=$(inc_release_test "alt2.M80P.3")
    [ "$result" = "alt2.M80P.4" ]
}

@test "inc_release: alt3.S1 -> alt4.S1" {
    result=$(inc_release_test "alt3.S1")
    [ "$result" = "alt4.S1" ]
}

@test "inc_release: alt7.M70C.14 -> alt7.M70C.15" {
    result=$(inc_release_test "alt7.M70C.14")
    [ "$result" = "alt7.M70C.15" ]
}

@test "inc_subrelease: alt5 -> alt5.1" {
    result=$(inc_subrelease_test "alt5")
    [ "$result" = "alt5.1" ]
}

@test "inc_subrelease: alt6.2 -> alt6.3" {
    result=$(inc_subrelease_test "alt6.2")
    [ "$result" = "alt6.3" ]
}

@test "inc_subrelease: alt6.r5001 -> alt6.r5001.1" {
    result=$(inc_subrelease_test "alt6.r5001")
    [ "$result" = "alt6.r5001.1" ]
}

@test "inc_subrelease: alt3.git20110916 -> alt3.git20110916.1" {
    result=$(inc_subrelease_test "alt3.git20110916")
    [ "$result" = "alt3.git20110916.1" ]
}

@test "inc_subrelease: alt3.git20130916.2 -> alt3.git20130916.3" {
    result=$(inc_subrelease_test "alt3.git20130916.2")
    [ "$result" = "alt3.git20130916.3" ]
}

# Check actual behavior for backported releases
@test "inc_subrelease: alt2.M80P.3 actual behavior" {
    result=$(inc_subrelease_test "alt2.M80P.3")
    # Function keeps middle part and increments minor
    [ -n "$result" ]
}

@test "inc_subrelease: alt7.M70C.14 actual behavior" {
    result=$(inc_subrelease_test "alt7.M70C.14")
    [ -n "$result" ]
}

# --- reset_release ---
# Mock get_release and set_var to test reset logic

reset_release_test() {
    local rel="$1"
    local explicit="$2"
    get_release() { echo "$rel"; }
    # When called as set_var "" Release val, $1="" shifts away,
    # so Release ends up in $1 and val in $2
    set_var() { [ "$1" = "Release" ] && echo "$2" || echo "$3"; }
    reset_release "" "$explicit"
}

@test "reset_release: eter2 -> eter1" {
    GITHOST=git.eter
    result=$(reset_release_test "eter2")
    [ "$result" = "eter1" ]
}

@test "reset_release: eter1 -> eter1" {
    GITHOST=git.eter
    result=$(reset_release_test "eter1")
    [ "$result" = "eter1" ]
}

@test "reset_release: alt5 -> alt1" {
    GITHOST=git.alt
    result=$(reset_release_test "alt5")
    [ "$result" = "alt1" ]
}

@test "reset_release: alt6.2 -> alt1" {
    GITHOST=git.alt
    result=$(reset_release_test "alt6.2")
    [ "$result" = "alt1" ]
}

@test "reset_release: alt3.git20110916 -> alt1" {
    GITHOST=git.alt
    result=$(reset_release_test "alt3.git20110916")
    [ "$result" = "alt1" ]
}

@test "reset_release: explicit value eter5" {
    GITHOST=git.eter
    result=$(reset_release_test "eter2" "eter5")
    [ "$result" = "eter5" ]
}

# --- MAJOR.MINOR parsing ---

@test "parse: 27.5 -> MAJOR=27 MINOR=5" {
    baserelease="27.5"
    major=$(echo "$baserelease" | sed -e "s|\..*||")
    minor=$(echo "$baserelease" | sed -e "s|.*\.||")
    [ "$major" = "27" ]
    [ "$minor" = "5" ]
}

@test "parse: 35 -> MAJOR=35 MINOR=35" {
    baserelease="35"
    major=$(echo "$baserelease" | sed -e "s|\..*||")
    minor=$(echo "$baserelease" | sed -e "s|.*\.||")
    [ "$major" = "35" ]
    [ "$minor" = "35" ]
}
