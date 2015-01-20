#!/bin/bash

set -ex
rm -rf newroot

mkdir -p newroot/var/lib/pacman
pacman -r newroot --needed --noconfirm -Sy 
pacman -r newroot --needed --noconfirm -U $1

# a minimal reproduction of `useradd -r newroot -m builder`
echo builder:x:500:1000::/home/builder:/bin/bash >>newroot/etc/passwd
echo builder:!:16445:0:99999:7::: >>newroot/etc/shadow
echo builder:x:1000: >>newroot/etc/group
echo builder:!:: >>newroot/gshadow
install -m 700 -o 500 -g 1000 -d newroot/home/builder
