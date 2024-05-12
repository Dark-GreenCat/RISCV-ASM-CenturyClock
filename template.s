# Century Clock using RISC-V processor
# Bare-bones outline of RISC-V assembly language program

.globl _start

# constant use .equ
# ecall IDs for Led Matrix - Set Pixel
.equ LEDMATRIX_SET_PIXEL,     0x100

.data # variable declarations follow this line

.text # instructions follow this line

_start: # indicates start of code
    call function

    li a0, 10
    ecall

.globl function
function:
    li a0, LEDMATRIX_SET_PIXEL
    li a1, 0x00020004
    li a2, 0xFF0000
    ecall

    ret

# End of program, leave a blank line afterwards is preferred
