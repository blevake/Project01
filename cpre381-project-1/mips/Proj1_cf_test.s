.text
.globl main
main:
    li $a0, 10
    jal recfunc             # call fib and link return address

    j end

recfunc:
    #save in stack
    addi $sp, $sp, -12	# Make space for function in stack
    sw $ra, 0($sp)	# ra is return address
    sw $s0, 4($sp)	# s0 is in arg
    sw $s1, 8($sp)	# s1 is for fib(y-1)

    add $s0, $a0, $zero		# s0 is arg

    addi $t1, $zero, 1		# t1 is for if 
    beq $s0, $zero, return0	# return 0 if arg = 0 (fib(0) = 0)
    beq $s0, $t1, return1	# return 1 if arg = 1 (fib(1) = 1)

    addi $a0, $s0, -1		# decrement argument

    jal recfunc			# recursively call fib for next number

    add $s1, $zero, $v0        # s1 = fib(y - 1)

    addi $a0, $s0, -2		# decrement argument again (after it already changed)

    jal recfunc                     # jumping back to fib for second number

    add $v0, $v0, $s1           # v0 = fib(n - 2) + s1

    exit:

    lw $ra, 0($sp)        	# read registers from stack
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12       	# bring back stack pointer
    jr $ra			# jump back

return1:
    li $v0, 1
    j exit			# back to jump back to caller

return0:     
    li $v0, 0
    j exit			# back

end:
