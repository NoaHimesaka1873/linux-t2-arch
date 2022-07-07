# Maintainer: Redecorating
# Contributors: There are many, see `grep -h "From:" *.patch|sort|uniq -c`.
#               Additionally, MrARM and Ronald Tschalär wrote apple-bce and
#               apple-ibridge drivers, respectively.

pkgbase=linux-t2
pkgver=5.19.rc4
_srcname=$(echo linux-${pkgver} | sed -e s/\.rc/-rc/)
pkgrel=4
pkgdesc='Linux kernel for T2 Macs'
_srctag=v${pkgver%.*}-${pkgver##*.}
url="https://github.com/archlinux/linux/commits/$_srctag"
arch=(x86_64)
license=(GPL2)
makedepends=(
  bc libelf pahole cpio perl tar xz
  xmlto python-sphinx python-sphinx_rtd_theme graphviz imagemagick texlive-latexextra
  git
)
options=('!strip')

source=(
  https://git.kernel.org/torvalds/t/linux-5.19-rc4.tar.gz
  config         # the main kernel config file

  # Arch Linux patches
  0001-arch-additions.patch

  # apple-bce, apple-ibridge
  apple-bce::git+https://github.com/t2linux/apple-bce-drv#commit=f93c6566f98b3c95677de8010f7445fa19f75091
  apple-ibridge::git+https://github.com/Redecorating/apple-ib-drv#commit=467df9b11cb55456f0365f40dd11c9e666623bf3

  1001-Put-apple-bce-and-apple-ibridge-in-drivers-staging.patch
  1002-add-modalias-to-apple-bce.patch

  # Fix some acpi errors
  2001-fix-acpica-for-zero-arguments-acpi-calls.patch

  # Apple SMC ACPI support
  3001-applesmc-convert-static-structures-to-drvdata.patch
  3002-applesmc-make-io-port-base-addr-dynamic.patch
  3003-applesmc-switch-to-acpi_device-from-platform.patch
  3004-applesmc-key-interface-wrappers.patch
  3005-applesmc-basic-mmio-interface-implementation.patch
  3006-applesmc-fan-support-on-T2-Macs.patch
  3007-applesmc-Add-iMacPro-to-applesmc_whitelist.patch

  # T2 USB Touchpad support
  4001-Input-bcm5974-Add-support-for-the-T2-Macs.patch

  # make hid not touch tb to avoid `vhci: [00] URB failed: 3`
  5001-Fix-for-touchbar.patch

  # Hack for i915 overscan issues
  7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch

  # Broadcom WIFI device support
  # https://github.com/AsahiLinux/linux/commits/bits/080-wifi
  8001-asahilinux-wifi-patchset.patch

  # Broadcom Bluetooth device support
  # https://github.com/AsahiLinux/linux/tree/bluetooth-wip
  9001-asahilinux-bluetooth-WIP.patch

)
validpgpkeys=(
  'ABAF11C65A2970B130ABE3C479BE3E4300411886'  # Linus Torvalds
  '647F28654894E3BD457199BE38DBBDC86092693E'  # Greg Kroah-Hartman
)

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"

prepare() {
  cd $_srcname

  echo "Setting version..."
  scripts/setlocalversion --save-scmversion
  echo "-$pkgrel" > localversion.10-pkgrel
  echo "${pkgbase#linux}" > localversion.20-pkgname

  for i in apple-bce apple-ibridge; do
    echo "Copying $i in to drivers/staging..."
	# no need to copy .git/
	mkdir drivers/staging/$i
    cp -r $srcdir/$i/* drivers/staging/$i/
  done

  local src
  for src in "${source[@]}"; do
    src="${src%%::*}"
    src="${src##*/}"
    [[ $src = *.patch ]] || continue
    echo "Applying patch $src..."
    patch -Np1 < "../$src"
  done

  echo "Setting config..."
  cp ../config .config
  make olddefconfig
  ./scripts/config --module CONFIG_BT_HCIBCM43XX
  diff -u ../config .config || :

  make -s kernelrelease > version
  echo "Prepared $pkgbase version $(<version)"
}

build() {
  cd $_srcname
  make htmldocs all
}

_package() {
  pkgdesc="The $pkgdesc kernel and modules"
  depends=(coreutils kmod initramfs)
  optdepends=('wireless-regdb: to set the correct wireless channels of your country'
              'linux-firmware: firmware images needed for some devices')
  provides=(VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE linux)
  replaces=(virtualbox-guest-modules-arch wireguard-arch)

  cd $_srcname
  local kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$kernver"

  echo "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  echo "Installing modules..."
  make INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 \
    DEPMOD=/doesnt/exist modules_install  # Suppress depmod

  # remove build and source links
  rm "$modulesdir"/{source,build}
}

_package-headers() {
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel"
  depends=(pahole)
  provides=(linux-headers)

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # required when STACK_VALIDATION is enabled
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # required when DEBUG_INFO_BTF_MODULES is enabled
  install -Dt "$builddir/tools/bpf/resolve_btfids" tools/bpf/resolve_btfids/resolve_btfids

  echo "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # https://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # https://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

  # https://bugs.archlinux.org/task/71392
  install -Dt "$builddir/drivers/iio/common/hid-sensors" -m644 drivers/iio/common/hid-sensors/*.h

  echo "Installing KConfig files..."
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  echo "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */x86/ ]] && continue
    echo "Removing $(basename "$arch")"
    rm -r "$arch"
  done

  echo "Removing documentation..."
  rm -r "$builddir/Documentation"

  echo "Removing broken symlinks..."
  find -L "$builddir" -type l -printf 'Removing %P\n' -delete

  echo "Removing loose objects..."
  find "$builddir" -type f -name '*.o' -printf 'Removing %P\n' -delete

  echo "Stripping build tools..."
  local file
  while read -rd '' file; do
    case "$(file -bi "$file")" in
      application/x-sharedlib\;*)      # Libraries (.so)
        strip -v $STRIP_SHARED "$file" ;;
      application/x-archive\;*)        # Libraries (.a)
        strip -v $STRIP_STATIC "$file" ;;
      application/x-executable\;*)     # Binaries
        strip -v $STRIP_BINARIES "$file" ;;
      application/x-pie-executable\;*) # Relocatable binaries
        strip -v $STRIP_SHARED "$file" ;;
    esac
  done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux -print0)

  echo "Stripping vmlinux..."
  strip -v $STRIP_STATIC "$builddir/vmlinux"

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"
}

_package-docs() {
  pkgdesc="Documentation for the $pkgdesc kernel"
  provides=(linux-docs)

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing documentation..."
  local src dst
  while read -rd '' src; do
    dst="${src#Documentation/}"
    dst="$builddir/Documentation/${dst#output/}"
    install -Dm644 "$src" "$dst"
  done < <(find Documentation -name '.*' -prune -o ! -type d -print0)

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/share/doc"
  ln -sr "$builddir/Documentation" "$pkgdir/usr/share/doc/$pkgbase"
}

pkgname=("$pkgbase" "$pkgbase-headers" "$pkgbase-docs")
for _p in "${pkgname[@]}"; do
  eval "package_$_p() {
    $(declare -f "_package${_p#$pkgbase}")
    _package${_p#$pkgbase}
  }"
done

sha256sums=('ccd7110dad8dcc260e2891ea3c89bd4aaad0cbe2c055b1280147e76ece20f06c'
            '382aa201a6a6939210dd8668ab052724547b4bd489b38e97502bbd0848061b35'
            '152fc6cc5cd6ddff14b03eefe4810743f33b9f907da9f88252d43fae58a53c90'
            'SKIP'
            'SKIP'
            'de6bb60597cff6179e1a2c407d6fa541f29454e4dbd97756724bfe7a9e68f31e'
            'a3a43feaffccbcd119f4a1b4e1299ef07ae36ef9bffc17767bf10e447fa02a2a'
            '45b911e592dd6c717e77ec4d8cbf844860bb7c29ace7a7170e7bf59c12e91bb4'
            'cfd23a06797ac86575044428a393dd7f10f06eff7648d0b78aedad82cbe41279'
            '8d8401a99a9dfbc41aa2dc5b6a409a19860b1b918465e19de4a4ff18de075ea3'
            '08d165106fe35b68a7b48f216566951a5db0baac19098c015bcc81c5fcba678d'
            '62f6d63815d4843ca893ca76b84a9d32590a50358ca0962017ccd75a40884ba8'
            '2827dab6eeb2d2a08034938024f902846b5813e967a0ea253dc1ea88315da383'
            '398dec7d54c6122ae2263cd5a6d52353800a1a60fd85e52427c372ea9974a625'
            'd4ca5a01da5468a1d2957b8eb4a819e1b867a3bcd1cd47389d7c9ac9154b5430'
            'b1f19084e9a9843dd8c457c55a8ea8319428428657d5363d35df64fb865a4eae'
            '92e6f4173074ac902c3fc397ea39a5ff6d5eb8645539645c0cd61b3d05ac83ca'
            '9ede98eceb69e9c93e25fdb2c567466963bdd2f81c0ecb9fb9e5107f6142ff26'
            '86b36a173e3608b844ed37dbe909f61b9a1aa593321cd45a5d08e91fe0e809fc'
            'SKIP')
# vim:set ts=8 sts=2 sw=2 et:
