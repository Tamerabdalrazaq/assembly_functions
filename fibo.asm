.data

inMsg: .asciiz "Enter a number: "
msg: .asciiz "Calculating F(n) for n = "
fibNum: .asciiz "\nF(n) is: "
.text

main:

	li $v0, 4
	la $a0, inMsg
	syscall

	# take input from user
	li $v0, 5
	syscall
	addi $a0, $v0, 0
	
	jal print_and_run
	
	# exit
	li $v0, 10
	syscall

print_and_run:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	add $t0, $a0, $0 

	# print message
	li $v0, 4
	la $a0, msg
	syscall

	# take input and print to screen
	add $a0, $t0, $0
	li $v0, 1
	syscall

	jal fib

	addi $a1, $v0, 0
	li $v0, 4
	la $a0, fibNum
	syscall

	li $v0, 1
	addi $a0, $a1, 0
	syscall
	
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra

#################################################
#         DO NOT MODIFY ABOVE THIS LINE         #
#################################################	
#Pseudo Code -

#function fib(a0) {
#	const stack = [0, 1]
#	if (a0 <= 1) return stack[a0]
#	for (let i = 2; i <= a0; i++) {
#		const temp = stack[1]
#		stack[1] = stack[0] + stack[1]
#		stack[0] = temp
#	}
#	return stack[1]
#}

fib:
	addi $sp, $sp, -8 # Free 2 spots
	sw $zero, 0($sp) # stack[0] = 0
	sw $zero, 4($sp) # stack[1] = 0
	beq $a0, $zero, OUT #if input = 0 -> skip

	addi $t0, $zero, 1
	sw $t0, 4($sp) #stack[1] = 1
	addi $t1, $zero, 2 #t1 - loop counter


	LOOP:
		slt $t0, $a0, $t1 # $t0 = 1 <-> $t1 > $a0
		bne $t0, $zero, OUT
		
		lw $t0, 0($sp)
		lw $t2, 4($sp)
		add $t3, $t0, $t2
		sw $t2, 0($sp)
		sw $t3, 4($sp)
		
		addi $t1, $t1, 1
		j LOOP 

	OUT: 
		lw $t0, 4($sp)
		add $v0, $t0, $zero 
		addi $sp, $sp, 8
		jr $ra

