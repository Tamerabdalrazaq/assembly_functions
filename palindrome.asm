# check if user provided string is palindrome

.data

userInput: .space 64
stringAsArray: .space 256

welcomeMsg: .asciiz "Enter a string: "
calcLengthMsg: .asciiz "Calculated length: "
newline: .asciiz "\n"
yes: .asciiz "The input is a palindrome!"
no: .asciiz "The input is not a palindrome!"
notEqualMsg: .asciiz "Outputs for loop and recursive versions are not equal"

.text

main:

	li $v0, 4
	la $a0, welcomeMsg
	syscall
	la $a0, userInput
	li $a1, 64
	li $v0, 8
	syscall

	li $v0, 4
	la $a0, userInput
	syscall
	
	# convert the string to array format
	la $a1, stringAsArray
	jal string_to_array
	
	addi $a0, $a1, 0
	
	# calculate string length
	jal get_length
	addi $a1, $v0, 0
	
	li $v0, 4
	la $a0, calcLengthMsg
	syscall
	
	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $t0, $zero, 0
	addi $t1, $zero, 0
	la $a0, stringAsArray
	
	# Swap a0 and a1
	addi $t0, $a0, 0
	addi $a0, $a1, 0
	addi $a1, $t0, 0
	addi $t0, $zero, 0
	
	# Function call arguments are caller saved
	addi $sp, $sp, -8
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	
	# check if palindrome with loop
	jal is_pali_loop
	
	# Restore function call arguments
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 8
	
	addi $s0, $v0, 0
	
	# check if palindrome with recursive calls
	jal is_pali_recursive
	bne $v0, $s0, not_equal
	
	beq $v0, 0, not_palindrome

	li $v0, 4
	la $a0, yes
	syscall
	j end_program

	not_palindrome:
		li $v0, 4
		la $a0, no
		syscall
		j end_program
	
	not_equal:
		li $v0, 4
		la $a0, notEqualMsg
		syscall
		
	end_program:
	li $v0, 10
	syscall
	
string_to_array:	
	add $t0, $a0, $zero
	add $t1, $a1, $zero
	addi $t2, $a0, 64

	
	to_arr_loop:
		lb $t4, ($t0)
		sw $t4, ($t1)
		
		addi $t0, $t0, 1
		addi $t1, $t1, 4
	
		bne $t0, $t2, to_arr_loop
		
	jr $ra


#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################
	
get_length:
	lb $t0, newline
	add $t1, $zero, $zero # Init $t1 to be a counter

	LOOP:
		sll $t2, $t1, 2 # $t2 = 4 * $t1
		add $t2, $a0, $t2
		lw $t3, 0($t2) #load the $t1-th word to $t3
		beq $t3, $t0, OUT
		addi $t1, $t1, 1
		j LOOP

	OUT:
		add $v0, $t1, $zero
		jr $ra
	
is_pali_loop:
	addi $v0, $zero, 1 #Default return value: 1 
	beq $a0, $zero, EXIT

	add $t0, $a1, $zero # Init $t0: Left Pointer
	sll $t2, $a0, 2 # $t2 = 4 * $a0
	addi $t2, $t2, -4
	add $t1, $a1, $t2 # Init $t1: Right Pointer ( $t1 = $a0 + 4*len)

	LOOP2:
		lw $t2, 0($t0) #load left pointer word
		lw $t3, 0($t1) #load left pointer word
		bne $t2, $t3, REJECT
		addi $t0, $t0, 4 # Left pointer += 1
		addi $t1, $t1, -4 # Right pointer -= 1
		slt $t3, $t1, $t0 # $t3 == 0 <-> $t1 >= $t0 
		beq $t3, $zero, LOOP2
		j EXIT

	REJECT: 
		add $v0, $zero, $zero
	EXIT: 
		jr $ra
	
is_pali_recursive:
	addi $v0, $zero, 1 #Default return value: 1
	beq $a0, $zero, EXIT_REC

	add $t0, $a1, $zero # Init $t0: Left Pointer
	sll $t2, $a0, 2 # $t2 = 4 * $a0
	addi $t2, $t2, -4
	add $t1, $a1, $t2 # Init $t1: Right Pointer ( $t1 = $a0 + 4*(len-1))

	slt $t3, $t1, $t0 # $t3 == 0 <-> $t1 >= $t0 
	beq $t3, $v0, EXIT_REC
	lw $t2, 0($t0) #load left pointer word
	lw $t3, 0($t1) #load left pointer word
	bne $t2, $t3, REJECT_REC
	REC: 
		addi $a0, $a0, -2 
		addi $a1, $a1, 4 # Procede recursively the next char
		j is_pali_recursive

	REJECT_REC: 
		add $v0, $zero, $zero
	EXIT_REC: 
		jr $ra
