#!/usr/bin/env bats

# Tests for bash behavior (from test_local.sh, test_vars.sh)
# These verify assumptions the codebase makes about shell behavior

@test "bash: local captures multiline output" {
    func() { echo "1"; echo "2"; echo "3"; }
    test_func() { local var=$(func); echo "$var"; }
    result=$(test_func)
    # local preserves newlines in command substitution
    [ "$result" = $'1\n2\n3' ]
}

@test "bash: variable set before function call is visible inside" {
    VAR=
    func() { echo "$VAR"; }
    VAR=test
    result=$(func)
    [ "$result" = "test" ]
}

@test "bash: variable unset after function returns" {
    VAR=
    func() { echo "$VAR"; }
    VAR=test
    func >/dev/null
    VAR=
    result=$(func)
    [ "$result" = "" ]
}

@test "bash: VAR=val func does not persist VAR" {
    VAR=
    func() { echo "$VAR"; }
    result=$(VAR=again func)
    [ "$result" = "again" ]
    # VAR should still be empty after
    [ -z "$VAR" ]
}

@test "bash: VAR=val true does not persist VAR" {
    VAR=
    VAR=try true
    [ -z "$VAR" ]
}
