#!/bin/sh

. `dirname $0`/../share/eterbuild/functions/common
load_mod spec

BPSPEC="$1"

tag="$(get_version $BPSPEC)-$(get_release $BPSPEC)"
is_last_commit_tag "$tag" && echo "last commit with tag $tag" || echo "last commit has no tag $tag"
echo "tag on the last commit: $(get_last_tag)"
