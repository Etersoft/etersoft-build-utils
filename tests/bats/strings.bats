#!/usr/bin/env bats

load test_helper

setup() {
    load_mod strings
}

# --- rhas ---

@test "rhas: matching substring" {
    run rhas "hello world" "world"
    [ "$status" -eq 0 ]
}

@test "rhas: non-matching substring" {
    run rhas "hello" "world"
    [ "$status" -ne 0 ]
}

@test "rhas: regex digits" {
    run rhas "test123" "[0-9]"
    [ "$status" -eq 0 ]
}

@test "rhas: regex no digits" {
    run rhas "test" "[0-9]"
    [ "$status" -ne 0 ]
}

@test "rhas: anchor start" {
    run rhas "abc" "^a"
    [ "$status" -eq 0 ]
}

@test "rhas: anchor start fail" {
    run rhas "abc" "^b"
    [ "$status" -ne 0 ]
}

@test "rhas: anchor end" {
    run rhas "abc" "c$"
    [ "$status" -eq 0 ]
}

@test "rhas: empty string matches .*" {
    run rhas "" ".*"
    [ "$status" -eq 0 ]
}

# --- isnumber ---

@test "isnumber: single digit" {
    run isnumber "5"
    [ "$status" -eq 0 ]
}

@test "isnumber: multi digit" {
    run isnumber "12"
    [ "$status" -eq 0 ]
}

@test "isnumber: empty string" {
    run isnumber ""
    [ "$status" -ne 0 ]
}

@test "isnumber: spaces only" {
    run isnumber " "
    [ "$status" -ne 0 ]
}

@test "isnumber: leading space" {
    run isnumber " 6"
    [ "$status" -eq 0 ]
}

@test "isnumber: trailing space" {
    run isnumber "7 "
    [ "$status" -eq 0 ]
}

@test "isnumber: two numbers" {
    run isnumber "12 5"
    [ "$status" -ne 0 ]
}

@test "isnumber: letter q" {
    run isnumber "q"
    [ "$status" -ne 0 ]
}

@test "isnumber: mixed alphanumeric" {
    run isnumber "52q"
    [ "$status" -ne 0 ]
}

# --- drop_args ---

@test "drop_args: drop single arg" {
    result=$(drop_args "-h -U" U)
    [ "$result" = "-h" ]
}

@test "drop_args: drop with surrounding spaces" {
    result=$(drop_args " -h -U " U)
    [ "$result" = "-h" ]
}

@test "drop_args: drop first arg" {
    result=$(drop_args " -h -U " h)
    [ "$result" = "-U" ]
}

@test "drop_args: drop multiple args" {
    result=$(drop_args " -h -U " h U)
    [ "$result" = "" ]
}

@test "drop_args: drop from three args" {
    result=$(drop_args "-v -n -z" v n)
    [ "$result" = "-z" ]
}

@test "drop_args: empty input" {
    result=$(drop_args "" f a t)
    [ "$result" = "" ]
}

# --- initial_letter ---

@test "initial_letter: single word" {
    result=$(initial_letter "hello")
    [ "$result" = "h" ]
}

@test "initial_letter: single char" {
    result=$(initial_letter "x")
    [ "$result" = "x" ]
}

# --- skip_initial_letter ---

@test "skip_initial_letter: removes first char" {
    result=$(skip_initial_letter "hello")
    [ "$result" = "ello" ]
}

@test "skip_initial_letter: single char gives empty" {
    result=$(skip_initial_letter "x")
    [ "$result" = "" ]
}

# --- is_dirpath ---

@test "is_dirpath: dot is dir" {
    run is_dirpath "."
    [ "$status" -eq 0 ]
}

@test "is_dirpath: text without slash" {
    run is_dirpath "text"
    [ "$status" -ne 0 ]
}

@test "is_dirpath: text with trailing slash" {
    run is_dirpath "text/"
    [ "$status" -eq 0 ]
}

@test "is_dirpath: absolute path" {
    run is_dirpath "/text"
    [ "$status" -eq 0 ]
}

@test "is_dirpath: nested path" {
    run is_dirpath "/text/test"
    [ "$status" -eq 0 ]
}

# --- is_absolute_path ---

@test "is_absolute_path: root path" {
    run is_absolute_path "/usr/bin"
    [ "$status" -eq 0 ]
}

@test "is_absolute_path: relative path" {
    run is_absolute_path "usr/bin"
    [ "$status" -ne 0 ]
}

@test "is_absolute_path: dot path" {
    run is_absolute_path "./bin"
    [ "$status" -ne 0 ]
}

# --- sed with & (from test_sed.sh) ---

@test "sed: handles & in replacement" {
    restext="Summary: test & test"
    rt="$(echo "$restext" | sed -e 's|\&|\\&|g')"
    result=$(echo "Summary: test" | sed -e "s|Summary: .*|$rt|g")
    [ "$result" = "$restext" ]
}
