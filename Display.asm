.data
formatting:    .asciiz " || "
beginning_formatting: .asciiz "\n |+-----++-----++-----++-----+| \n"

.text
.globl display_board

display_board:
    la $a0, beginning_formatting
    li $v0, 4
    syscall
    
    la $a0, formatting
    li $v0, 4
    syscall
    
    li $t9, 0
    
    li $t0, 0  # Row counter

print_loop:
    li $t1, 0  # Column counter

column_loop:
    mul $t2, $t0, 4
    add $t2, $t2, $t1
    mul $t2, $t2, 4

    la $t3, state
    add $t3, $t3, $t2
    lw $t4, 0($t3)
    
    bnez $t4, show_selected
    
    la $t5, star
    li $v0, 4
    move $a0, $t5
    syscall

    beqz $t4, print_hidden 	# DEBUG - Comment out to view all numbers in grid to check shuffle 
    
    show_selected:
    
    la $t5, results_mixed
    add $t5, $t5, $t2
    
   
    lw $a0, 0($t5)
    li $v0, 4
    syscall
    
    # DEBUG - Test to see if results_mixed can be printed
    #la $t0, results_mixed
    #add $t0, $t0, $t2
    #lw $a0, 0($t0)      # Load the string address
    
    # Print the string
    #li $v0, 4           # Syscall for print string
    #syscall
    
    la $a0, formatting
    li $v0, 4
    syscall
    
    j next_column

print_hidden:
    la $a0, formatting
    li $v0, 4
    syscall

next_column:
    addi $t1, $t1, 1
    blt $t1, 4, column_loop
    
    
    la $a0, beginning_formatting
    li $v0, 4
    syscall
   
    j check_formatting
   
   
    next_column_exit:
    
        addi $t0, $t0, 1
        blt $t0, 4, print_loop
        jr $ra

check_formatting:
    # Check if i < 3
    li $t8, 3       # Load 3 into $t1
    bge $t9, $t8, next_column_exit  # If i >= 4, exit the loop

    # Print formatting
    la $a0, formatting  # Load the address of the string into $a0
    li $v0, 4        # Syscall code for print_string
    syscall

    # Increment i (i++)
    addi $t9, $t9, 1 # $t0 = $t0 + 1

    # Jump back to the loop
    j next_column_exit
