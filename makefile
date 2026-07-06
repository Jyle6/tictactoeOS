out/EFI/BOOT/BOOTX64.EFI: src/*.c
	x86_64-w64-mingw32-gcc \
		-ffreestanding \
		-nostdlib \
		-fno-stack-protector \
		-fshort-wchar \
		-mno-red-zone \
		-shared -Wl,-dll \
		-Wl,--subsystem,10 \
		-e efi_main \
		-o out/EFI/BOOT/BOOTX64.EFI \
		*.c

.PHONY: setup clean test
setup: setup_devel.sh
	./$<

clean: clean_devel.sh
	./$<

test: test.sh
	./$<