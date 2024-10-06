.data
arrbegin: .space 40
arrend:
inputn: .asciz "Input the amount of elements\n"
incorrect: .asciz "Incorrect amount of elements (it should be in range [1, 10])"
input: .asciz "Input the elements:\n"
overflowbegin: .asciz "Overflow occured\nAfter "
overflowend: .asciz " elements the sum was "
output: .asciz "Sum of elements: "

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
li s4 0
li s5 0

sumwhile:
bge t1 s2 endsumwhile
lw t3 (t2)
add s3 s3 t3
bgez t3 positive
blez t3 negative
continue:
mv s5 s3
addi t2 t2 4
addi t1 t1 1
j sumwhile

positive:
blt s3 s5 overflow
j continue

negative:
bgt s3 s5 overflow
j continue

overflow:
la a0 overflowbegin
li a7 4
ecall
mv a0 t1
li a7 1
ecall
la a0 overflowend
li a7 4
ecall
mv a0 s5
li a7 1
ecall
li a7 10
ecall

endsumwhile:
la a0 output
li a7 4
ecall
mv a0 s3
li a7 1
ecall
li a7 10
ecall


error:
la a0 incorrect
li a7 4
ecall
j start