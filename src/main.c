#include <efi/efi.h>
#include <efi/efidef.h>
#include <efi/efierr.h>

EFI_STATUS efi_main(EFI_HANDLE imagehandle, EFI_SYSTEM_TABLE *systemtable) {
	systemtable->ConOut->OutputString(systemtable->ConOut, L"Ready to play tic-tac-toe?");
	while (TRUE) {
		__asm__ volatile("hlt");
	}
	return EFI_SUCCESS;
}