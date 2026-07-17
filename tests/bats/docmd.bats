#!/usr/bin/env bats

load test_helper

setup() {
    load_common
}

# --- showcmd ---

@test "showcmd: prints command with $ prefix" {
    run showcmd ls -la
    [[ "$output" == *'$'* ]]
    [[ "$output" == *"ls -la"* ]]
}

@test "showcmd: quotes args with spaces" {
    run showcmd echo "hello world"
    [[ "$output" == *"'"* ]]
}

# --- docmd ---

@test "docmd: runs command and shows it" {
    run docmd true
    [ "$status" -eq 0 ]
}

@test "docmd: passes exit code" {
    run docmd false
    [ "$status" -ne 0 ]
}

@test "docmd: runs command with args" {
    run docmd echo hello
    [ "$status" -eq 0 ]
    [[ "$output" == *"hello"* ]]
}
