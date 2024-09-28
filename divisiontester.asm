.data
correct: .asciz "Correct\n"
incorrect: .asciz "Incorrect\n"
.align 2
#testing data (in pairs divident and divisor).
test: .word 0
.word 3
.word 0
.word -3
.word 6
.word 3
.word 4
.word -2
.word -8
.word 4
.word -12
.word -3
.word 21
.word 4
.word 13
.word -5
.word -13
.word 5
.word -11
.word -2

#correct results to check (in pairs quotient and remainder).
results:
.word 0
.word 0
.word 0
.word 0
.word 2
.word 0
.word -2
.word 0
.word -2
.word 0
.word 4
.word 0
.word 5
.word 1
.word -2
.word 3
.word -2
.word -3
.word 5
.word -1

.text

start:
la t4 test
la t5 results

#main cycle.
while:
li t2 0 
li t6 0
li t3 1
la t1 results
bge t4 t1 finish
lw t1 (t4)
addi t4 t4 4
lw t2 (t4)
addi t4 t4 4
bltz t1 ne
bgtz t1 po
beqz t1 ze

#calculations.
ze:
li t6 0
j check

ne:
bltz t2 negneg
bgtz t2 negpos

po:
bltz t2 posneg
bgtz t2 pospos

pospos:
posposwhile:
bltz t1 posposendwhile
sub t1 t1 t2
add t6 t6 t3
j posposwhile
posposendwhile:
add t1 t1 t2
sub t6 t6 t3
j check

posneg:
posnegwhile:
bltz t1 posnegendwhile
add t1 t1 t2
sub t6 t6 t3
j posnegwhile
posnegendwhile:
sub t1 t1 t2
add t6 t6 t3
j check

negpos:
negposwhile:
bgtz t1 negposendwhile
add t1 t1 t2
sub t6 t6 t3
j negposwhile
negposendwhile:
sub t1 t1 t2
add t6 t6 t3
j check

negneg:
negnegwhile:
bgtz t1 negnegendwhile
sub t1 t1 t2
add t6 t6 t3
j negnegwhile
negnegendwhile:
add t1 t1 t2
sub t6 t6 t3
j check

#check if correct.
check:
lw t3 (t5)
beq t3 t6 cor
bne t3 t6 incor

cor:
addi t5 t5 4
lw t3 (t5)
addi t5 t5 4
beq t3 t1 corcor
bne t3 t1 corincor
incor:
addi t5 t5 8
la a0 incorrect
li a7 4
ecall
j while

corcor:
la a0 correct
li a7 4
ecall
j while
corincor:
la a0 incorrect
li a7 4
ecall
j while

#exit
finish:
li a7 10
ecall
