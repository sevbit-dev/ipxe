#!/bin/bash
set -euo pipefail

sudo apt-get install -y make gcc binutils perl git zip mtools genisoimage syslinux liblzma-dev isolinux
src_dir=$(pwd)
mkdir -p ./build && cd ./build
[ -d ./ipxe ] && rm -r ./ipxe
git clone https://github.com/ipxe/ipxe.git
cd ipxe/src/
mkdir -p ${src_dir}/dist
cp ${src_dir}/boot.ipxe ./
cp ${src_dir}/iso.ipxe ./
sed -i '/CONSOLE_FRAMEBUFFER/s/\/\///g' ./config/console.h
sed -i '/DOWNLOAD_PROTO_NFS/s/undef/define/g' ./config/general.h
sed -i '/CONSOLE_CMD/s/\/\///g' ./config/general.h
sed -i '/PING_CMD/s/\/\///g' ./config/general.h
sed -i '/VLAN_CMD/s/\/\///g' ./config/general.h
make bin/ipxe.pxe bin/undionly.kpxe bin/undionly.kkpxe bin/undionly.kkkpxe bin-x86_64-efi/ipxe.efi EMBED=boot.ipxe
make bin/ipxe.iso EMBED=iso.ipxe
make bin-x86_64-efi/ipxe.iso EMBED=iso.ipxe
cp -v bin/{ipxe.pxe,undionly.kpxe,undionly.kkpxe,undionly.kkkpxe} bin-x86_64-efi/ipxe.efi ${src_dir}/dist
cp -v bin/ipxe.iso ${src_dir}/dist/ipxe_bios.iso
cp -v bin-x86_64-efi/ipxe.iso ${src_dir}/dist/ipxe_efi.iso
