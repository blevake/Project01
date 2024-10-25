# Testing artithmatic functions
.data
info: .word 66

.text
main:
add $1, $0, $0
addi $2, $1, 10
addiu $3, $2, 6
addu $4, $3, $2

and $5, $4, $3
andi $6, $4, 16
lui $7, 23
nor $8, $5, $6
xor $9, $8, $7
xori $10, $2, 3
or $11, $10, $9
ori $12, $11, 100
slt $13, $11, $12
slti $14, $13, 1
sll $15, $12, 4
srl $16, $15, 5
sra $17, $15, 6
sub $18, $15, $16
subu $19, $16, $15
la $20, info
sw $19, 0($20)
lw $21, 0($20)
