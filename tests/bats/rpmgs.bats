#!/usr/bin/env bats

load test_helper

setup() {
	load_common || return
	TEST_REPO="$(mktemp -d)"
	cd "$TEST_REPO" || return
	git init -q
	git config user.email t@t.t
	git config user.name test

	# Load update_master_branch_to() from rpmgs without running its main body.
	eval "$(sed -n '/^update_master_branch_to()/,/^# update .gear\/@name@-postsubmodules/p' "$PROJECT_ROOT/bin/rpmgs" | sed '$d')"
	eval "$(sed -n '/^commit_upstream_tags()/,/^# merge from guessed tag/p' "$PROJECT_ROOT/bin/rpmgs" | sed '$d')"
}

prepare_tag_commit_fixture() {
	mkdir -p .gear/tags
	printf 'Name: example\nVersion: 1.0\nRelease: alt1\n%%changelog\n' > example.spec
	printf 'spec: example.spec\ntar: .\n' > .gear/rules
	echo old > .gear/tags/list
	git add .
	git commit -qm initial
	echo new > .gear/tags/list
	sed -i 's/Version: 1.0/Version: 2.0/' example.spec
	git add example.spec .gear/tags
}

@test "stored upstream tags commit skips editor and leaves staged spec for release" {
	prepare_tag_commit_fixture
	export EDITOR=false GIT_EDITOR=false
	QUIET=-q
	commit_upstream_tags
	[ "$(git diff-tree --no-commit-id --name-only -r HEAD)" = .gear/tags/list ]
	[ "$(git diff --cached --name-only)" = example.spec ]
	[ "$(git show HEAD:example.spec | sed -n '2p')" = 'Version: 1.0' ]
	local head=$(git rev-parse HEAD)
	commit_upstream_tags
	[ "$(git rev-parse HEAD)" = "$head" ]
}

@test "stored upstream tags commit failure is fatal" {
	prepare_tag_commit_fixture
	printf '#!/bin/sh\nexit 7\n' > .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit
	QUIET=-q
	run commit_upstream_tags
	[ "$status" -ne 0 ]
	[[ "$output" = *'Failed to commit stored upstream tags'* ]]
	[ "$(git rev-list --count HEAD)" = 1 ]
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
