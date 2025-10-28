.data 

nl: .ascii "\n"

.text

main:
#load inital data and output 0
	li $t1, 1
	li $v0, 1
	syscall
	
	la $a0, nl
	li $v0, 4
	
	syscall
	
#output 1
	li $a0, 1
	li $v0, 1
	syscall
	
	la $a0, nl
	li $v0, 4
	
	syscall

#main loop
loop:
	add $t0, $t1, $t2
	move $t2, $t1
	move $t1, $t0
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, nl
	li $v0, 4
	
	syscall
	
	j loop


