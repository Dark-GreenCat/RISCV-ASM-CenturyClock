# Century Clock using RISC-V processor

.globl _start

# #######################################
# #########      CONSTANT      ##########
# #######################################

# Define ecall IDs
.equ    EXIT, 10


# #######################################
# ########      ENTRY POINT     #########
# #######################################
.text

# Start of code (entry point). Must be put in the beginning
_start:

    # Exit program
    li a0, EXIT
    ecall

# End of program, leave a blank line afterwards is preferred
