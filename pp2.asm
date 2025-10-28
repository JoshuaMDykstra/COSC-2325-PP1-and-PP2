.data
	num: .space 64 #26850-0992
	base: .space 4 #26850-1056
	
	numPrompt: .asciiz "Enter Number: "
	basePrompt: .asciiz "Enter Base: "
	
	resultOut: .asciiz "Your number in base 10 is: "
	
	nl: .asciiz "\n"

.text

#input
	li $v0, 4 #print prompt for number
	la $a0, numPrompt
	syscall
	
	li $v0, 8 #read string - 64 bytes
	la $a0, num
	li $a1, 64
	syscall
	
	li $v0, 4 #print prompt for base
	la $a0, basePrompt
	syscall
	
	li $v0, 5 #read int
	syscall
	sw $v0, base
	
#preprocessing
	li $t2, 0 #counter
	la $t3, num #num pointer
	
	findLength:
		lb $t0, 0($t3) #loads byte from string
		
		beq $t0, '\n', endFindLength #break if byte is \n
		
		addi $t2, $t2, 1 #incriment counter
		addi $t3, $t3, 1 #incrimend pointer
		j findLength
		
	endFindLength:
	
	addi $sp, $sp, -4
	sw $t2, 0($sp) #push size of string to stack
	
	
	lw $t0, base
	addi $sp, $sp, -4
	sw $t0, 0($sp) #push base value
	
	la $t0, num
	addi $sp, $sp, -4
	sw $t0, 0($sp) #push address of input
	
	
#processing function call	
	jal processing
	
	
#output
	li $v0, 4 #skip a line
	la $a0, nl
	syscall 

	la $a0, resultOut #print numout msg
	syscall
	
	li $v0, 1 #print output
	lw $a0, 0($sp)
	syscall
	
	li $v0, 10
	syscall
	
#processing function
processing:
	li $t0, 0 #workspace
	li $t2, 0 #counter
	li $t6, 0 #output
	
	lw $t3, 0($sp) #pop input pointer
	addi $sp, $sp, 4
	
	lw $t4, 0($sp) #pop base value from stack
	addi $sp, $sp, 4
	
	lw $t5, 0($sp) #pop size value
	addi $sp, $sp, 4
	
	
	add $t3, $t3, $t5 #set pointer to end of string
	subi $t3, $t3, 1 
	
	processingLoop:
		move $t1, $t4 #set $t1 to base
		lb $t0, 0($t3) #load byte from num
		
		beq $t2, $t5, endProcessingLoop #break if counter == size
		
		subi $t0, $t0, 48 #convert char to int
		
		li $t7, 0 #exponent counter
		raiseBase:
			beq $t7, $t2 endRaiseBase #break if exponent counter == counter
			
			mul $t1, $t1, $t4 #multiply by base
			
			addi $t7 $t7, 1 #incriment exponent counter
			
			j raiseBase
			
		endRaiseBase:
		
		mul $t0, $t0, $t1 #multiply loaded int by raised base
		add $t6, $t6, $t0 #add result to output
		
		addi $t2, $t2, 1 #increment counter
		subi $t3, $t3, 1 #decriment pointer
		
		j processingLoop #loop

	endProcessingLoop:
	
	div $t6, $t6, $t4 #divide result by base (couldn't tell you why, pretty sure my exponenet function doesn't quite work)
	
	sw $t6, 0($sp) #push result to stack
		
	jr $ra
end: