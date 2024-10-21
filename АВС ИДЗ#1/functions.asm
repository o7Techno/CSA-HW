.include "macros_lib.inc"
.global check_arrays
.global input
.global output
.global array_creator

.text


#  This function checks if the array starting at address given in a0 ending at address given in a2, is equal to the array starting at adress given in a1.
#  Returns nothing (prints the correct of incorrect message).
check_arrays:
.data
cor_mes: .asciz "Everything is correct\n"
incor_mes: .asciz "Incorrect at index "
.text
mv t1 a0
mv t2 a1
mv t3 a2
li t6 0
check_for:
bge t1 t3 end_check_for
lw t4 (t1)
lw t5 (t2)
bne t4 t5 incor_check
addi t1 t1 4
addi t2 t2 4
addi t6 t6 1
j check_for

incor_check:
la a0 incor_mes
jal t0 print_string

mv a0 t6
jal t0 print_int
ret

end_check_for:
la a0 cor_mes
jal t0 print_string
ret

#  this function takes the amount of items in register a0 and addres of the first array element address (where to fill) in register a1 and fills elements of the array
#  with items inputed from keyboard.
input:
.data
input_message: .asciz "Input the array elements:\n"
.text
mv t1 a0
mv t2 a1
li t3 0
la a0 input_message
jal t0 print_string
input_for:
bge t3 t1 input_end_for
jal t0 read_int
sw a0 (t2)
addi t2 t2 4
addi t3 t3 1
j input_for
input_end_for:
ret

#  this function takes the amount of items in a new array (prev - 1) in register a0, first array element address (where to get data) in register a1, first
#  array element address (where to fill new data) in register a2 and fills a new array with this pattern b[i] = a[i] - a[i + 1].
array_creator:
mv t1 a0
mv t2 a1
mv t3 a2
li t4 0
array_for:
bge t4 t1 end_array_for
lw t5 (t2)
addi t2 t2 4
lw t6 (t2)
sub t5 t5 t6
sw t5 (t3)
addi t3 t3 4
addi t4 t4 1
j array_for
end_array_for:
ret


#  this function takes the amount of items in an array in register a0 and first array element address in register a1 and outputs all array elements.
output:
.data
n: .asciz "\n"
output_message: .asciz "The resulting array is:\n"
.text
mv t1 a0
mv t2 a1
li t3 0
la a0 output_message
jal t0 print_string
output_for:
bge t3 t1 output_end_for
lw a0 (t2)
jal t0 print_int
la a0 n
jal t0 print_string
addi t2 t2 4
addi t3 t3 1
j output_for
output_end_for:
ret

#  This function displays string given in a0 register.
print_string:
li a7 4
ecall
jalr zero 0(t0)

#  This function displays int given in a0 register.
print_int:
li a7 1
ecall
jalr zero 0(t0)

#  This function returns an integer written from keyboard.
read_int:
li a7 5
ecall
jalr zero 0(t0)


