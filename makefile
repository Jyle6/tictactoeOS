out/EFI/BOOT/BOOTX64.EFI: src/*.c
	sudo x86_64-w64-mingw32-gcc \
		-ffreestanding \
		-nostdlib \
		-fno-stack-protector \
		-fshort-wchar \
		-mno-red-zone \
		-shared -Wl,-dll \
		-Wl,--subsystem,10 \
		-e efi_main \
		-o out/EFI/BOOT/BOOTX64.EFI \
		-I/usr/x86_64-w64-mingw32/include/efi \
		-I/usr/x86_64-w64-mingw32/include/efi/x86_64 \
		src/*.c

.PHONY: setup_devel clean_devel test setup clean
clean: clean_devel
setup: setup_devel
setup_devel:
	fallocate -l 500M disk # instead of qemu-img
	mkfs.fat -F 32 disk
	mkdir -p out
	sudo mount ./disk out
	sudo mkdir -p out/EFI/BOOT/
	cp /usr/share/edk2/x64/OVMF_VARS.4m.fd vars.fd
	cat test.sh

clean_devel:
	sudo umount out/
	rm -f disk
	rmdir out

test:
	qemu-system-x86_64 \
		-drive if=pflash,format=raw,unit=0,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd \
		-drive if=pflash,format=raw,unit=1,file=vars.fd \
		-drive format=raw,file=disk