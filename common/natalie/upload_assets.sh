#!/bin/bash
#
# upload_assets.sh

existing_releases=$(gh release list -R noid-linux/xbps-repo --json tagName -q ".[].tagName")

for subrepo in $(ls -1 xbps-repo); do
	if ! rg $subrepo <<< $existing_releases; then
		echo "Subrepo release doesn't exist yet, creating new…"

		temp_file=$(mktemp)
		./common/scripts/generate_release_notes.sh $subrepo > "$temp_file"

		gh release create $subrepo \
		   --title "Noid Repository [$subrepo]" \
		   -R noid-linux/xbps-repo \
		   -F "$temp_file" \
		   --prerelease # TODO: remove this
	fi

	gh release upload -R noid-linux/xbps-repo $subrepo xbps-repo/$subrepo/*
done
