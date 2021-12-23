# Maintainer: James Lambert (jamlam) <jamesl@mbert.onmicrosoft.com>
# Contributor: Aun-Ali Zaidi <admin@kodeit.net>
# Contributor: Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>

pkgbase=mbp-16.1-linux-wifi
pkgver=5.15.7
_srcname=linux-${pkgver}
pkgrel=2
pkgdesc='Linux for MBP 16.1 Wifi'
_srctag=v${pkgver%.*}-${pkgver##*.}
url="https://git.archlinux.org/linux.git/log/?h=v$_srctag"
arch=(x86_64)
license=(GPL2)
makedepends=(
  bc kmod libelf pahole cpio perl tar xz 
  xmlto python-sphinx python-sphinx_rtd_theme graphviz imagemagick
  git
)
options=('!strip')

source=(
  https://www.kernel.org/pub/linux/kernel/v${pkgver//.*}.x/linux-${pkgver}.tar.xz
  https://www.kernel.org/pub/linux/kernel/v${pkgver//.*}.x/linux-${pkgver}.tar.sign
  config         # the main kernel config file

  # Arch Linux patches
  0001-ZEN-Add-sysctl-and-CONFIG-to-disallow-unprivileged-C.patch
  0002-HID-quirks-Add-Apple-Magic-Trackpad-2-to-hid_have_sp.patch

  # Hack for AMD DC eDP link rate bug
  2001-drm-amd-display-Force-link_rate-as-LINK_RATE_RBR2-fo.patch

  # Apple SMC ACPI support
  3001-applesmc-convert-static-structures-to-drvdata.patch
  3002-applesmc-make-io-port-base-addr-dynamic.patch
  3003-applesmc-switch-to-acpi_device-from-platform.patch
  3004-applesmc-key-interface-wrappers.patch
  3005-applesmc-basic-mmio-interface-implementation.patch
  3006-applesmc-fan-support-on-T2-Macs.patch

  # T2 USB Keyboard/Touchpad support
  4001-HID-apple-Add-support-for-keyboard-backlight-on-supp.patch
  4002-HID-apple-Add-support-for-MacbookAir8-1-keyboard-tra.patch
  4003-HID-apple-Add-support-for-MacBookPro15-2-keyboard-tr.patch
  4004-HID-apple-Add-support-for-MacBookPro15-1-keyboard-tr.patch
  4005-HID-apple-Add-support-for-MacBookPro15-4-keyboard-tr.patch
  4006-HID-apple-Add-support-for-MacBookPro16-2-keyboard-tr.patch
  4007-HID-apple-Add-support-for-MacBookPro16-3-keyboard-tr.patch
  4008-HID-apple-Add-support-for-MacBookAir9-1-keyboard-tra.patch
  4009-HID-apple-Add-support-for-MacBookPro16-1-keyboard-tr.patch
  
  # MBP Peripheral support
  6001-media-uvcvideo-Add-support-for-Apple-T2-attached-iSi.patch	# UVC Camera support

  # Hack for i915 overscan issues
  7001-drm-i915-fbdev-Discard-BIOS-framebuffers-exceeding-h.patch

  # Broadcom WIFI/BT device support
  8001-brcmfmac-pcie-Declare-missing-firmware-files-in-pcie.patch
  8002-brcmfmac-firmware-Support-having-multiple-alt-paths.patch
  8003-brcmfmac-firmware-Handle-per-board-clm_blob-files.patch
  8004-brcmfmac-pcie-sdio-usb-Get-CLM-blob-via-standard-fir.patch
  8005-brcmfmac-firmware-Support-passing-in-multiple-board_.patch
  8006-brcmfmac-pcie-Read-Apple-OTP-information.patch
  8007-brcmfmac-of-Fetch-Apple-properties.patch
  8008-brcmfmac-pcie-Perform-firmware-selection-for-Apple-p.patch
  8009-brcmfmac-common-Set-MAC-address-from-platform-inform.patch
  8010-brcmfmac-msgbuf-Increase-RX-ring-sizes-to-1024.patch
  8011-brcmfmac-pcie-Fix-crashes-due-to-early-IRQs.patch
  8012-brcmfmac-pcie-Support-PCIe-core-revisions-64.patch
  8013-brcmfmac-pcie-Add-IDs-properties-for-BCM4378.patch
  8014-ACPI-property-Support-strings-in-Apple-_DSM-props.patch
  8015-brcmfmac-acpi-Add-support-for-fetching-Apple-ACPI-pr.patch
  8016-brcmfmac-pcie-Provide-a-buffer-of-random-bytes-to-th.patch
  8017-brcmfmac-pcie-Add-IDs-properties-for-BCM4355.patch
  8018-brcmfmac-pcie-Add-IDs-properties-for-BCM4377.patch
  8019-brcmfmac-pcie-Perform-correct-BCM4364-firmware-selec.patch
  8020-brcmfmac-chip-Only-disable-D11-cores-handle-an-arbit.patch
  8021-brcmfmac-chip-Handle-1024-unit-sizes-for-TCM-blocks.patch
  8022-brcmfmac-cfg80211-Add-support-for-scan-params-v2.patch
  8023-brcmfmac-feature-Add-support-for-setting-feats-based.patch
  8024-brcmfmac-cfg80211-Add-support-for-PMKID_V3-operation.patch
  8025-brcmfmac-cfg80211-Pass-the-PMK-in-binary-instead-of-.patch
  8026-brcmfmac-pcie-Add-IDs-properties-for-BCM4387.patch
  8027-brcmfmac-pcie-Replace-brcmf_pcie_copy_mem_todev-with.patch
  8028-brcmfmac-pcie-Read-the-console-on-init-and-shutdown.patch
  8029-brcmfmac-pcie-Release-firmwares-in-the-brcmf_pcie_se.patch

  
  9001-bluetooth-add-disable-read-tx-power-quirk.patch
  9002-add-bluetooth-support-for-16,2.patch
  intel-lpss.patch
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

  make -s kernelrelease > version
  echo "Prepared $pkgbase version $(<version)"
}

build() {
  cd $_srcname
  make all
  make htmldocs
}

_package() {
  pkgdesc="The $pkgdesc kernel and modules"
  depends=(coreutils kmod initramfs)
  optdepends=('crda: to set the correct wireless channels of your country'
              'linux-firmware: firmware images needed for some devices')
  provides=(VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE)
  replaces=(virtualbox-guest-modules-arch wireguard-arch)
  provides=("linux=$pkgver")

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
  make INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 modules_install

  # remove build and source links
  rm "$modulesdir"/{source,build}
}

_package-headers() {
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel"
  provides=("linux-headers=$pkgver")

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # add objtool for external module building and enabled VALIDATION_STACK option
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # add xfs and shmem for aufs building
  mkdir -p "$builddir"/{fs/xfs,mm}

  echo "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # http://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # http://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

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

sha256sums=('5d9050a839edc7480c5c8f7a284cd28bee6db07bec9e41c684f399192bbe5db1'
            'SKIP'
            '324a9d46c2338806a0c3ce0880c8d5e85c2ef30d342af3dc96f87b54fae7a586'
            '6b4da532421cac5600d09c0c52742aa52d848af098f7853abe60c02e9d0a3752'
            '2184069ab00ef43d9674756e9b7a56d15188bc4494d34425f04ddc779c52acd8'
            '786dfc22e4c6ece883e7dedd0ba3f6c14018584df95450b2cb78f3da8b01f7cb'
            '7366a08383900a09f8e742b1e4f0a02e0839a385e68e70a89d1815c197df3300'
            '8d8401a99a9dfbc41aa2dc5b6a409a19860b1b918465e19de4a4ff18de075ea3'
            '08d165106fe35b68a7b48f216566951a5db0baac19098c015bcc81c5fcba678d'
            '459906cab172df9f6712a4168e7a5d529f85b2bb58a068f2d44746df14a6d27a'
            '2827dab6eeb2d2a08034938024f902846b5813e967a0ea253dc1ea88315da383'
            '398dec7d54c6122ae2263cd5a6d52353800a1a60fd85e52427c372ea9974a625'
            '11565cff9c6a7db8846dc7d5930419045e9527863b8df5979a7465006211bd16'
            '83f4be6849ba4d5f9fad647ad2eb78bf6409ee98a40ac62e8a5b80496233d70a'
            '44bd3643b2b22fedc59d79511199f30ce6759fa0acdd9a66262a53c5e046da6b'
            'eb04a492197783643b3e72b1d0cf0e856290381997bd165a14fbc63ac1489c25'
            '69d56d42473526f7dbd4fb18c5e1baafe4e6d32995b2506bd48ff981c53b5385'
            '1deeacae1875cf9075b858a8bfb2463ebc531c9030b7c2ab46bbb8e4c3b974db'
            '40eff5e88bb30c51c6b97e85c2e7b8dec5f97916f768e6c07618d9c5afe68574'
            'cac035fe07663a319185c644c5b39b34bef89ada348881fa4a02d15290260445'
            '9dfa9f02d17c5cd9620fa2c1d43ca967b81b6a56d33c2bafae14e0c64e498baa'
            '9640178d6251686c980c30fc528b3d70beac6ce8246bf433506a3f843808326c'
            '90a6012cdd8a64ede8e0bbaf7331960bd68f628e0973b65459188eb1ccb5b829'
            '23a44991bcd6254ff91ab259900bb7decad16efc5b87498c93fcd9bb86fe561a'
            'ec5d81967b7dcbe19c49660a2496d325f4460d8bac84bf230f04c6a285a702ed'
            'b55c3860a65b071fb7f80da5e4832f7fc5a3e9a4dbe812f88ba8fb1f4005845d'
            'b15e0e9312d75916a594a9cab1a713f4b365af679cdfd580c725aca378444605'
            'edfd91b574748e34d28f2252b3105eef19032cb0e7cf2875957070c82c132d10'
            'd882e2be3e8bb709c78e36ad0899f8a6284ae44c1f8498ef47fbe12bfa1fbb39'
            'b8b464fabf1ffdc502e2665fd84b48577080be4326c39f6f805b64e50a62b3af'
            'efdf0d0f803892390a70d9545abd90d9ab508b98f5f0fc311831a8a4d02c0119'
            'ae245a95f809add13a1994be2504cd0ccaad135d9bc23f8c3be1ce9f7a3dc42e'
            'faf6d67326ca84f5e4c48c70a47fae187410dfd7b5ffbf132104a1aeffbc5909'
            'c9634fbdb4e24ce49a83bc0adb6d4c9c94b595c12a192168641336637b7833e6'
            '46e69eb646f6c7b8d12b8b5349548fa974180fac132458f3469fc95d0fd78174'
            '9fa373a3fde819189cbadb79151675a4a7156d0b25f1a0b93a87c2f0e62bc293'
            '5db21c4fdfea64ddfea6d4c60fead96b4c3b38d0e61a9444f1786972866f5aaa'
            '4b1e775e0a0964fe2dd0b546b5e8d419607b0b44a35cfd91093308d53a89a1d2'
            '7aefeec1e2d2ef613370b4d0e78a05ad1bdcfae771940e2211f742807ff248f2'
            'b93e02b6d89500384dcbfe5d46c295e18bd89626345cef35c2be90c69c821f22'
            'f05f06ea251f7178f6d0e59e20b34161e92de402f2ab99015610c467f33c439e'
            '259c85e851b1b5805e906e7087b35af3af1f4a9174b7d68c89a56fe6f4b80b0d'
            '52ef35749aa6277cadde83180fd578a4367e19a6b258843c042c9432ddc671bc'
            '485bce0cb80db01a0d54721d1467ba7f364a6d34d71724c7425c74b084db81b7'
            '0feb043a67032e10ded7e34f4d718783deba95b5a41e1236abf054691d1fefe5'
            'ff89215a47e93f0b72071365a8ccb3579f18927f21bef7cb26615199963161ff'
            '78928fc794afd3e79bf47bfe36d8b045d0837bafeab75df32cbc3c0353f3fedd'
            '395e66232aca126c98a08402156e657685753c0ee1b1cd42b8fae920824317ad'
            'b172ddc0ee1afd2227c2be76d0a7a489e8e8a687d413f1f53bef006eee1ead6c'
            '94144d074f02e0300f93ba29e2a654da05f2105e6f4482822baa064d7c69323e'
            'd1960e90c70f976868a0816b271da8899226cdde972ce4e174e34c49208d717b'
            'afab93d61a17b4d4e442bc05c73ff352fd891ec84bc4ff655289e1ebd23b714c'
            '31e414978a947bdb71f27ed364c4da73b81fcf1921250cb69ee1bcf2bbd25636'
            '5d36770f436b69e69633d060deb55a37b8b3871983068e95fb33d5a195f00574'
            '22b2695afcc4103743e55ceeda4691a59ddce84a8f16d1d572159dd2ff7f8537')
