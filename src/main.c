#include <efi/efi.h>
#include <efi/efidef.h>
#include <efi/efierr.h>
#include <efi/efiprot.h>
#include <efi/x86_64/efibind.h>
#include "font8x8.h"

void* memcpy(void* dest, const void* src, UINTN n) {
    char* d = (char*)dest;
    const char* s = (const char*)src;
    for (UINTN i = 0; i < n; i++) {
        d[i] = s[i];
    }
    return dest;
}
#define auto __auto_type

EFI_STATUS efi_main(EFI_HANDLE imagehandle, EFI_SYSTEM_TABLE *systemtable) {
	EFI_GRAPHICS_OUTPUT_PROTOCOL* gop;
	systemtable->BootServices->LocateProtocol(&(EFI_GUID)EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID, NULL, (VOID*)&gop);
	auto mode = *gop->Mode;
	auto minfo = *mode.Info;
	UINT32* vram;
	UINT32* fb = (UINT32*)mode.FrameBufferBase;
	UINTN fb_size = mode.FrameBufferSize;
	UINTN memsize = (fb_size + 4095) / 4096;
	systemtable->BootServices->AllocatePages(AllocateAnyPages, EfiLoaderData, memsize, (EFI_PHYSICAL_ADDRESS*)&vram);
	for (UINTN i = 0; i < (fb_size / sizeof(UINT32)); i++) {
        vram[i] = 0x002C3E50;
    }
	__builtin_memcpy(fb, vram, fb_size);
	while (TRUE) {
		__asm__ volatile ("cli");
		__asm__ volatile("hlt");
	}
	systemtable->BootServices->FreePages((EFI_PHYSICAL_ADDRESS)vram, memsize);
	return EFI_SUCCESS;
}