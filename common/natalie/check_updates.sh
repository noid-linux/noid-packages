#!/bin/bash
#
# check_updates.sh

header=$(printf "Noid Updates for $(date "+%Y-%m-%d %H:%M %Z")")
echo -e "$header\n${header//?/=}" | tee noid-updates.txt

while IFS= read -r m; do

	updates=""
	for pkg in $(rg -l "$m" ../noid-packages/srcpkgs/*/template | sed 's|.*srcpkgs/\(.*\)/template|\1|'); do
		updates+=$(./xbps-src update-check $pkg | xargs -I {} echo -e "\n{}")
	done

	if [ -n "$updates" ]; then
		echo -e "\n$m\n${m//?/-}\n$updates" | tee -a noid-updates.txt
	fi
done <<< "$(rg -IoP "maintainer=?\"\K[^\"]*" ../noid-packages/srcpkgs/*/template | sort -u)"
