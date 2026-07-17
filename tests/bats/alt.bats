#!/usr/bin/env bats

load test_helper

setup() {
    load_mod spec
}

# --- set_target_type ---

@test "set_target_type: M40" {
    MENV="undetected"
    set_target_type "M40"
    [ "$MENV" = "M40" ]
}

@test "set_target_type: M30" {
    MENV="undetected"
    set_target_type "M30"
    [ "$MENV" = "M30" ]
}

@test "set_target_type: M41" {
    MENV="undetected"
    set_target_type "M41"
    [ "$MENV" = "M41" ]
}

@test "set_target_type: M50P" {
    MENV="undetected"
    set_target_type "M50P"
    [ "$MENV" = "M50P" ]
}

@test "set_target_type: M60T" {
    MENV="undetected"
    set_target_type "M60T"
    [ "$MENV" = "M60T" ]
}

@test "set_target_type: M51" {
    MENV="undetected"
    set_target_type "M51"
    [ "$MENV" = "M51" ]
}

@test "set_target_type: SS" {
    MENV="undetected"
    set_target_type "SS"
    [ "$MENV" = "SS" ]
}

@test "set_target_type: sisyphus" {
    MENV="undetected"
    set_target_type "sisyphus"
    [ "$MENV" = "sisyphus" ]
}

@test "set_target_type: DD" {
    MENV="undetected"
    set_target_type "DD"
    [ "$MENV" = "DD" ]
}

@test "set_target_type: invalid returns 1" {
    run set_target_type "INVALID"
    [ "$status" -ne 0 ]
}

# --- get_altdistr_version ---

@test "get_altdistr_version: M60P -> p6" {
    result=$(get_altdistr_version "M60P")
    [ "$result" = "p6" ]
}

@test "get_altdistr_version: M50P -> p5" {
    result=$(get_altdistr_version "M50P")
    [ "$result" = "p5" ]
}

@test "get_altdistr_version: M70P -> p7" {
    result=$(get_altdistr_version "M70P")
    [ "$result" = "p7" ]
}

@test "get_altdistr_version: M80P -> p8" {
    result=$(get_altdistr_version "M80P")
    [ "$result" = "p8" ]
}

@test "get_altdistr_version: M60C -> c6" {
    result=$(get_altdistr_version "M60C")
    [ "$result" = "c6" ]
}

@test "get_altdistr_version: SS -> sisyphus" {
    result=$(get_altdistr_version "SS")
    [ "$result" = "sisyphus" ]
}

@test "get_altdistr_version: DD -> daedalus" {
    result=$(get_altdistr_version "DD")
    [ "$result" = "daedalus" ]
}

# --- get_altdistr_mod ---

@test "get_altdistr_mod: p6 -> M60P" {
    result=$(get_altdistr_mod "p6")
    [ "$result" = "M60P" ]
}

@test "get_altdistr_mod: p10 passthrough (not handled)" {
    result=$(get_altdistr_mod "p10")
    [ "$result" = "p10" ]
}

@test "get_altdistr_mod: c7 -> M70C" {
    result=$(get_altdistr_mod "c7")
    [ "$result" = "M70C" ]
}

@test "get_altdistr_mod: t8 -> M80T" {
    result=$(get_altdistr_mod "t8")
    [ "$result" = "M80T" ]
}

# --- get_type_by_git_branch_name ---

@test "get_type_by_git_branch_name: p6 -> M60P" {
    result=$(get_type_by_git_branch_name "p6")
    [ "$result" = "M60P" ]
}

@test "get_type_by_git_branch_name: p10 passthrough" {
    result=$(get_type_by_git_branch_name "p10")
    [ "$result" = "p10" ]
}

@test "get_type_by_git_branch_name: c7 -> M70C" {
    result=$(get_type_by_git_branch_name "c7")
    [ "$result" = "M70C" ]
}

@test "get_type_by_git_branch_name: M40P -> M40P" {
    result=$(get_type_by_git_branch_name "M40P")
    [ "$result" = "M40P" ]
}

@test "get_type_by_git_branch_name: M51 -> M51" {
    result=$(get_type_by_git_branch_name "M51")
    [ "$result" = "M51" ]
}

@test "get_type_by_git_branch_name: unknown branch gives nothing" {
    result=$(get_type_by_git_branch_name "main")
    [ -z "$result" ]
}

@test "get_type_by_git_branch_name: M40 -> M40" {
    result=$(get_type_by_git_branch_name "M40")
    [ "$result" = "M40" ]
}

@test "get_type_by_git_branch_name: M50 -> M50" {
    result=$(get_type_by_git_branch_name "M50")
    [ "$result" = "M50" ]
}

@test "get_type_by_git_branch_name: sisyphus gives nothing" {
    result=$(get_type_by_git_branch_name "sisyphus")
    [ -z "$result" ]
}

# --- is_obsoleted (from test_obsoleted.sh) ---

@test "is_obsoleted: recently touched file" {
    tmpfile=$(make_temp_file)
    touch "$tmpfile"
    run find "$tmpfile" -cmin -1 2>/dev/null
    [ -n "$output" ]
    rm -f "$tmpfile"
}

# --- from transf_altdistrversion.sh ---

@test "get_altdistr_version: M60T -> t6" {
    result=$(get_altdistr_version "M60T")
    [ "$result" = "t6" ]
}

@test "get_altdistr_mod: p9 -> M90P" {
    result=$(get_altdistr_mod "p9")
    [ "$result" = "M90P" ]
}

@test "get_altdistr_mod: c9f2 passthrough" {
    result=$(get_altdistr_mod "c9f2")
    [ "$result" = "c9f2" ]
}

@test "get_altdistr_mod: c9 passthrough" {
    result=$(get_altdistr_mod "c9")
    [ "$result" = "c9" ]
}

@test "get_altdistr_mod: Sisyphus -> sisyphus" {
    result=$(get_altdistr_mod "Sisyphus")
    [ "$result" = "sisyphus" ]
}

@test "get_altdistr_mod: sisyphuS -> sisyphus" {
    result=$(get_altdistr_mod "sisyphuS")
    [ "$result" = "sisyphus" ]
}

@test "get_type_by_git_branch_name: t6 -> M60T" {
    result=$(get_type_by_git_branch_name "t6")
    [ "$result" = "M60T" ]
}

@test "get_type_by_git_branch_name: p7 -> M70P" {
    result=$(get_type_by_git_branch_name "p7")
    [ "$result" = "M70P" ]
}


