#!/bin/bash
fallocate -l 500M disk # instead of qemu-img
mkfs.fat -F 32 disk
mkdir -p out
sudo mount ./disk out
sudo mkdir -p out/EFI/BOOT/
cp /usr/share/edk2/x64/OVMF_VARS.4m.fd vars.fd
cat test.sh