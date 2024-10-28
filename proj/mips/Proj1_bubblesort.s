.data

numbers: .word 34675, 100, 2, -26, 175, 16, 212, 7, -3, 17
space:	 .word 0, 0
n:	 .word 10

.text

add $0, $0, $0
main: 
	la $s0 numbers		# &arr = s0
	la $t0 n
	
	lw $s1, 0($t0) 		# n = s1
	addi $s2, $0, 0		# swapped = s2
	addi $s3, $0, 0		# i = s3 = 0
	
	j cond1
	
loop1:
	addi $s2, $0, 0		# swapped = false
	addi $s4, $0, 0		# j = s4
	j cond2
	
loop2:
	sll $t0, $s4, 2
	addu $t0, $t0, $s0	
	lw $t1, 0($t0)		# arr[j] = t1
	lw $t2, 4($t0)		# arr[j+1] = t2
	slt $t3, $t2, $t1
	beq $t3, $0, NoIf
	sw $t1, 4($t0)		# Store swapped numbers
	sw $t2, 0($t0)
	addi $s2, $0, 1		# swapped = true
	
NoIf:
	addi $s4, $s4, 1	# j++
	
cond2:
	sub $t0, $s1, $s3
	addi $t0, $t0, -1
	slt $t0, $s4, $t0
	bne $t0, $0, loop2
	addi $s3, $s3, 1	# i++
	beq $s2, $0, end
	
cond1:
	addi $t0, $s1, -1
	slt $t0, $s3, $t0
	bne $t0, $0, loop1
	
end:
halt
