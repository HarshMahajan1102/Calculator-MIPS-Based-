.data
welcomeMsg: .asciiz "Welcome to MIPS-Based Calculator\n\n"

newline: .asciiz "\n"
separator: .asciiz "-----------------------------------------------------------\n"

menuInt: .asciiz "Enter Operator for performing corresponding operation for integers:\n\n+ [Addition] \n- [Subtraction] \n* [Multiplication] \n/ [Division] \n^ [Exponential] \n% [Modulus] \n! [Factorial] \nm [Number Type Menu] \nq [Quit] \n"
menuGeneralInt: .asciiz "Enter Operator for next calculation for integer type number.\n"
menuGeneralFloat: .asciiz "Enter Operator for next calculation for floating type number.\n"
menuNumber: .asciiz "On which of the following do you want to perform operations.\ni [Integers]\nf [Floating Numbers]\n\n"
menuFloat: .asciiz "Enter Operator for performing corresponding operation for floating number:\n\n+ [Addition] \n- [Subtraction] \n* [Multiplication] \n/ [Division] \nm [Number Type Menu] \nq [Quit]\n"

arg : .asciiz "Enter the argument.\n"
arg1: .asciiz "Enter the first argument.\n"
arg2: .asciiz "Enter the second argument.\n"

arg1Exp: .asciiz "Enter the base.\n"
arg2Exp: .asciiz "Enter the exponent.\n"

sum: .asciiz "The sum is "
difference: .asciiz "The difference is "
product: .asciiz "The product is "
quotient: .asciiz "The quotient is "
result: .asciiz "The result is "

wrongOperator: .asciiz "You have entered wrong character. Please choose appropriate operator.\n"
notdefined: .asciiz "Division by zero is not defined, please re-enter both the arguments again!\n"
largeExpError: .asciiz "Exponent too large. Please re-enter both arguments with smaller exponent(<= 15).\n"
largeFactError: .asciiz "Factorial too large. Please enter a number less than or equal to 12.\n"
negativeInput: .asciiz "You can't put negative integer as argument for factorial.\n"
quitMsg: .asciiz "You have successfully exited the calculator.\n"

.text
main:
	li $v0, 4
	la $a0, welcomeMsg
	syscall
	jal separatorPrint

	j menuNumberType

menuNumberType:
	jal separatorPrint
	jal newlinePrint
	li $v0, 4
	la $a0, menuNumber
	syscall

	li $v0, 12
	syscall
	move $t5, $v0
	jal newlinePrint
	jal newlinePrint
	jal separatorPrint

	beq $t5, 'i', handleInt
	beq $t5, 'f', handleFloat
	beq $t5, 'q', quit

	li $v0, 4
	jal separatorPrint
	jal newlinePrint
	la $a0, wrongOperator
	syscall

	jal newlinePrint
	j menuNumberType

handleInt:
	jal newlinePrint
	li $v0, 4
	la $a0, menuInt
	syscall 
	jal newlinePrint
	jal separatorPrint

  j intCheckOperation

handleFloat:
	# jal newlinePrint
	jal newlinePrint
	li $v0, 4
	la $a0, menuFloat
	syscall
	jal newlinePrint
	jal separatorPrint

  j floatCheckOperation

intOperatorInputGeneral:
	jal newlinePrint
	li $v0, 4
	la $a0, menuGeneralInt
	syscall

	j intCheckOperation

floatOperatorInputGeneral:
	jal newlinePrint
	li $v0, 4
	la $a0, menuGeneralFloat
	syscall

	j floatCheckOperation

newlinePrint:
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

separatorPrint:
	li $v0, 4
	la $a0, separator
	syscall
	jr $ra

intCheckOperation:
	jal newlinePrint

	li $v0, 12
	syscall
	move $t0, $v0
	jal newlinePrint

	beq $t0, '+', addition
	beq $t0, '-', subtraction
	beq $t0, '*', multiplication
	beq $t0, '/', division
	beq $t0, '^', exponentiation
	beq $t0, '%', modulation
	beq $t0, '!', factorial
	beq $t0, 'm', menuNumberType
	beq $t0, 'q', quit

	li $v0, 4
	la $a0, wrongOperator
	syscall

	j intOperatorInputGeneral

floatCheckOperation:
  jal newlinePrint

	li $v0, 12
	syscall
	move $t0, $v0
  jal newlinePrint

	beq $t0, '+', float_add
	beq $t0, '-', float_sub
	beq $t0, '*', float_mul
	beq $t0, '/', float_div
 	beq $t0, 'm', menuNumberType
	beq $t0, 'q', quit

	li $v0, 4
	la $a0, wrongOperator
	syscall

	j floatOperatorInputGeneral

intArgInput:
	li $v0, 4
	la $a0, arg1
	syscall
	li $v0, 5
	syscall
	move $t1, $v0

	li $v0, 4
	la $a0, arg2
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0
	
	jr $ra

floatArgInput:
	li $v0, 4
	la $a0, arg1
	syscall
	li $v0, 6
	syscall
	mov.s $f1, $f0

	li $v0, 4
	la $a0, arg2
	syscall
	
	li $v0, 6
	syscall
	mov.s $f2, $f0

	jr $ra

addition:
	jal intArgInput
	add $t3, $t1, $t2
	
	li $v0, 4
	la $a0, sum
	syscall

	li $v0, 1
	move $a0, $t3
	syscall

	jal newlinePrint
	jal newlinePrint
	jal separatorPrint
	j intOperatorInputGeneral

subtraction:
	jal intArgInput
	sub $t3, $t1, $t2

	li $v0, 4
	la $a0, difference
	syscall

	li $v0, 1
	move $a0, $t3
	syscall

	jal newlinePrint
	jal newlinePrint
	jal separatorPrint
	j intOperatorInputGeneral

multiplication:
	jal intArgInput
	mul $t3, $t1, $t2

	li $v0, 4
	la $a0, product
	syscall

	li $v0, 1
	move $a0, $t3
	syscall

	jal newlinePrint
	jal newlinePrint
	jal separatorPrint
	j intOperatorInputGeneral

division:
	jal intArgInput
	beq $t2, $zero, handleDivError
	div $t1, $t2
	mflo $t3

	li $v0, 4
	la $a0, quotient
	syscall

	li $v0, 1
	move $a0, $t3
	syscall

	jal newlinePrint
	jal newlinePrint
	jal separatorPrint
	j intOperatorInputGeneral

modulation:
	jal intArgInput
	beq $t2, $zero, handleModError
	div $t1, $t2
	mfhi $t3

	li $v0, 4
	la $a0, result
	syscall

	li $v0, 1
	move $a0, $t3
	syscall

	jal newlinePrint
	jal separatorPrint
	j intOperatorInputGeneral

handleDivError:
	li $v0, 4
	la $a0, notdefined
	syscall

	jal newlinePrint
	j division

handleModError:
	li $v0, 4
	la $a0, notdefined
	syscall

	jal newlinePrint
	j modulation

exponentiation:
	jal intArgInput

	li $t5, 15        
	bgt $t2, $t5, handleTooLargeExp

	li $t3, 1
	li $t4, 0

	exp_loop:
		mul $t3, $t3, $t1
		addi $t4, $t4, 1
		blt $t4, $t2, exp_loop

	exp_end:
		li $v0, 4
		la $a0, result
		syscall

		li $v0, 1
		move $a0, $t3
		syscall

		jal newlinePrint
		jal separatorPrint
		j intOperatorInputGeneral

factorial:
	li $v0, 4
	la $a0, arg
	syscall

	li $v0, 5
	syscall

	move $t1, $v0
	bltz $t1, handleNegative

	li $t4, 12
	bgt $t1, $t4, handleTooLargeFact

	li $t2, 1
	li $t3, 1
	addi $t1, $t1, 1

	fact_loop:
		mul $t3, $t3, $t2
		addi $t2, $t2, 1
		blt $t2, $t1, fact_loop

	fact_end:
		li $v0, 4
		la $a0, result
		syscall

		li $v0, 1
		move $a0, $t3
		syscall

		jal newlinePrint
		jal separatorPrint
		j intOperatorInputGeneral

handleTooLargeExp:
    li $v0, 4
    la $a0, largeExpError   
    syscall
    
		jal newlinePrint
		jal separatorPrint
		jal newlinePrint

    j exponentiation

handleTooLargeFact:
    li $v0, 4
    la $a0, largeFactError  
    syscall
    
		jal newlinePrint
		jal separatorPrint
		jal newlinePrint

    j factorial

handleNegative:
    li $v0, 4
    la $a0, negativeInput
    syscall
    
		jal newlinePrint
    j intOperatorInputGeneral

float_add:
	jal newlinePrint
	jal floatArgInput
	add.s $f12, $f1, $f2

	
	li $v0, 4
	la $a0, sum
	syscall

	li $v0, 2
	syscall

	jal newlinePrint
	jal newlinePrint
	jal separatorPrint
	j floatOperatorInputGeneral

float_sub:
	jal newlinePrint
	jal floatArgInput
	sub.s $f12, $f1, $f2

	li $v0, 4
	la $a0, difference
	syscall

	li $v0, 2
	syscall

	jal newlinePrint
	jal newlinePrint
	jal newlinePrint
	jal separatorPrint
	j floatOperatorInputGeneral

float_mul:
	jal newlinePrint
	jal floatArgInput
	mul.s $f12, $f1, $f2

	li $v0, 4
	la $a0, product
	syscall

	li $v0, 2
	syscall

	jal newlinePrint
	jal newlinePrint
	jal separatorPrint
	j floatOperatorInputGeneral

float_div:
	jal newlinePrint
	jal floatArgInput
	li.s $f10, 0.0
	c.eq.s $f2, $f10
	bc1t handleFloatDivError
	div.s $f12, $f1, $f2

	li $v0, 4
	la $a0, quotient
	syscall

	li $v0, 2
	syscall

	jal newlinePrint
	jal newlinePrint
	jal separatorPrint
	j floatOperatorInputGeneral

handleFloatDivError:
    li $v0, 4
    la $a0, notdefined
    syscall

    jal newlinePrint
    j float_div  

quit:
	li $v0, 4
	la $a0, quitMsg
	syscall
	
	jal separatorPrint
	li $v0, 10
	syscall