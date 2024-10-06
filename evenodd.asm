.data
arrbegin: .space 40
inputn: .asciz "Input the amount of elements\n"
incorrect: .asciz "Incorrect amount of elements (it should be in range [1, 10])"
input: .asciz "Input the elements:\n"
outputbegin: .asciz "Array contains "
outputmiddle: .asciz " even numbers and "
outputend: .asciz " odd numbers.\n"

.text
start:
la a0 inputn
li a7 4
ecall
li a7 5
ecall
mv s2 a0
li t1 10
bgt s2 t1 error
la a0 input
li a7 4
ecall
li a7 5
li t1 0
la t2 arrbegin

while:
bge t1 s2 endwhile
ecall
sw a0 (t2)
addi t2 t2 4
addi t1 t1 1
j while

endwhile:
li t1 0
la t2 arrbegin
li s3 0
li t5 2

countwhile:
bge t1 s2 endcountwhile
lw t3 (t2)
rem t4 t3 t5
beqz t4 even
continue:
addi t1 t1 1
addi t2 t2 4
j countwhile

even:
addi s3 s3 1
j continue

endcountwhile:
la a0 outputbegin
li a7 4
ecall
mv a0 s3
li a7 1
ecall
la a0 outputmiddle
li a7 4
ecall
sub a0 s2 s3
li a7 1
ecall
la a0 outputend
li a7 4
ecall
li a7 10
ecall

error:
la a0 incorrect
li a7 4
ecall
j start