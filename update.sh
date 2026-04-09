#!/bin/bash
# (c) 2022 Orlando Chamberlain

set -euo pipefail

ARCH_VER=$(curl -s https://archlinux.org/packages/core/x86_64/linux/ | \
	grep "Arch Linux - linux" | \
	tr " " $'\n' | grep arch | cut -d- -f1)

VER=$(echo "$ARCH_VER" | rev | cut -d. -f2- | rev)
OLD_VER=$(grep "^pkgver=" PKGBUILD | cut -d= -f2-)
OLD_PKGREL=$(grep "^pkgrel=" PKGBUILD | cut -d= -f2-)

T2_PATCH_HASH=$(git ls-remote https://github.com/t2linux/linux-t2-patches.git refs/heads/main | cut -d$'\t' -f1)
OLD_T2_PATCH_HASH=$(grep "^T2_PATCH_HASH=" PKGBUILD | cut -d= -f2-)

if [ "$OLD_VER" == "$VER" ]; then
	if [ "$OLD_T2_PATCH_HASH" == "$T2_PATCH_HASH" ]; then
		echo "Up to date ($VER)."
		exit 0
	else
		echo "Kernel version unchanged, but T2 patches updated. Incrementing pkgrel."
		NEW_PKGREL=$((OLD_PKGREL + 1))
		sed -i "s/^T2_PATCH_HASH=.*/T2_PATCH_HASH=$T2_PATCH_HASH/" PKGBUILD
		sed -i "s/^pkgrel=.*/pkgrel=$NEW_PKGREL/" PKGBUILD
		updpkgsums
		touch do_pr
		exit 0
	fi
fi

curl -s https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/raw/main/PKGBUILD > PKGBUILD.orig
curl -s https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/raw/main/config.x86_64 > config

sed -i "s/^T2_PATCH_HASH=.*/T2_PATCH_HASH=$T2_PATCH_HASH/" PKGBUILD
sed -i "s/^pkgrel=.*/pkgrel=1/" PKGBUILD
sed -i "s/^pkgver=.*/pkgver=$VER/" PKGBUILD
sed -i "s/^_pkgver=.*/_pkgver=$VER/" PKGBUILD

updpkgsums

touch do_pr
