.data

.globl star
star:
    .asciiz " * "
    
    
.globl state
state: .word 0, 0, 0, 0  # All hidden cards represented as 0's
       .word 0, 0, 0, 0 
       .word 0, 0, 0, 0 
       .word 0, 0, 0, 0 
       
.globl results
results: 
    .word 4, 6, 8, 10    # Array of numbers to choose from
    .word 6, 9, 12, 15
    .word 8, 12, 9, 20
    .word 10, 15, 20, 4
    
.globl eq_mixed
eq_mixed:    # Array holding all displayable strings
    .word str_4, str_3x2, str_4x2, str_10
    .word str_6, str_9, str_6x2, str_5x3
    .word str_8, str_12, str_3x3, str_20
    .word str_5x2, str_15, str_4x5, str_2x2

str_4:    .asciiz " 4 "
str_3x2:  .asciiz "3x2"
str_4x2:  .asciiz "4x2"
str_10:   .asciiz "10 "
str_6:    .asciiz " 6 "
str_9:    .asciiz " 9 "
str_6x2:  .asciiz "6x2"
str_5x3:  .asciiz "5x3"
str_8:    .asciiz " 8 "
str_12:   .asciiz "12 "
str_3x3:  .asciiz "3x3"
str_20:   .asciiz "20 "
str_5x2:  .asciiz "5x2"
str_15:   .asciiz "15 "
str_4x5:  .asciiz "4x5"
str_2x2:  .asciiz "2x2"


.globl results_shuffled
results_shuffled: .space 64  # Array used to store the shuffled results

.globl results_mixed
results_mixed: .space 64  # Array used to store the shuffled displayable strings

.text
.globl shuffler
shuffler:
    # Save return address
    move $s7, $ra

    # Set random seed
    li $a0, 42
    li $v0, 40
    syscall

    # Allocate stack space for index tracking
    subi $sp, $sp, 64   # 16 * 4 bytes (4 bytes per word)

    # Initialize indices (0-15) (Array starts at 0 and ends at 15 for the grid)
    li $t3, 0           # Counter
init_loop:
    beq $t3, 16, start_shuffle
    mul $t4, $t3, 4
    add $t4, $sp, $t4
    sw $t3, 0($t4)      # Store index with correct addressing
    addi $t3, $t3, 1
    j init_loop

start_shuffle:
    # Prepare source and destination arrays
    la $t0, results
    la $t1, results_shuffled
    la $t2, eq_mixed
    la $t3, results_mixed

    li $s0, 15          # Last index
shuffle_loop:
    beqz $s0, exit_shuffle
    
    # Generate random index (0 to $s0)
    move $a1, $s0
    li $v0, 42
    syscall
    
    # Get random index from available indices
    move $t4, $a0
    mul $t7, $t4, 4
    add $t7, $sp, $t7
    lw $t5, 0($t7)      # Load index with correct addressing
    
    # Copy numeric element
    mul $t6, $t5, 4
    add $t7, $t0, $t6
    lw $t8, 0($t7)
    mul $t6, $s0, 4
    add $t7, $t1, $t6
    sw $t8, 0($t7)
    
    # Copy string element (address)
    mul $t6, $t5, 4       # Calculate offset in eq_mixed (word index)
    add $t7, $t2, $t6     # Get address of pointer in eq_mixed
    lw $t8, 0($t7)        # Load the string pointer (correctly load address)
    mul $t6, $s0, 4       # Calculate offset in results_mixed (word index)
    add $t7, $t3, $t6     # Get address in results_mixed
    sw $t8, 0($t7)        # Store the string pointer

    
    # Remove used index by overwriting
    mul $t6, $s0, 4
    add $t7, $sp, $t6
    lw $t9, 0($t7)
    mul $t6, $t4, 4
    add $t8, $sp, $t6
    sw $t9, 0($t8)
    
    subi $s0, $s0, 1
    j shuffle_loop

exit_shuffle:
    # Copy first elements
    lw $t5, 0($sp)
    
    # Numeric first element
    mul $t6, $t5, 4
    add $t7, $t0, $t6
    lw $t8, 0($t7)
    sw $t8, 0($t1)
    
    # String first element
    mul $t6, $t5, 4
    add $t7, $t2, $t6
    lw $t8, 0($t7)
    sw $t8, 0($t3)
    
    # Restore stack
    addi $sp, $sp, 64

    # Restore return address
    move $ra, $s7
    
    #j check_values # DEBUG - Uncomment to test array
    
    jr $ra
    
    
    
    
    # DEBUG - Check values within the arrays (uncomment all below)
    
    #check_values:
      # Print strings
    #li $t0, 0           # Counter
    #print_loop:
    # Calculate address
    #mul $t1, $t0, 4     # Offset calculation
    #la $t2, results_mixed
    #add $t2, $t2, $t1   # Address of current pointer
    
    # Load string address
    #lw $a0, 0($t2)      # Load string pointer
    #li $v0, 4           # Print string
    #syscall

    # Newline
    #li $a0, 10          # ASCII newline
    #li $v0, 11          # Print character
    #syscall

    # Increment and check loop condition
    #addi $t0, $t0, 1
    #blt $t0, 16, print_loop

    # Exit
    #jr $ra
