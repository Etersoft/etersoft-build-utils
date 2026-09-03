#!/usr/bin/env bats

load test_helper

setup() {
	load_mod spec
	repo="$BATS_TEST_TMPDIR/repo"
	mkdir -p "$repo/.gear"
	cp "$PROJECT_ROOT/tests/specpkgr.spec" "$repo/one.spec"
	cp "$PROJECT_ROOT/tests/specpkgr.spec" "$repo/two.spec"
	touch "$repo/.gear/rules" "$repo/source.txt"
	git -C "$repo" init -q
	git -C "$repo" config user.name Test
	git -C "$repo" config user.email test@example.invalid
	git -C "$repo" add .
	git -C "$repo" commit -qm initial
	git -C "$repo" tag start
}

@test "rpmlog updates several specs and commits them together" {
	printf '%s\n' changed >> "$repo/source.txt"
	git -C "$repo" add source.txt
	git -C "$repo" commit -qm 'Change code'
	printf '%s\n' '#!/bin/sh' 'echo "$1" >> hook.calls' > "$repo/.gear/new-build-postcommit-hook"

	cd "$repo"
	run env PATH="$PROJECT_ROOT/bin:$PATH" \
		"$PROJECT_ROOT/bin/rpmlog" -q -a -l one.spec two.spec start HEAD

	[ "$status" -eq 0 ]
	[ "$(get_version one.spec)" = "0.7.5" ]
	[ "$(get_release one.spec)" = "alt1" ]
	[ "$(get_version two.spec)" = "0.7.5" ]
	[ "$(get_release two.spec)" = "alt1" ]
	[ "$(grep -c -- '^- change code$' one.spec)" -eq 1 ]
	[ "$(grep -c -- '^- change code$' two.spec)" -eq 1 ]
	[ "$(git show --pretty= --name-only HEAD | sort)" = $'one.spec\ntwo.spec' ]
	[ "$(cat hook.calls)" = "0.7.5-alt1" ]
}

@test "rpmlog rejects specs with different revisions before changing them" {
	sed -i -e 's/^Version:.*/Version: 9.9/' -e 's/^Release:.*/Release: alt99/' "$repo/two.spec"
	cd "$repo"

	run env PATH="$PROJECT_ROOT/bin:$PATH" \
		"$PROJECT_ROOT/bin/rpmlog" -q -r -l one.spec two.spec start HEAD

	[ "$status" -eq 1 ]
	[[ "$output" == *"two.spec has revision 9.9-alt99, expected 0.7.4-alt18 from one.spec"* ]]
	[ "$(get_version one.spec)-$(get_release one.spec)" = "0.7.4-alt18" ]
	[ "$(get_version two.spec)-$(get_release two.spec)" = "9.9-alt99" ]
	[ "$(git rev-list --count HEAD)" -eq 1 ]
}
