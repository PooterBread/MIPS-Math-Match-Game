.data
invalid_input_msg: .asciiz "\nInvalid input! Enter a card number between 1 and 16:\n"
invalid_state_msg: .asciiz "\nThis card has already been revealed or matched. Choose another card.\n"

.text
.globl validate_input

validate_input:
validate_loop:
    li $v0, 5                  # Read an integer input from the user
    syscall
    
    move $t0, $v0 	       # Store user input
    sub $t0, $t0, 1            # Subtract 1 to user input (1-16)

    # Check if input is in valid range (1-16)
    blt $t0, -1, invalid_input
    bge $t0, 16, invalid_input
   

    # Check the state of the selected card
    mul $t1, $t0, 4            # Calculate byte offset for the card
    la $t2, state              # Load base address of the state array
    add $t2, $t2, $t1          # Add offset to the state address
    lw $t3, 0($t2)             # Load the state of the card

    # Block already revealed (1) or matched (2) cards
    bnez $t3, invalid_state

    move $v0, $t0              # Valid input, return it
    jr $ra                     # Return to the caller

invalid_input:
    li $v0, 4  # Print "Invalid input! Enter a card number between 1 and 16."
    la $a0, invalid_input_msg
    syscall
    j validate_loop  # Retry input

invalid_state:
    li $v0, 4  # Print "This card has already been revealed or matched. Choose another card."
    la $a0, invalid_state_msg
    syscall
    j validate_loop  # Retry input

