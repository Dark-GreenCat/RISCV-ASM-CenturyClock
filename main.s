# Century Clock using RISC-V processor

.globl _start

# #######################################
# #########      CONSTANT      ##########
# #######################################

# Define ecall IDs
.equ    EXIT, 10
.equ    LEDMATRIX_SET_PIXEL, 0x100

# #######################################
# #####      CONSTANT VARIABLE     ######
# #######################################
.data

# Define color
COLOR_DEFAULT:      .word 0xFFFF00
COLOR_BACKGROUND:   .word 0x8F8F8F


# #######################################
# ########      ENTRY POINT     #########
# #######################################
.text

# Start of code (entry point). Must be put in the beginning
_start:

    # Set pixel at (2, 4) with default color
    li a0, 2
    li a1, 4
    lw a2, COLOR_DEFAULT
    call LEDMATRIX_DisplayPixel

    li a0, 0b11101011
    li a1, 8
    li a2, 1
    li a3, 9
    lw a4, COLOR_DEFAULT
    call LEDMATRIX_DisplayRow

    # Exit program
    li a0, EXIT
    ecall

# void LEDMATRIX_DisplayPixel(uint16_t x, uint16_t y, uint32_t color)
.globl LEDMATRIX_DisplayPixel
LEDMATRIX_DisplayPixel:
    # Prepare data
    slli a0, a0, 16         # x = x << 16
    or   a1, a0, a1         # y = x | y

    # Display pixel to Led Matrix
    li a0, LEDMATRIX_SET_PIXEL
    ecall

    # Return from function
    ret

# void LEDMATRIX_DisplayRow(uint16_t row, uint16_t width, uint16_t x, uint16_t y, uint32_t color)
.globl LEDMATRIX_DisplayRow
LEDMATRIX_DisplayRow:
    # Reserve 6 words on the stack
    addi sp, sp, -24
    # Store caller-save registers on stack
    sw ra, 0(sp)            # ra

0:  
    addi a1, a1, -1
    blt a1, x0, end

    # Store caller-save registers on stack
    sw a0, 4(sp)            # row
    sw a1, 8(sp)            # width
    sw a2, 12(sp)           # x
    sw a3, 16(sp)           # y
    sw a4, 20(sp)           # color

    li t0, 0x1
    sll t0, t0, a1
    and t0, a0, t0

    mv a0, a2
    mv a1, a3
    bnez t0, LEDMATRIX_DisplayRow_else

LEDMATRIX_DisplayRow_if:
    la a2, COLOR_BACKGROUND
    lw a2, 0(a2)
    j LEDMATRIX_DisplayRow_endif
LEDMATRIX_DisplayRow_else:
    mv a2, a4
LEDMATRIX_DisplayRow_endif:
    call LEDMATRIX_DisplayPixel

    # Restore caller-save registers from stack
    lw a0, 4(sp)            # row
    lw a1, 8(sp)            # width
    lw a2, 12(sp)           # x
    lw a3, 16(sp)           # y
    lw a4, 20(sp)           # color

    addi a2, a2, 1
    j 0b

end:
    # Retore caller-save registers from stack
    lw ra, 0(sp)            # ra
    # Restore (callee-save) stack pointer before returning
    addi sp, sp, 24
    # Return from function
    ret

# End of program, leave a blank line afterwards is preferred
