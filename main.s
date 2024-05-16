# Century Clock using RISC-V processor

.globl _start

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

    li a0, 5
    li a1, 13
    li a2, 1
    lw a3, COLOR_DEFAULT
    call LEDMATRIX_DisplayDigit

    li a0, 7
    li a1, 13
    li a2, 12
    lw a3, COLOR_DEFAULT
    call LEDMATRIX_DisplayDigit

    # Exit program
    li a0, EXIT
    ecall



# #######################################
# ######        MAIN MODULE        ######
# #######################################
.text



# #######################################
# ######       CCLOCK MODULE       ######
# #######################################
.text



# #######################################
# ######       CLOCK MODULE        ######
# #######################################
.text



# #######################################
# ######      DISPLAY MODULE       ######
# #######################################
.text




# #######################################
# #####      LED MATRIX MODULE     ######
# #######################################
.text

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
    blt a1, x0, LEDMATRIX_DisplayRow_end

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

LEDMATRIX_DisplayRow_end:
    # Retore caller-save registers from stack
    lw ra, 0(sp)            # ra
    # Restore (callee-save) stack pointer before returning
    addi sp, sp, 24
    # Return from function
    ret


# void LEDMATRIX_DisplayDigit(uint8_t digit, uint16_t x, uint16_t y, uint32_t color)
.globl LEDMATRIX_DisplayDigit
LEDMATRIX_DisplayDigit:
    # Reserve 4 words on the stack
    addi sp, sp, -16
    # Store caller-save registers on stack
    sw ra, 0(sp)            # ra

    lb s0, FONT_HEIGHT      # s0 = height
    la s1, g_p_font_digit
    slli a0, a0, 2
    add s1, s1, a0          # s1 = g_p_font_digit + digit * 4
    lw s1, 0(s1)

0:
    ble s0, zero, LEDMATRIX_DisplayDigit_end # if s0 <= 0 then LEDMATRIX_DisplayDigit_end
    addi s0, s0, -1

    # Store caller-save registers on stack
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)

    mv a4, a3
    mv a3, a2
    mv a2, a1
    lb a1, FONT_WIDTH
    lb a0, 0(s1)

    call LEDMATRIX_DisplayRow

    # Restore caller-save registers from stack
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)

    addi s1, s1, 1
    addi a2, a2, 1
    j 0b

LEDMATRIX_DisplayDigit_end:
    # Retore caller-save registers from stack
    lw ra, 0(sp)            # ra
    # Restore (callee-save) stack pointer before returning
    addi sp, sp, 16
    # Return from function
    ret




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
COLOR_BACKGROUND:   .word 0x2F2F2F

# Define font size
FONT_WIDTH:         .byte 5
FONT_HEIGHT:        .byte 8

# Define font for digit
FONT_DIGIT_0:
    .byte 0b01110
    .byte 0b10001
    .byte 0b10011
    .byte 0b10101
    .byte 0b11001
    .byte 0b10001
    .byte 0b10001
    .byte 0b01110
FONT_DIGIT_1:
    .byte 0b00100
    .byte 0b01100
    .byte 0b10100
    .byte 0b00100
    .byte 0b00100
    .byte 0b00100
    .byte 0b00100
    .byte 0b11111
FONT_DIGIT_2:
    .byte 0b01110
    .byte 0b10001
    .byte 0b00001
    .byte 0b00010
    .byte 0b00100
    .byte 0b01000
    .byte 0b10000
    .byte 0b11111
FONT_DIGIT_3:
    .byte 0b01110
    .byte 0b10001
    .byte 0b00001
    .byte 0b00110
    .byte 0b00001
    .byte 0b00001
    .byte 0b10001
    .byte 0b01110
FONT_DIGIT_4:
    .byte 0b10001
    .byte 0b10001
    .byte 0b10001
    .byte 0b11111
    .byte 0b00001
    .byte 0b00001
    .byte 0b00001
    .byte 0b00001
FONT_DIGIT_5:
    .byte 0b11111
    .byte 0b10000
    .byte 0b10000
    .byte 0b11110
    .byte 0b00001
    .byte 0b00001
    .byte 0b00001
    .byte 0b11110
FONT_DIGIT_6:
    .byte 0b01111
    .byte 0b10000
    .byte 0b10000
    .byte 0b11111
    .byte 0b10001
    .byte 0b10001
    .byte 0b10001
    .byte 0b01110
FONT_DIGIT_7:
    .byte 0b11111
    .byte 0b00001
    .byte 0b00001
    .byte 0b00010
    .byte 0b00100
    .byte 0b00100
    .byte 0b00100
    .byte 0b00100
FONT_DIGIT_8:
    .byte 0b01110
    .byte 0b10001
    .byte 0b10001
    .byte 0b01110
    .byte 0b10001
    .byte 0b10001
    .byte 0b10001
    .byte 0b01110
FONT_DIGIT_9:
    .byte 0b01110
    .byte 0b10001
    .byte 0b10001
    .byte 0b11111
    .byte 0b00001
    .byte 0b00001
    .byte 0b10001
    .byte 0b01110


# #######################################
# ######      GLOBAL VARIABLE     #######
# #######################################
.data

# Define font array
g_p_font_digit:
    .word FONT_DIGIT_0
    .word FONT_DIGIT_1
    .word FONT_DIGIT_2
    .word FONT_DIGIT_3
    .word FONT_DIGIT_4
    .word FONT_DIGIT_5
    .word FONT_DIGIT_6
    .word FONT_DIGIT_7
    .word FONT_DIGIT_8
    .word FONT_DIGIT_9

# End of program, leave a blank line afterwards is preferred
