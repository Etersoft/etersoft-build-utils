#!/usr/bin/env bats

load test_helper

setup() {
    load_mod spec
}

# --- get_numpartrelease ---

@test "get_numpartrelease: alt11 -> 11" {
    result=$(get_numpartrelease "alt11")
    [ "$result" = "11" ]
}

@test "get_numpartrelease: alt12.1t -> 12" {
    result=$(get_numpartrelease "alt12.1t")
    [ "$result" = "12" ]
}

@test "get_numpartrelease: alt3 -> 3" {
    result=$(get_numpartrelease "alt3")
    [ "$result" = "3" ]
}

@test "get_numpartrelease: eter51 -> 51" {
    result=$(get_numpartrelease "eter51")
    [ "$result" = "51" ]
}

# --- is_backported_release ---

@test "is_backported_release: M40P backport" {
    run is_backported_release "alt3.M40P.1"
    [ "$status" -eq 0 ]
}

@test "is_backported_release: M60C backport" {
    run is_backported_release "alt2.M60C.3"
    [ "$status" -eq 0 ]
}

@test "is_backported_release: M80T backport" {
    run is_backported_release "alt1.M80T.2"
    [ "$status" -eq 0 ]
}

@test "is_backported_release: plain release" {
    run is_backported_release "alt11"
    [ "$status" -ne 0 ]
}

@test "is_backported_release: release with dots" {
    run is_backported_release "alt11.1"
    [ "$status" -ne 0 ]
}

# --- decrement_release ---
# Note: function extracts leading digits, so pass numeric part only

@test "decrement_release: 3 -> 2" {
    result=$(decrement_release "3")
    [ "$result" = "2" ]
}

@test "decrement_release: 1 -> 0" {
    result=$(decrement_release "1")
    [ "$result" = "0" ]
}

@test "decrement_release: 51 -> 50" {
    result=$(decrement_release "51")
    [ "$result" = "50" ]
}

@test "decrement_release: 0 stays 0 (no negative)" {
    result=$(decrement_release "0")
    [ "$result" = "0" ]
}

@test "decrement_release: leading digits from alt3" {
    result=$(decrement_release "alt3")
    [ "$result" = "0" ]
}

# --- separate_changelog ---

@test "separate_changelog: splits spec correctly" {
    local tmpdir=$(mktemp -d)
    cat > "$tmpdir/test.spec" <<'EOF'
Name: test
Version: 1.0
Release: alt1
Summary: Test
Group: Other
License: GPL

%description
Test package

%changelog
* Thu Jan 01 2025 Test <test@test.org> 1.0-alt1
- Initial build
EOF
    separate_changelog "$tmpdir/test.spec" "$tmpdir/main.spec" "$tmpdir/changelog.spec"

    # Main part should have Name but not %changelog content
    grep -q "^Name:" "$tmpdir/main.spec"
    ! grep -q "Initial build" "$tmpdir/main.spec"

    # Changelog part should have the changelog entry
    grep -q "Initial build" "$tmpdir/changelog.spec"

    rm -rf "$tmpdir"
}

# --- get_var ---

@test "get_var: extracts Version" {
    result=$(echo -e "Name: test\nVersion: 1.2.3\nRelease: alt1" | get_var "Version")
    [ "$result" = "1.2.3" ]
}

@test "get_var: extracts Name" {
    result=$(echo -e "Name: mypackage\nVersion: 1.0" | get_var "Name")
    [ "$result" = "mypackage" ]
}

@test "get_var: case insensitive" {
    result=$(echo -e "version: 2.0" | get_var "Version")
    [ "$result" = "2.0" ]
}

# --- prevprelease (from test_prevprelease.sh) ---

make_test_spec() {
    local release="$1"
    local tmpdir="$2"
    cat > "$tmpdir/test.spec" <<EOF
Name: get_version_test
Version: 2.1
Release: $release
Summary: Test
Group: Other
License: Public License

%description
Get version test
EOF
}

@test "prevprelease: alt3 -> alt2.M40.3" {
    local tmpdir=$(mktemp -d)
    MDISTR=M40
    make_test_spec "alt3" "$tmpdir"
    local release=$(get_release "$tmpdir/test.spec")
    local baserelease=$(get_numrelease "$tmpdir/test.spec")
    local result="$(get_txtrelease "$tmpdir/test.spec")$(decrement_release "$baserelease").$MDISTR.$baserelease"
    [ "$result" = "alt2.M40.3" ]
    rhas "$result" "alt[0-9]+\.M40\.[0-9]+"
    rm -rf "$tmpdir"
}

@test "prevprelease: alt1 -> alt0.M40.1" {
    local tmpdir=$(mktemp -d)
    MDISTR=M40
    make_test_spec "alt1" "$tmpdir"
    local release=$(get_release "$tmpdir/test.spec")
    local baserelease=$(get_numrelease "$tmpdir/test.spec")
    local result="$(get_txtrelease "$tmpdir/test.spec")$(decrement_release "$baserelease").$MDISTR.$baserelease"
    [ "$result" = "alt0.M40.1" ]
    rm -rf "$tmpdir"
}

@test "prevprelease: alt0 -> alt0.M40.0" {
    local tmpdir=$(mktemp -d)
    MDISTR=M40
    make_test_spec "alt0" "$tmpdir"
    local release=$(get_release "$tmpdir/test.spec")
    local baserelease=$(get_numrelease "$tmpdir/test.spec")
    local result="$(get_txtrelease "$tmpdir/test.spec")$(decrement_release "$baserelease").$MDISTR.$baserelease"
    [ "$result" = "alt0.M40.0" ]
    rm -rf "$tmpdir"
}

@test "prevprelease: alt51 -> alt50.M40.51" {
    local tmpdir=$(mktemp -d)
    MDISTR=M40
    make_test_spec "alt51" "$tmpdir"
    local release=$(get_release "$tmpdir/test.spec")
    local baserelease=$(get_numrelease "$tmpdir/test.spec")
    local result="$(get_txtrelease "$tmpdir/test.spec")$(decrement_release "$baserelease").$MDISTR.$baserelease"
    [ "$result" = "alt50.M40.51" ]
    rm -rf "$tmpdir"
}

@test "prevprelease: eter51 -> eter50.M40.51" {
    local tmpdir=$(mktemp -d)
    MDISTR=M40
    make_test_spec "eter51" "$tmpdir"
    local release=$(get_release "$tmpdir/test.spec")
    local baserelease=$(get_numrelease "$tmpdir/test.spec")
    local result="$(get_txtrelease "$tmpdir/test.spec")$(decrement_release "$baserelease").$MDISTR.$baserelease"
    [ "$result" = "eter50.M40.51" ]
    rm -rf "$tmpdir"
}

# --- remove_bashism (from test_remove_bashism.sh) ---

@test "remove_bashism: converts pushd/popd" {
    local tmpdir=$(mktemp -d)
    cat > "$tmpdir/test.spec" <<'EOF'
Name: test
Version: 1.0
Release: alt1
Summary: Test
Group: Other
License: GPL

%build
pushd txt
echo hello
popd

%description
Test
%changelog
* Date
- Hello
EOF
    # Disable tput calls and checkbashisms in test env
    SETCOLOR_SUCCESS() { :; }
    SETCOLOR_NORMAL() { :; }
    EPMCMD=true
    remove_bashism "$tmpdir/test.spec"
    grep -q "^cd txt >/dev/null" "$tmpdir/test.spec"
    grep -q "^cd - >/dev/null" "$tmpdir/test.spec"
    ! grep -q "^pushd" "$tmpdir/test.spec"
    ! grep -q "^popd" "$tmpdir/test.spec"
    rm -rf "$tmpdir"
}
