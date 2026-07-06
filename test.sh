#!/bin/bash
qemu-system-x86_64 \
  -drive if=pflash,format=raw,unit=0,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
  -drive if=pflash,format=raw,unit=1,file=vars.fd \
  -drive format=raw,file=disk