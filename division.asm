.data
x: .asciz "Insert x: "
y: .asciz "Insert y: "
inc: .asciz "Incorrect y value\n"
res: .asciz "Quotient: "
r: .asciz "Remainder: "
n: .asciz "\n"

.text
li t2 0
li t6 0
li t3 1
do:
la a0 x
li a7 4
ecall

li a7 5
ecall
mv t1 a0

la a0 y
li a7 4
ecall

li a7 5
ecall
mv t2 a0

beq t2 zero incorrect
bltz t1 ne
bgtz t1 po
beqz t1 ze


ze:
li t6 0
j out

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
j out

posneg:
posnegwhile:
bltz t1 posnegendwhile
add t1 t1 t2
sub t6 t6 t3
j posnegwhile
posnegendwhile:
sub t1 t1 t2
add t6 t6 t3
j out

negpos:
negposwhile:
bgtz t1 negposendwhile
add t1 t1 t2
sub t6 t6 t3
j negposwhile
negposendwhile:
sub t1 t1 t2
add t6 t6 t3
j out

negneg:
negnegwhile:
bgtz t1 negnegendwhile
sub t1 t1 t2
add t6 t6 t3
j negnegwhile
negnegendwhile:
add t1 t1 t2
sub t6 t6 t3
j out

out:
la a0 res
li a7 4
ecall
mv a0 t6
li a7 1
ecall
la a0 n
li a7 4
ecall
la a0 r
ecall
mv a0 t1
li a7 1
ecall

li a7 10
ecall

incorrect:
la a0 inc
li a7 4
ecall
j do