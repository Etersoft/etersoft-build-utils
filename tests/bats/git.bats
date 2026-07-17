#!/usr/bin/env bats

load test_helper

setup() {
    load_mod git
}

# --- version_to_tag ---

@test "version_to_tag: tilde replacement" {
    result=$(version_to_tag "1.0~rc1-alt1")
    [ "$result" = "1.0.tilde.rc1-alt1" ]
}

@test "version_to_tag: plus replacement" {
    result=$(version_to_tag "1.0+dfsg-alt1")
    [ "$result" = "1.0.plus.dfsg-alt1" ]
}

@test "version_to_tag: both tilde and plus" {
    result=$(version_to_tag "1.0~rc1+dfsg-alt1")
    [ "$result" = "1.0.tilde.rc1.plus.dfsg-alt1" ]
}

@test "version_to_tag: no special chars" {
    result=$(version_to_tag "1.0-alt1")
    [ "$result" = "1.0-alt1" ]
}

@test "version_to_tag: multiple tildes" {
    result=$(version_to_tag "1.0~alpha~1-alt1")
    [ "$result" = "1.0.tilde.alpha.tilde.1-alt1" ]
}

# --- tag_to_version ---

@test "tag_to_version: tilde back" {
    result=$(tag_to_version "1.0.tilde.rc1-alt1")
    [ "$result" = "1.0~rc1-alt1" ]
}

@test "tag_to_version: plus back" {
    result=$(tag_to_version "1.0.plus.dfsg-alt1")
    [ "$result" = "1.0+dfsg-alt1" ]
}

@test "tag_to_version: both back" {
    result=$(tag_to_version "1.0.tilde.rc1.plus.dfsg-alt1")
    [ "$result" = "1.0~rc1+dfsg-alt1" ]
}

@test "tag_to_version: no special back" {
    result=$(tag_to_version "1.0-alt1")
    [ "$result" = "1.0-alt1" ]
}

# --- roundtrip: tag_to_version(version_to_tag(v)) == v ---

@test "roundtrip: 1.0~rc1-alt1" {
    ver="1.0~rc1-alt1"
    result=$(tag_to_version "$(version_to_tag "$ver")")
    [ "$result" = "$ver" ]
}

@test "roundtrip: 2.3+dfsg-alt2" {
    ver="2.3+dfsg-alt2"
    result=$(tag_to_version "$(version_to_tag "$ver")")
    [ "$result" = "$ver" ]
}

@test "roundtrip: 1.0~beta1+repack-alt1" {
    ver="1.0~beta1+repack-alt1"
    result=$(tag_to_version "$(version_to_tag "$ver")")
    [ "$result" = "$ver" ]
}

@test "roundtrip: 3.14-alt1" {
    ver="3.14-alt1"
    result=$(tag_to_version "$(version_to_tag "$ver")")
    [ "$result" = "$ver" ]
}

# --- normalize_girar_name ---

@test "normalize_girar_name: ga -> git.alt" {
    result=$(normalize_girar_name "ga")
    [ "$result" = "git.alt" ]
}

@test "normalize_girar_name: galt -> git.alt" {
    result=$(normalize_girar_name "galt")
    [ "$result" = "git.alt" ]
}

@test "normalize_girar_name: ge -> git.eter" {
    result=$(normalize_girar_name "ge")
    [ "$result" = "git.eter" ]
}

@test "normalize_girar_name: geter -> git.eter" {
    result=$(normalize_girar_name "geter")
    [ "$result" = "git.eter" ]
}

@test "normalize_girar_name: passthrough unknown" {
    result=$(normalize_girar_name "git.alt")
    [ "$result" = "git.alt" ]
}

# --- is_girar_name ---

@test "is_girar_name: git.alt" {
    run is_girar_name "git.alt"
    [ "$status" -eq 0 ]
}

@test "is_girar_name: git.eter" {
    run is_girar_name "git.eter"
    [ "$status" -eq 0 ]
}

@test "is_girar_name: gitery" {
    run is_girar_name "gitery"
    [ "$status" -eq 0 ]
}

@test "is_girar_name: github" {
    run is_girar_name "github"
    [ "$status" -ne 0 ]
}

@test "is_girar_name: empty string" {
    run is_girar_name ""
    [ "$status" -ne 0 ]
}
