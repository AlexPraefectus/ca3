.syntax unified
.cpu cortex-m4
//.fpu softvfp
.thumb

.global bootload
.section .rodata
    image: .incbin "kernel.bin"
    end_of_image:
    str_boot_start: .asciz "bootloader started"
    str_boot_end: .asciz "bootloader end"
    str_debug_ptr: .asciz "debug"
    str_boot_indicate: .asciz "#"

.section .text
bootload:
    ldr r0, =str_boot_start
    bl dbgput_line

    ldr r0, =end_of_image
    ldr r1, =image
    ldr r2, =_ram_start

    sub r3, r0, r1 // r3 = program size
    add r2, r2, r3 // r2 = _ram_start + program size
loop:
    //ldr r3, [r1], #4
    //str r3, [r2], #4
    //cmp r0, r1

    ldrh r4, [r0]
    strh r4, [r2]
    sub r0, #2
    sub r2, #2

    cmp r0, r1
    bhi loop

    bl newline
    ldr r0, =str_boot_end
    bl dbgput_line

    ldr lr, =bootload_end
    add lr, #1
    ldr r2, =_ram_start

    add r2, #4 // go to __reset_kernel__
    ldr r0, [r2]
    bx r0

bootload_end:
    b bootload_end





