.syntax unified
.cpu cortex-m4
.thumb
#define A #4
#define B #6
#define C #5

// Global memory locations.
.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line

    // calculate
    //   (a + b)/2 + c!
    mov r0, A
    mov r1, B
    mov r2, C
    add r0, r0, r1 // r0 = a + b
    asr r0, r0, #1 // r0 = (a + b) / 2
    // r2 = c!
    cmp r2, #0
    it eq
    moveq r2, #1
    cmp r2, #1
    beq factorial_end
    // not executed for c in (0, 1)
    mov r3, r2   // r3 = c
loop_factor:
    sub r3, r3, #1   // r3 -= 1
    mul r2, r2, r3   // r2 = r2 * r3
    cmp r3, #1
    bne loop_factor
factorial_end:
    add r0, r0, r2
    bl dbgput_num

end:
    b end
