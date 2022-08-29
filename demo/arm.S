    .section    __TEXT,__text,regular,pure_instructions
    .build_version macos, 12, 0 sdk_version 12, 3
    .globl  _main                           ; -- Begin function main
    .p2align    2
_main:                                  ; @main
    .cfi_startproc
; %bb.0:
    sub     sp, sp, #48
    stp     x29, x30, [sp, #32]             ; 16-byte Folded Spill
    add     x29, sp, #32
    .cfi_def_cfa w29, 16
    .cfi_offset  w30, -8
    .cfi_offset  w29, -16
    stur    wzr, [x29, #-4]
    stur    w0, [x29, #-8]
    str     x1, [sp, #16]
    adrp    x9, _x@PAGE
    ldr     w8, [x9, _x@PAGEOFF]
    ldr     w9, [x9, _x@PAGEOFF]
    subs    w8, w8, w9
    str     w8, [sp, #12]
    ldur    w8, [x29, #-8]
    subs    w8, w8, #1
    b.ge    LBB0_2
    b       LBB0_1
LBB0_1:
    adrp    x0, l_.str@PAGE
    add     x0, x0, l_.str@PAGEOFF
    bl      _printf
    mov     w8, #1
    stur    w8, [x29, #-4]
    b       LBB0_3
LBB0_2:
    stur    wzr, [x29, #-4]
    b       LBB0_3
LBB0_3:
    ldur    w0, [x29, #-4]
    ldp     x29, x30, [sp, #32]             ; 16-byte Folded Reload
    add     sp, sp, #48
    ret
    .cfi_endproc
                                        ; -- End function
    .section    __DATA,__data
    .globl  _x                              ; @x
    .p2align    2
_x:
    .long   4                               ; 0x4

    .section    __TEXT,__const
    .globl  _XX                             ; @XX
    .p2align    2
_XX:
    .long   0                               ; 0x0

    .section    __DATA,__data
    .globl  _c                              ; @c
_c:
    .byte   48                              ; 0x30

    .section    __TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
    .asciz  "Expected at least one argument!\n"

.subsections_via_symbols
