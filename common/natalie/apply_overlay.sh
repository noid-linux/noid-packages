#!/bin/bash
#
# apply_overlay.sh

echo "https://github.com/noid-linux/xbps-repo/releases/download/main" |
  tee /etc/xbps.d/0-noid-repository-main.conf
echo "https://github.com/noid-linux/xbps-repo/releases/download/dinit" |
  tee /etc/xbps.d/0-noid-repository-dinit.conf
echo "https://github.com/noid-linux/xbps-repo/releases/download/nonfree" |
  tee /etc/xbps.d/0-noid-repository-nonfree.conf
cp common/repo-keys/* /var/db/xbps/keys/

cp -r etc/* ../void-packages/etc/
cp -r common/natalie ../void-packages/common/
cp -r --remove-destination srcpkgs/* ../void-packages/srcpkgs/
cp common/repo-keys/* ../void-packages/common/repo-keys/
common/scripts/overlay_shlibs.sh

sed -i ../void-packages/etc/xbps.d/repos-local.conf \
	-e "1i repository=/host/binpkgs/noid-main" \
	-e "1i repository=/host/binpkgs/noid-dinit" \
	-e "1i repository=/host/binpkgs/noid-nonfree"

sed -i ../void-packages/etc/xbps.d/repos-remote.conf \
	-e "1i repository=https://github.com/noid-linux/xbps-repo/releases/download/main" \
	-e "1i repository=https://github.com/noid-linux/xbps-repo/releases/download/dinit" \
	-e "1i repository=https://github.com/noid-linux/xbps-repo/releases/download/nonfree"

sed -i \
	's/= "base-files" ]/= "base-files" ] || [ "${pkgname}" = "noid-base-files" ]/' \
	../void-packages/common/hooks/pre-pkg/99-pkglint.sh
