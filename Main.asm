.data
time:        .word   0
minutes:       .asciiz " minute(s) and "
seconds:       .asciiz " second(s). "
time_msg:    .asciiz "\nYou finished in "
win_msg:     .asciiz "\nGreat Job! You found all the matches!\n"
enter_card_msg: .asciiz "\nEnter a card number (1-16): "

.text
.globl main
.globl game_loop 

shuffle_cells:
    jal shuffler # Initially Shuffles the board 
    
start_timer:
    li $v0, 30         # Get system time
    syscall
    move $s6, $a0      # Store start time in $s6

main:
    # Syscall for printing a character
    syscall  
    
    # Display the initial board before any input
    jal display_board
game_loop:
    # Clear previous selections
    move $s0, $zero  # Clear first card index
    move $s1, $zero  # Clear second card index

    # Get input for the first card
    jal prompt_input  # Display prompt before input
    jal validate_input
   
    
    move $s0, $v0  # Store first card index

    # Print a new line
    li $a0, '\n'   # can also use '10' for new line 
    li $v0, 11
    syscall

    # Reveal the first card
    move $a0, $s0
    jal set_card_result         
    jal display_board  # Display board after first card reveal


select_second_card:
    # Get input for the second card
    
    jal prompt_input  # Display prompt before input
    jal validate_input 
          
    move $s1, $v0  # Store second card index
    

    # Ensure the two selected cards are different
    beq $s0, $s1, select_second_card  # Retry if same card is selected

    # Print a new line
    li $a0, 10
    li $v0, 11
    syscall

    # Reveal the second card
    move $a0, $s1
    jal set_card_result         
    jal display_board  # Display board after second card reveal
    
    # Check if the two cards match
    jal check_match
    
    # Check if the game is over
    jal check_game_over         
    bnez $v0, exit_game            

    # Continue to the next round
    j game_loop                 

.globl exit_game

exit_game:
    # Print "Great Job! You found all the matches!"
    li $v0, 4
    la $a0, win_msg
    syscall
    
    stop_timer:
    li $v0, 30         # Get system time again
    syscall
    
    # Calculate elapsed time in milliseconds
    sub $t0, $a0, $s6  # Current time - start time = elapsed time
    sw $t0, time       # Store total elapsed time
    
    # Convert milliseconds to seconds
    li $t1, 1000       # 1000 milliseconds = 1 second
    div $t0, $t1       # Divide elapsed time by 1000
    mflo $t2           # $t2 = total seconds
    mfhi $t4           # $t4 = remaining milliseconds (not used)
    
    # Calculate minutes and remaining seconds
    li $t1, 60         # 60 seconds = 1 minute
    div $t2, $t1       # Divide total seconds by 60
    mflo $t3           # $t3 = minutes
    mfhi $t4           # $t4 = remaining seconds
    
    # Print time message
    li $v0, 4          # Syscall 4: print string
    la $a0, time_msg
    syscall
    
    # Print minutes
    li $v0, 1          # Syscall 1: print integer
    move $a0, $t3
    syscall
    
    # Print minutes (format)
    li $v0, 4
    la $a0, minutes
    syscall
    
    # Print seconds (with leading zero if less than 10)
    li $v0, 1
    move $a0, $t4
    syscall
    
    # Print seconds (format)
    li $v0, 4
    la $a0, seconds
    syscall
    
    # Exit the program
    li $v0, 10
    syscall

# Function to display the prompt for card input
prompt_input:
    li $v0, 4
    la $a0, enter_card_msg
    syscall
    jr $ra  # Return from the function
    
.globl no_match_delay
.globl print_newline_loop

no_match_delay:
    li $a0, 3000
    li $v0, 32
    
    syscall
    
    li $t0, 0           # Initialize counter ($t0 = 0)
    li $t1, 10           # Set the limit to 10

    print_newline_loop:
    li $a0, 10          # ASCII value for newline ('\n')
    li $v0, 11          # Syscall for print character
    syscall             # Print newline

    addi $t0, $t0, 1    # Increment counter
    blt $t0, $t1, print_newline_loop  # Repeat loop if $t0 < $t1
    
    jr $ra
