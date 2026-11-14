#!/bin/bash
#
# overlay_shlibs.sh

[ -f common/shlibs ] || exit 0

while IFS= read -r line; do
	case $(awk '{ print $1 }' <<< "$line") in
		append)
			cut -d' ' -f2- <<< "$line" | tee -a ../void-packages/common/shlibs >/dev/null
		;;
		replace)
			soname=$(cut -d' ' -f2 <<< "$line")
			entry=$(cut -d' ' -f2- <<< "$line")

			sed -i "s/$soname.*/$entry/" ../void-packages/common/shlibs
		;;
	esac
done < common/shlibs
