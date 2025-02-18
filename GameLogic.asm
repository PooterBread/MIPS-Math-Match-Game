.data
match_msg:             .asciiz "\nYou found a match!\n"
no_match_msg:            .asciiz "\nNo match! Try again in 3 seconds (Time Penalty).\n"

.text
.globl set_card_result


set_card_result:
    mul $t2, $a0, 4  # Calculate byte offset for the selected card
    la $t3, state     # Load base address of the state array
    add $t3, $t3, $t2
    li $t4, 1         # Set state to 1 (temporarily revealed)
    sw $t4, 0($t3)    # Store new state
    jr $ra  # Return to caller

.globl mark_matched

mark_matched:
    # Mark card1 as matched (state = 2)
    mul $t2, $s0, 4   # Calculate byte offset for card1
    la $t3, state     # Load base address of the state array
    add $t3, $t3, $t2 # Calculate address of card1 in the state array

    # Update the state to 2 (matched)
    li $t4, 2          # Set state to 2 (matched)
    sw $t4, 0($t3)     # Store new state

    # Mark card2 as matched (state = 2)
    mul $t2, $s1, 4   # Calculate byte offset for card2
    la $t3, state     # Load base address of the state array
    add $t3, $t3, $t2 # Calculate address of card2 in the state array


    # Update the state to 2 (matched)
    li $t4, 2          # Set state to 2 (matched)
    sw $t4, 0($t3)     # Store new state

    jr $ra  # Return to caller

.globl check_match

check_match:

    mul $t2, $s0, 4           # Byte offset for first card
    la $t3, results_shuffled           # Load base address of 'results'
    add $t3, $t3, $t2          # Calculate address for first card's value
    lw $t4, 0($t3)             # Load value of the first card into $t4

    # Calculate the offset for the second card's value in 'results'
    mul $t2, $s1, 4           # Byte offset for second card
    la $t3, results_shuffled           # Load base address of 'results' again
    add $t3, $t3, $t2          # Calculate address for second card's value
    lw $t5, 0($t3)             # Load value of the second card into $t5

    # DEBUG - Prints the values of both cards for testing input saving
    #li $v0, 1
    #move $a0, $t4  # Print value of first card
    #syscall

    #li $v0, 1
    #move $a0, $t5  # Print value of second card
    #syscall

    bne $t4, $t5, no_match  # If values are not equal, go to 'no_match'

    # If the cards match, mark them as matched
    jal mark_matched

    # Print "You found a match!"
    li $v0, 4
    la $a0, match_msg
    syscall
    
    jal print_newline_loop

    j check_game_over  # Return to the game loop

no_match:
    # Print "No match! Try again in 3 seconds (Time Penalty)."
    li $v0, 4
    la $a0, no_match_msg
    syscall
    
    # Allow the user to see their wrong cards for 3 seconds before resetting (Time Penalty)
    jal no_match_delay

    # Reset both cards to hidden state
    jal reset_cards

    # Display the updated board
    jal display_board

    # Return to game loop
    j game_loop  

.globl reset_cards

reset_cards:
    # Reset the first card
    move $a0, $s0
    jal reset_card

    # Reset the second card
    move $a0, $s1
    jal reset_card

    j main  # Return to caller

.globl reset_card

reset_card:
    mul $t2, $a0, 4  # Calculate the byte offset for the card
    la $t3, state     # Load the base address of the state array
    add $t3, $t3, $t2
    li $t4, 0         # Set back state to hidden
    sw $t4, 0($t3)    # Store new state
    jr $ra  # Return to caller

.globl check_game_over

check_game_over:
    li $t0, 0  # Counter for matched cards
    la $t1, state  # Load base address of state array
    li $t2, 16  # Total number of cards

count:
    lw $t3, 0($t1)  # Load state of the current card
    

    
    beqz $t3, main
    beq $t3, 2, matched_card  

next_card:
    addi $t1, $t1, 4  # Move to the next card
    addi $t2, $t2, -1  # Decrement card counter
    
    
    beqz $t2, check_all_matched
    bnez $t2, count  
    
    
    li $v0, 0  # Not all cards matched, return 0
    jr $ra

matched_card:
    addi $t0, $t0, 1  # Increment matched card counter
    
    j next_card  # Continue loop

check_all_matched:
    li $v0, 1  # All cards matched, return 1
    j exit_game

