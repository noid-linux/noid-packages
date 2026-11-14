#!/bin/bash
#
# remove_outdated.sh

fetch_existing_packages() {
	xbps-query --repository="$BASEURL/$1" -RsiM "*" |
		awk '{ print $2".x86_64.xbps" }'
}

for subrepo in $(ls -1 xbps-repo); do
	if ! curl -LfIs "$BASEURL/$subrepo/x86_64-repodata" >/dev/null; then
		echo "Subrepo doesn't exist yet, skipping…"
		continue
	fi

	for epkg in $(fetch_existing_packages $subrepo); do
		if rg ^"$(sed 's/\(.*\)-.*/\1/' <<< $epkg)"$ <(ls -1 xbps-repo/$subrepo/*.xbps | sed 's/\(.*\)-.*/\1/'); then
			gh release delete-asset $subrepo $epkg -y \
			   -R noid-linux/xbps-repo

			gh release delete-asset $subrepo $epkg.sig2 -y \
			   -R noid-linux/xbps-repo
		fi
	done

	gh release delete-asset $subrepo x86_64-repodata -y \
	   -R noid-linux/xbps-repo

	gh release delete-asset $subrepo $subrepo.txt -y \
	   -R noid-linux/xbps-repo
done
