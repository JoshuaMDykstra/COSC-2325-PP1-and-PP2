.data
	num: .space 64
	base: .space 4
	numSize: .space 4
	output: .space 4
	
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
	
	sw $t2, numSize #store size of string
	
	
	
#processing
	li $t0, 0 #workspace
	li $t2, 0 #counter
	la $t3, num #input pointer
	lw $t4, base #base value
	lw $t5, numSize #size value
	li $t6, 0 #output
	
	add $t3, $t3, $t5 #set pointer to end of string
	subi $t3, $t3, 1 
	
	processingLoop:
		lw $t1, base #set $t1 to base
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

#output
	li $v0, 4 #skip a line
	la $a0, nl
	syscall 

	la $a0, resultOut #print numout msg
	syscall
	
	li $v0, 1 #print output
	move $a0, $t6
	syscall
	
	li $v0, 10
	syscall