#!/usr/bin/env bats

# Regression tests for the source-git merge strategy discriminator.
#
# rpmgs update_master_branch_to() must use 'git merge -s ours' only for packages
# whose source is built from the version tag (tar: ...@version@), and keep a real
# merge for packages that track source in the branch (vendored/predownloaded).
# The previous attempt keyed this on the .gear/tags directory (d223e6c) and was
# reverted (bd83b59) because it broke vendored packages. These tests pin the
# @version@ tar rule as the precise signal so that regression does not recur.

load test_helper

setup() {
    load_mod gear
    TEST_REPO="$(mktemp -d)"
    cd "$TEST_REPO" || return
    git init -q
    git config user.email t@t.t
    git config user.name test
    mkdir -p .gear
}

teardown() {
    rm -rf "$TEST_REPO"
}

write_rules() {
    printf '%s\n' "$@" > .gear/rules
}

# --- matches: source built from the version tag -> -s ours ---

@test "is_tar_from_version_tag_rule: tar: v@version@:. matches" {
    write_rules 'copy: *.patch' 'tar: v@version@:.'
    run is_tar_from_version_tag_rule
    [ "$status" -eq 0 ]
}

@test "is_tar_from_version_tag_rule: tar: @version@:. (no v prefix) matches" {
    write_rules 'tar: @version@:.'
    run is_tar_from_version_tag_rule
    [ "$status" -eq 0 ]
}

@test "is_tar_from_version_tag_rule: leading whitespace tolerated" {
    write_rules '  tar: v@version@:.'
    run is_tar_from_version_tag_rule
    [ "$status" -eq 0 ]
}

# --- no match: source tracked in the branch -> regular merge ---

@test "is_tar_from_version_tag_rule: vendored/predownloaded rule does not match" {
    write_rules 'tar: .gear/predownloaded-production:.' 'copy: *.patch'
    run is_tar_from_version_tag_rule
    [ "$status" -ne 0 ]
}

@test "is_tar_from_version_tag_rule: source tracked in repo dir does not match" {
    write_rules 'tar: .' 'spec: foo.spec'
    run is_tar_from_version_tag_rule
    [ "$status" -ne 0 ]
}

@test "is_tar_from_version_tag_rule: copy-only rules do not match" {
    write_rules 'copy: *.patch' 'copy: *.service'
    run is_tar_from_version_tag_rule
    [ "$status" -ne 0 ]
}

# --- edge cases ---

@test "is_tar_from_version_tag_rule: missing .gear/rules does not match" {
    rm -rf .gear
    run is_tar_from_version_tag_rule
    [ "$status" -ne 0 ]
}

@test "is_tar_from_version_tag_rule: non-git dir does not match" {
    rm -rf .git
    run is_tar_from_version_tag_rule
    [ "$status" -ne 0 ]
}
