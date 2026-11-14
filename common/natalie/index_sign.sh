#!/bin/bash
#
# index_sign.sh

for subrepo in $(ls -1 xbps-repo); do
	cd xbps-repo/$subrepo/

	if curl -LfIs "$BASEURL/$subrepo/x86_64-repodata" >/dev/null; then
		echo "Existing subrepo detected, fetching repodata…"
		curl -LO "$BASEURL/$subrepo/x86_64-repodata"
	fi

	# Index
	xbps-rindex -a *.xbps
	../../common/scripts/generate_repository_index.sh | tee $subrepo.txt

	# Sign
    temp_key=$(mktemp)
    echo "$PRIVATE_PEM" > "$temp_key"
    chmod 600 "$temp_key"
    xbps-rindex --privkey "$temp_key" --sign --signedby "noid-packages-github-actions" .
    xbps-rindex --privkey "$temp_key" --sign-pkg *.xbps
    rm -f "$temp_key"

	cd -
done
