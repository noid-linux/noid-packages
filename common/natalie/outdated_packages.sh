#!/bin/bash
#
# outdated_packages.sh

remote_index() {
	for subrepo in $(rg -P "repository=" srcpkgs/*/template | sed 's/.*repository=\"\?noid-\([^"]*\)\"\?/\1/' | sort -u); do
		if curl -LfIs "$BASEURL/$subrepo/x86_64-repodata" >/dev/null; then
			xbps-query --repository="$BASEURL/$subrepo" -RsiM "*" | awk '{ print $2 }'
		fi
	done
}

local_index() {
	for pkg in $(ls -1 srcpkgs); do
		ver=$(rg "^version=" srcpkgs/$pkg/template | awk -F= '{ print $2 }')
		rev=$(rg "^revision=" srcpkgs/$pkg/template | awk -F= '{ print $2 }')
		echo -e "$pkg-${ver}_$rev"
	done
}

echo -e "\x1b[32mChanged packages:\x1b[0m"
comm -13 <(remote_index | sort -u) <(local_index | sort) |
	sed 's/\(.*\)-.*/\1/' |
	xargs ./../void-packages/xbps-src sort-dependencies | # TODO: figure out a less stupid way to do this
	tee /tmp/templates |
	sed "s/^/  /" >&2
