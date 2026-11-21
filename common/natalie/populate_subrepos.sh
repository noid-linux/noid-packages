#!/bin/bash
#
# populate_subrepos.sh

for subrepo in $(basename -a $(fd -t d '' ../void-packages/hostdir/binpkgs/)); do
	subrepo_dir="xbps-repo/$(sed 's/noid-//' <<< $subrepo)"
	mkdir -p "$subrepo_dir"

	for pkg in $(rg -P "repository=\"?$subrepo\"?" srcpkgs/*/template | sed 's|srcpkgs/\([^/]*\)/.*|\1|'); do
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
		mv hostdir/binpkgs/$subrepo/$package ../noid-packages/$subrepo_dir

		for spkg in $subpkgs; do
			subpackage=$spkg-${version}_$revision.x86_64.xbps
			mv hostdir/binpkgs/$subrepo/$subpackage ../noid-packages/$subrepo_dir
		done

		cd -
	done

	if [ -z "$(ls $subrepo_dir)" ]; then
		rm -rf $subrepo_dir
	fi
done
