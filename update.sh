#!/bin/bash
# (c) 2022 Orlando Chamberlain

set -euo pipefail

# Codename rotation: the next line after the current one, wrapping around.
# An unknown or empty current value gives the first line.
next_in_list() {
	local next
	next=$(grep -A1 -xF -- "$2" "$1" | sed -n 2p || :)
	[ -n "$next" ] || next=$(head -n1 "$1")
	echo "$next"
}

rotate_slogan() {
	local cur
	cur=$(grep "^_slogan=" PKGBUILD | cut -d= -f2-)
	sed -i "s/^_slogan=.*/_slogan=$(next_in_list slogans "$cur")/" PKGBUILD
}

rotate_anime() {
	local cur
	cur=$(grep "^_anime=" PKGBUILD | cut -d= -f2-)
	sed -i "s/^_anime=.*/_anime=$(next_in_list animes "$cur")/" PKGBUILD
}

ARCH_VER=$(curl -s https://archlinux.org/packages/core/x86_64/linux-lts/ | \
	grep "Arch Linux - linux-lts" | \
	tr " " $'\n' | grep 6.18 | cut -d- -f1)

VER=$ARCH_VER
OLD_VER=$(grep "^pkgver=" PKGBUILD | cut -d= -f2-)
OLD_PKGREL=$(grep "^pkgrel=" PKGBUILD | cut -d= -f2-)

T2_PATCH_HASH=$(git ls-remote https://github.com/t2linux/linux-t2-patches.git refs/heads/6.18 | cut -d$'\t' -f1)
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
		rotate_slogan
		updpkgsums
		touch do_pr
		exit 0
	fi
fi

curl -sf https://gitlab.archlinux.org/archlinux/packaging/packages/linux-lts/-/raw/main/PKGBUILD > PKGBUILD.orig
curl -sf https://gitlab.archlinux.org/archlinux/packaging/packages/linux-lts/-/raw/main/config.x86_64 > config.x86_64

sed -i "s/^T2_PATCH_HASH=.*/T2_PATCH_HASH=$T2_PATCH_HASH/" PKGBUILD
sed -i "s/^pkgrel=.*/pkgrel=1/" PKGBUILD
sed -i "s/^pkgver=.*/pkgver=$VER/" PKGBUILD

# New anime every major release (7.3 -> 7.4), new slogan every version.
if [ "$(echo "$OLD_VER" | cut -d. -f1-2)" != "$(echo "$VER" | cut -d. -f1-2)" ]; then
	rotate_anime
fi
rotate_slogan

updpkgsums

touch do_pr
