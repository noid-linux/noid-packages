#!/bin/bash
#
# populate_subrepos.sh

for subrepo in $(ls -1 common/repos); do
	mkdir -p "xbps-repo/$subrepo"

	for pkg in $(< common/repos/$subrepo); do
		if ! rg ^"$pkg"$ /tmp/templates; then
		   continue
		fi

		cd ../void-packages

		info=$(./xbps-src show $pkg)

		pkgname=$(rg "pkgname\:" <<< "$info" | awk '{ print $2 }')
		version=$(rg "version\:" <<< "$info" | awk '{ print $2 }')
		revision=$(rg "revision\:" <<< "$info" | awk '{ print $2 }')
		subpkgs=$(rg "subpackages\:" <<< "$info" | awk '{ print $2 }')

		package=$pkgname-${version}_$revision.x86_64.xbps
		mv hostdir/binpkgs/$package ../noid-packages/xbps-repo/$subrepo

		for spkg in $subpkgs; do
			subpackage=$spkg-${version}_$revision.x86_64.xbps
			mv hostdir/binpkgs/$subpackage ../noid-packages/xbps-repo/$subrepo
		done

		cd -
	done

	if [ -z "$(ls xbps-repo/$subrepo)" ]; then
		rm -rf xbps-repo/$subrepo
	fi
done
