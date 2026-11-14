#!/bin/bash
#
# generate_repository_index.sh

split_pkgvers() {
	echo -e "$(sed 's/\(.*\)-.*/\1/' <<< $1)\t$(sed 's/.*-\(.*\)/\1/' <<< $1)\t$2" | column -t -l 3 -o $'\t'
}

# FIXME: this is insane figure out a less stupid way to clean this mess
while IFS= read -r pkg; do
	split_pkgvers $(sed 's/^\[.].//' <<< $pkg | awk '{ print $1 }') "$(cut -d' ' -f2- <<< $pkg)"
done <<< "$(xbps-query --repository=. -RsiM '*' | sed 's/^\[.].//')"
