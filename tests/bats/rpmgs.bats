#!/usr/bin/env bats

load test_helper

setup() {
	load_common
	TEST_REPO="$(mktemp -d)"
	cd "$TEST_REPO" || return
	git init -q
	git config user.email t@t.t
	git config user.name test

	# Load update_master_branch_to() from rpmgs without running its main body.
	eval "$(sed -n '/^update_master_branch_to()/,/^# update .gear\/@name@-postsubmodules/p' "$PROJECT_ROOT/bin/rpmgs" | sed '$d')"
}

teardown() {
	rm -rf "$TEST_REPO"
}

@test "update_master_branch_to merges the upstream tree for @version@ rules" {
	echo old > source
	git add source
	git commit -qm initial
	git tag 1.0

	git checkout -qb upstream 1.0
	echo new > source
	git commit -am 'upstream 1.1' -q
	git tag 1.1

	git checkout -q master
	mkdir .gear
	echo 'tar: @version@:.' > .gear/rules
	git add .gear/rules
	git commit -qm packaging

	get_tag_by_version() { echo "$1"; }
	QUIET=1
	update_master_branch_to 1.1

	[ "$(cat source)" = new ]
	[ "$(git rev-list --parents -n1 HEAD | wc -w)" -eq 3 ]
}
