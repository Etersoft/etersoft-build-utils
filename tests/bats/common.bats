#!/usr/bin/env bats

load test_helper

setup() {
    load_common
}

# --- usearg ---

@test "usearg: non-empty value" {
    result=$(usearg -f TEST)
    [ "$result" = "-f TEST" ]
}

@test "usearg: empty value gives nothing" {
    run usearg -f ""
    [ "$output" = "" ]
}

@test "usearg: equal args cancel out" {
    run usearg -f TEST TEST
    [ "$output" = "" ]
}

@test "usearg: value matches default" {
    run usearg -f "same" "same"
    [ "$output" = "" ]
}

@test "usearg: value differs from default" {
    result=$(usearg -f "hello" "world")
    [ "$result" = "-f hello" ]
}

# --- version_more_version ---

@test "version_more_version: equal versions" {
    run version_more_version "c9" "c9"
    [ "$status" -eq 0 ]
}

@test "version_more_version: first greater" {
    run version_more_version "c9f2" "c9f1"
    [ "$status" -eq 0 ]
}

@test "version_more_version: first less" {
    run version_more_version "c9f1" "c9f2"
    [ "$status" -ne 0 ]
}

@test "version_more_version: c10 > c9f2" {
    run version_more_version "c10" "c9f2"
    [ "$status" -eq 0 ]
}

@test "version_more_version: c9f2 < c10" {
    run version_more_version "c9f2" "c10"
    [ "$status" -ne 0 ]
}

# --- stripcolors ---

@test "stripcolors: removes ANSI color codes" {
    result=$(echo -e "\033[1;31merror\033[0m" | stripcolors)
    [ "$result" = "error" ]
}

@test "stripcolors: plain text unchanged" {
    result=$(echo "hello" | stripcolors)
    [ "$result" = "hello" ]
}

# --- is_ssh_target ---

@test "is_ssh_target: host:path" {
    run is_ssh_target "server:/path"
    [ "$status" -eq 0 ]
}

@test "is_ssh_target: local path" {
    run is_ssh_target "/local/path"
    [ "$status" -ne 0 ]
}

# --- make_temp_file ---

@test "make_temp_file: creates readable file" {
    tmpfile=$(make_temp_file)
    [ -f "$tmpfile" ]
    [ -r "$tmpfile" ]
    rm -f "$tmpfile"
}
