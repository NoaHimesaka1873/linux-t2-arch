# Maintainer: Noa Himesaka
# Previous Maintainer: Redecorating
# Contributors: There are many, see `grep -h "From:" *.patch|sort|uniq -c`.
#               Additionally, MrARM and Ronald Tschalär wrote apple-bce and
#               apple-ibridge drivers, respectively.

pkgbase=linux-t2
pkgver=7.2.7.arch1
pkgrel=1
pkgdesc='Linux for T2 Macs'
url='https://github.com/archlinux/linux'
arch=(
  x86_64
)
license=(GPL-2.0-only)
makedepends=(
  bc
  binutils
  cpio
  gettext
  git
  glibc
  libelf
  libgcc
  openssl
  pahole
  perl
  python
  rust
  rust-bindgen
  rust-src
  tar
  xxhash
  xz
  zlib
  zstd

  # htmldocs
  graphviz
  imagemagick
  python-sphinx
  python-yaml
  texlive-latexextra
)
options=(
  !debug
  !strip
)
_srcname=linux-${pkgver%.*}
_srctag=v${pkgver%.*}-${pkgver##*.}
T2_PATCH_HASH=9e773c8876708924dd5e0e5d3093068a0f806ea1
source=(
  https://cdn.kernel.org/pub/linux/kernel/v${pkgver%%.*}.x/${_srcname}.tar.{xz,sign}
  $url/releases/download/$_srctag/linux-$_srctag.patch.zst{,.sig}

  # t2linux Patches
  patches::git+https://github.com/t2linux/linux-t2-patches#commit=${T2_PATCH_HASH}
)
source_x86_64=(config.x86_64)
validpgpkeys=(
  ABAF11C65A2970B130ABE3C479BE3E4300411886  # Linus Torvalds
  647F28654894E3BD457199BE38DBBDC86092693E  # Greg Kroah-Hartman
  83BC8889351B5DEBBB68416EB8AC08600F108CDF  # Jan Alexander Steffens (heftig)
)
sha256sums=('4ac34c47db2540ffb2713943f8d891ff1702e0ba6934525a493b7d1cad43145a'
            'SKIP'
            '22db40cf8a49b46518223ff78cc5b83377474948a4667ee40cacd3f1d571c609'
            'SKIP'
            '9eaf5a2d67ab1743bd93867469fc4b324a138baac92a20da87ba9a0137042d08')
sha256sums_x86_64=('03b341190eeeda2fa80eb3fd4eb2f23605c612bb3b3b8502308b22bde3bb7152')
b2sums=('0fa304e65b0d96d6082e3040db9c974ebdbcfd54a2bc22a8841db63291787f01bf63862d882ecf77cb810f51e91db4e44ac6e27616f93f945531b868b9a1a00d'
        'SKIP'
        '29c08d638cf058e63f3b40d4ccba5dc0d04a51c3f2ad6073d84dd34920f550c2ca7a9dfe11f92c632eb732d0ab76e061770c3659501ac5a40fbff4bd7e052655'
        'SKIP'
        'ad04572cd1f047a2b42660356a39fb4f3e5cd52ba60aeb8a3f18fece089ae68eebdfe440aba1e1a8c3c6a1a66d064276be42ca23f9ffe4ae6cca768bec6451a6')
b2sums_x86_64=('b70a9b80bec8aa71ec09e65aaf7f8949258de172b69405e5fade253795593f2dffd4189025609dd79d24ae8db06d078ee2b80090f120da1626515e8b1f9e70d5')

# https://www.kernel.org/pub/linux/kernel/v7.x/sha256sums.asc

export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"

prepare() {
  cd $_srcname

  echo "Setting version..."
  echo "-Watanare-T2" > localversion.10-codename
  echo "-$pkgrel" > localversion.20-pkgrel
  echo "${pkgbase#linux}" > localversion.30-pkgname

  t2linux_patches=$(ls $srcdir/patches | grep -e \.patch$)
  mv $srcdir/patches/*.patch $srcdir/
  local src
  for src in "${source[@]}" $t2linux_patches; do
    src="${src%%::*}"
    src="${src##*/}"
    src="${src%.zst}"
    [[ $src = *.patch ]] || continue
    echo "Applying patch $src..."
    patch -Np1 < "../$src"
  done

  echo "Setting config..."
  cp ../config.$CARCH .config
  cat $srcdir/patches/extra_config >> .config
  make olddefconfig
  diff -u ../config.$CARCH .config || :

  make -s kernelrelease > version
  echo "Prepared $pkgbase version $(<version)"
}

build() {
  cd $_srcname

  make htmldocs SPHINXOPTS=-QT &
  local pid_docs=$!

  make all
  make -C tools/bpf/bpftool vmlinux.h feature-clang-bpf-co-re=1
  wait $pid_docs
}

_package() {
  pkgdesc="The $pkgdesc kernel and modules"
  depends=(
    coreutils
    initramfs
    kmod
  )
  optdepends=(
    "$pkgbase-headers: headers and scripts for building modules"
    'linux-firmware: firmware images needed for some devices'
    'scx-scheds: to use sched-ext schedulers'
    'wireless-regdb: to set the correct wireless channels of your country'
  )
  provides=(
    KSMBD-MODULE
    NTSYNC-MODULE
    VIRTUALBOX-GUEST-MODULES
    WIREGUARD-MODULE
    linux
  )
  conflicts=(
    apple-gmux-t2-dkms-git
  )
  replaces=(
    apple-gmux-t2-dkms-git
    virtualbox-guest-modules-arch
    wireguard-arch
  )

  cd $_srcname
  local modulesdir="$pkgdir/usr/lib/modules/$(<version)"

  echo "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  echo "Installing modules..."
  ZSTD_CLEVEL=19 make INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 \
    DEPMOD=/doesnt/exist modules_install  # Suppress depmod

  # remove build link
  rm "$modulesdir"/build
}

_package-headers() {
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel"
  depends=(
    binutils
    glibc
    libelf
    libgcc
    openssl
    pahole
    xxhash
    zlib
    zstd
  )
  provides=(
    LINUX-HEADERS
    linux-headers
  )

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  local karch
  case $CARCH in
    x86_64) karch=x86 ;;
    *) echo "Unknown CARCH $CARCH"; exit 1 ;;
  esac

  echo "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux tools/bpf/bpftool/vmlinux.h
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/$karch" -m644 arch/$karch/Makefile
  cp -t "$builddir" -a scripts
  ln -srt "$builddir" "$builddir/scripts/gdb/vmlinux-gdb.py"

  if [[ $(scripts/config -s CONFIG_HAVE_STACK_VALIDATION) = y ]]; then
    install -Dt "$builddir/tools/objtool" tools/objtool/objtool
  fi

  if [[ $(scripts/config -s CONFIG_DEBUG_INFO_BTF_MODULES) = y ]]; then
    install -Dt "$builddir/tools/bpf/resolve_btfids" tools/bpf/resolve_btfids/resolve_btfids
  fi

  echo "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/$karch" -a arch/$karch/include
  install -Dt "$builddir/arch/$karch/kernel" -m644 arch/$karch/kernel/asm-offsets.s

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

  if [[ $(scripts/config -s CONFIG_RUST) = y ]]; then
    echo "Installing Rust files..."
    install -Dt "$builddir/rust" -m644 rust/*.rmeta
    install -Dt "$builddir/rust" rust/*.so
  fi

  echo "Installing unstripped VDSO..."
  make INSTALL_MOD_PATH="$pkgdir/usr" vdso_install \
    link=  # Suppress build-id symlinks

  echo "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */$karch/ ]] && continue
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
    case "$(file -Sib "$file")" in
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
  done < <(
    find Documentation \( -name '.*' -o -name __pycache__ \) -prune \
      -o \! -type d -print0
  )

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/share/doc"
  ln -sr "$builddir/Documentation" "$pkgdir/usr/share/doc/$pkgbase"
}

pkgname=(
  "$pkgbase"
  "$pkgbase-headers"
  "$pkgbase-docs"
)
for _p in "${pkgname[@]}"; do
  eval "package_$_p() {
    $(declare -f "_package${_p#$pkgbase}")
    _package${_p#$pkgbase}
  }"
done

# vim:set ts=8 sts=2 sw=2 et:
