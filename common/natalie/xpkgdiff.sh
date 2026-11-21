#!/bin/bash
#
# xpkgdiff.sh

set -e

export XBPS_TARGET_ARCH="$2"
export DIFF='diff --unified=0 --report-identical-files --suppress-common-lines
 --color=always --label REPO --label BUILT'
ARGS="-a $2 -R https://repo-ci.voidlinux.org/current -R https://github.com/noid-linux/xbps-repo/releases/download/main -R https://github.com/noid-linux/xbps-repo/releases/download/dinit -R https://github.com/noid-linux/xbps-repo/releases/download/nonfree"

repositories=("--repository=hostdir/binpkgs/bootstrap" "--repository=hostdir/binpkgs" "--repository=hostdir/binpkgs/nonfree"  "--repository=hostdir/binpkgs/noid-main" "--repository=hostdir/binpkgs/noid-dinit" "--repository=hostdir/binpkgs/noid-nonfree")

while read -r pkg; do
	for subpkg in $(xsubpkg $pkg); do
		if xbps-query "${repositories[@]}" -i "$subpkg" >&/dev/null; then
			/bin/echo -e "\x1b[34mFile Diff of $subpkg:\x1b[0m"
			xpkgdiff $ARGS -f $subpkg
			/bin/echo -e "\x1b[34mMetadata Diff of $subpkg:\x1b[0m"
			xpkgdiff $ARGS -S $subpkg
			/bin/echo -e "\x1b[34mDependency Diff of $subpkg:\x1b[0m"
			xpkgdiff $ARGS -x $subpkg
		else
			/bin/echo -e "\x1b[33m$subpkg wasn't found\x1b[0m"
		fi
	done
done < /tmp/templates
