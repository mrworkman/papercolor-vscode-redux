;-----------------------------------------------------------------------------;
; File Name: boot.asm                                                         ;
; Author:    Stephen Workman                                                  ;
; Date:      July 3, 2013                                                     ;
;-----------------------------------------------------------------------------;
[BITS 16]      ; 16 bit real-mode code only

; Put this here so the linker doesn't put _DATA,CONST,_BSS sections in another
; segment. Everything should have the same "origin".
GROUP DGROUP _TEXT _DATA CONST _BSS

SECTION _TEXT CLASS=CODE

   ; This is to deal with an oddity in OPTLINK 8.00.12
   ; You're supposed to be able to use /bi:0x7c00 to change the start address
   ; of the output file, but instead it will emit the message
   ; "Below 100H Cannot Be Initialized" and the output file will be zero bytes.
   ;
   ; If you pad the start of the output file with a number of bytes equal in
   ; size to start address you want, they will be *discarded* by the linker
   ; effectively allowing you to change the start address in the output file.
   resb 0x7c00

;-----------------------------------------------------------------------------;
; Entry Point                                                                 ;
;-----------------------------------------------------------------------------;
GLOBAL _start
   ; CS needs to be set to 0 in order to get addresses that line up well with
   ; physical addresses. This will make transfer of execution after enabling
   ; protected mode easier. If I went with a CS of 0x7c0, the code could have
   ; a start address of 0000 instead of 0x7c00 but it would cause lots of
   ; headache later when trying to use a global descriptor whose base address
   ; is set to 0.
   jmp 0:_start

;-----------------------------------------------------------------------------;
; Signature                                                                   ;
;-----------------------------------------------------------------------------;
   BOOT_ID  db "IRONPXE", 0x00

;-----------------------------------------------------------------------------;
; _start                                                                      ;
;-----------------------------------------------------------------------------;
_start:

   EXTERN _bootmain

   ; Disable interrupts
   ;cli

   ; Set the data selector now so the BSS
   ; & DATA sections can be accessed now..
   mov  ax, cs
   mov  ds, ax

   ; Store some info that the BIOS/PXE provide
   mov [bootDriveNumber],   dl
   mov [pxenvPlusSeg],      es
   mov [pxenvPlusOffset],   bx
   mov [pxenvPlusStackSeg], ss
   mov [pxenvPlusStackPtr], sp

   ; Set the remaining data selectors
   ;  Redundant - calling enable_unreal will do this

   ; Set the stack segment and stack pointer. It should be ok to have SP = 0
   ; initially since the first item pushed to the stack should cause SP to wrap
   ; to 0xfffe anyway... can't use this for protected mode though!
   mov	ss, ax
   xor	sp, sp

   call  enable_unreal

   push	BOOT_INFO
   call	_bootmain
   add	sp, 2

;; Spin on it
spin:
   hlt
   jmp spin

;-----------------------------------------------------------------------------;
; Swithces the CPU to 'unreal' mode.                                          ;
; Process:                                                                    ;
;   1. Enable protected mode.                                                 ;
;   2. Load 32-bit protected-mode code segment selector.                      ;
;   3. Load 32-bit data segments into all data registers (except ss).         ;
;   4. Load 16-bit protected-mode code segment selector (*required* in order  ;
;      to return to real-mode)                                                ;
;   5. Disable protected mode.                                                ;
;   6. Jump to a real-mode code segment                                       ;
;   7. Load 16-bit real-mode data segments into all data registers.           ;
; Notes:                                                                      ;
;   - Just changing to 32-bit protected mode and back to real-mode is enough  ;
;     to enable 'unreal' mode (as long as 32-bit selectors are loaded into    ;
;     the data registers.)                                                    ;
;   - Not necessary to change the stack segment to 32-bit addressing          ;
;   - Do not need to re-load IVT/IDT since it is never changed using LIDT     ;
;     after enabling protected mode.                                          ;
;   - Do not need to disable paging since it's never enabled in te first place;
;   - Do not load 16-bit selectors while in 16-bit protected mode as you will ;
;     NOT get 32-bit addressing when returning to real-mode (duh).            ;
;-----------------------------------------------------------------------------;
EXTERN __gdt_hdr

enable_unreal:

   ; Disable interrupts
   cli

   ; Load GDT
   lgdt [__gdt_hdr]

   ; Switch to protected mode
   mov   eax, cr0
   or    eax, 1
   mov   cr0, eax

   ; Jump to 32-bit code segment
   jmp 0x08:pm32

[BITS 32]
pm32:
   ; set data segments to data selector (0x10)
   mov   ax,  0x10
   mov   ds,  ax
   mov   es,  ax
   mov   fs,  ax
   mov   gs,  ax

   ; Jump to 16-bit code segment
   jmp 0x18:pm16

[BITS 16]
pm16:
   ; Disable protected mode
   mov   eax,cr0
   and   al, 0xFE
   mov   cr0,eax

   ; Jump to real-mode segment
   jmp 0:rm16

rm16:
   ; Now in 'unreal' mode. 16-bit code with 32-bit addressing possible.
   ;  Any of the data segment registers can be changed without affecting
   ;  this functionality.

   ; Using a 'flat' memory/code model, so set all of the data segments
   ; to the same as the code segment.
   mov   ax, cs
   mov   ds, ax
   mov   es, ax
   mov   fs, ax
   mov   gs, ax

   ; Re-enable interrupts
   sti

   ; Return to caller
   ret

;-----------------------------------------------------------------------------;
;-----------------------------------------------------------------------------;
GLOBAL _transfer_execution
_transfer_execution:

   mov   bp, sp
   mov   ebx, dword [bp + 2] ; Set EBX to physical address of MBI
   mov   ecx, dword [bp + 6] ; Set ECX to physical start address of kernel

   ; Disable interrupts
   cli

   ; Load GDT
   lgdt [__gdt_hdr]

   ; Switch to protected mode
   mov   eax, cr0
   or    eax, 1
   mov   cr0, eax

   ; Jump to 32-bit code segment
   jmp 0x08:pm32x

[BITS 32]
pm32x:

   ; set data segments to data selector (0x10)
   mov   ax,  0x10
   mov   ds,  ax
   mov   es,  ax
   mov   fs,  ax
   mov   gs,  ax
   mov   ss,  ax

   ; Multiboot loader magic #
   mov   eax, 0x2BADB002

   ; Jump into the kernel
   jmp   ecx

   ; No returning!
   cli
   hlt

;
;
;
; Force the linker to put sections in the expected order.
SECTION _DATA CLASS=DATA
SECTION CONST CLASS=CONST
SECTION _BSS  CLASS=BSS

;
; A data structure to hold info provided by UNDI/PXE at boot time
ALIGN 2
BOOT_INFO:
    bootDriveNumber:        resb	1
    reserved                resb	1 ; For alignment, mainly
    pxenvPlusOffset:        resw	1
    pxenvPlusSeg:           resw 	1
    pxenvPlusStackPtr:      resw	1
    pxenvPlusStackSeg:      resw	1

;times 510-($-$$) db 0
;dw 0xAA55