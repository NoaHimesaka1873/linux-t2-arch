## `Arch Linux Kernel for T2 Macs`
[![Kernel Release Builds](https://github.com/ocean-mars/linux-t2-arch/actions/workflows/KernelReleaseBuilds.yml/badge.svg?branch=main)](https://github.com/ocean-mars/linux-t2-arch/actions/workflows/KernelReleaseBuilds.yml) 

Arch Linux package for Linux kernel with bleeding edge T2 Mac support.

#### To build yourself:

```sh
git clone https://github.com/ocean-mars/linux-t2-arch
cd linux-t2-arch
makepkg -si
```

Or you can `sudo pacman -U` the packages Github CI builds, which can be found on the releases page.
