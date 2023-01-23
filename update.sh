#!/bin/bash
# (c) 2022 Orlando Chamberlain

set -euo pipefail

ARCH_VER=$(curl -s https://archlinux.org/packages/core/x86_64/linux/ | \
	grep "Arch Linux - linux" | \
	tr " " $'\n' | grep arch | cut -d- -f1)

VER=$(echo $ARCH_VER | rev | cut -d. -f2- | rev)
OLD_VER=$(grep pkgver= PKGBUILD | cut -d= -f2-)

if [ $OLD_VER == $VER ]; then
	echo "Up to date ($VER)."
	exit 0
fi

T2_PATCH_HASH=$(git ls-remote https://github.com/t2linux/linux-t2-patches.git refs/heads/main | cut -d$'\t' -f1)

curl -s https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/repos/core-x86_64/PKGBUILD > PKGBUILD.orig
curl -s https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/repos/core-x86_64/config > config

sed -i s/T2_PATCH_HASH=.*/T2_PATCH_HASH=$T2_PATCH_HASH/ PKGBUILD
sed -i s/pkgrel=./pkgrel=1/ PKGBUILD
sed -i s/pkgver=.*/pkgver=$VER/ PKGBUILD

updpkgsums

touch do_pr
