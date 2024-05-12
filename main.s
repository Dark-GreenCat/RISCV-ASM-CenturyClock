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
COLOR_DEFAULT: .word 0xFFFF00


# #######################################
# ########      ENTRY POINT     #########
# #######################################
.text

# Start of code (entry point). Must be put in the beginning
_start:

    # Set pixel at (2, 4) with default color
    li a0, 2
    li a1, 4
    la t0, COLOR_DEFAULT
    lw a2, 0(t0)
    call LEDMATRIX_DisplayPixel

    # Exit program
    li a0, EXIT
    ecall

# void LEDMATRIX_DisplayPixel(uint32_t x, uint32_t y, uint32_t color)
.globl LEDMATRIX_DisplayPixel
LEDMATRIX_DisplayPixel:
    # Prepare data
    slli a0, a0, 16         # x = x << 16
    or   a1, a0, a1         # y = x | y

    # Display pixel to Led Matrix
    li a0, LEDMATRIX_SET_PIXEL
    ecall

    # Return from function
    jr ra


# End of program, leave a blank line afterwards is preferred
