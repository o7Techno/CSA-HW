.global main
.include "macrolib.inc"
.include "IDZ_functions.asm"
.eqv NAME_SIZE 256
.eqv TEXT_SIZE 512
.data
mode_selection: .asciz "If you want to run the programm with your file press 1,\nif you want to run testing program#1 press 2.\nif you want to run testing program#2 press anything else.\n"
er_name_mes: .asciz "Incorrect file name\n"
er_read_mes: .asciz "Incorrect read operation\n"
input_message: .asciz "Input path to file for reading\n"
output_message: .asciz "Input path to file for writing\n"
result_message: .asciz "Would you like to output data into console?(Y/N)\n"
min_message: .asciz "Min code and char.\n"
max_message: .asciz "Max code and char.\n"
spaces: .asciz "  is the code for char  "

ans: .byte

test: .asciz "test0.txt"
res: .asciz "res0.txt"

.align 2
min_result: .space 16
max_result: .space 16
result: .space 4
buffer: .space 16
n: .asciz "\n"

file_name: .space NAME_SIZE
strbuf:	.space TEXT_SIZE

.text
main:
#Selecting programm runing mode.
li a7 54
la a0 mode_selection
la a1 ans
li a2 4
ecall

li t1 '1'
la t2 ans
lb t0 (t2)
beq t0 t1 normal
li t1 '2'
beq t0 t1 testing1


testing2:
li s7 0
li s8 5
testing2_loop:
#Changing file names.
beq s7 s8 end_testing2_loop
addi s7 s7 1
la t0 test
addi t0 t0 4
lb t1 (t0)
addi t1 t1 1
sb t1 (t0)

la t0 res
addi t0 t0 3
lb t1 (t0)
addi t1 t1 1
sb t1 (t0)

open_macro(test 0)
mv s0 a0
#Reading data from file.
allocate(TEXT_SIZE)
mv s3 a0
mv s5 a0
li s4 TEXT_SIZE
mv s6 zero

testing2_read_loop:
file_read_macro(s0 s5 TEXT_SIZE)
beq a0 s1 er_read
mv s2 a0
add s6 s6 s2
bne s2 s4 testing2_end_loop
allocate(TEXT_SIZE)
add s5 s5 s2
j testing2_read_loop

testing2_end_loop:
close_macro(s0)
mv t0 s3
add t0 t0 s6
addi t0 t0 1
sb zero (t0)

open_macro(res 1)
mv s0 a0

#Processing and writing data.
min_byte_macro(s3)
mv s10 a0
la t0 result
sb s10 (t0)
convert_macro(min_result)
file_write_macro(s0, buffer, t6)
clear(min_result)
clear(buffer)

li t0 24
file_write_macro(s0, spaces, t0)

li t0 1
file_write_macro(s0, result, t0)
file_write_macro(s0, n, t0)

max_byte_macro(s3)
mv s11 a0
la t0 result
sb s11 (t0)
convert_macro(max_result)
file_write_macro(s0, buffer, t6)
clear(max_result)
clear(buffer)

li t0 24
file_write_macro(s0, spaces, t0)

li t0 1
file_write_macro(s0, result, t0)
file_write_macro(s0, n, t0)
j testing2_loop

end_testing2_loop:
exit


testing1:
li s7 0
li s8 5
testing1_loop:
#Changing file names.
beq s7 s8 end_testing1_loop
addi s7 s7 1
la t0 test
addi t0 t0 4
lb t1 (t0)
addi t1 t1 1
sb t1 (t0)

la t0 res
addi t0 t0 3
lb t1 (t0)
addi t1 t1 1
sb t1 (t0)

open_macro(test 0)
mv s0 a0
#Reading data from file.
allocate(TEXT_SIZE)
mv s3 a0
mv s5 a0
li s4 TEXT_SIZE
mv s6 zero

testing1_read_loop:
file_read_macro(s0 s5 TEXT_SIZE)
beq a0 s1 er_read
mv s2 a0
add s6 s6 s2
bne s2 s4 testing1_end_loop
allocate(TEXT_SIZE)
add s5 s5 s2
j testing1_read_loop

testing1_end_loop:
close_macro(s0)
mv t0 s3
add t0 t0 s6
addi t0 t0 1
sb zero (t0)

open_macro(res 1)
mv s0 a0

#Processing and writing data.
min_byte_macro(s3)
mv s10 a0
la t0 result
sb s10 (t0)
convert_macro(min_result)
file_write_macro(s0, buffer, t6)
clear(min_result)
clear(buffer)

li t0 24
file_write_macro(s0, spaces, t0)

li t0 1
file_write_macro(s0, result, t0)
file_write_macro(s0, n, t0)

max_byte_macro(s3)
mv s11 a0
la t0 result
sb s11 (t0)
convert_macro(max_result)
file_write_macro(s0, buffer, t6)
clear(max_result)
clear(buffer)

li t0 24
file_write_macro(s0, spaces, t0)

li t0 1
file_write_macro(s0, result, t0)
file_write_macro(s0, n, t0)
j testing1_loop

end_testing1_loop:
exit

normal:
#Getting file name to read from.
string_output_macro(input_message)
string_input_macro(file_name NAME_SIZE)
remove_n(file_name)

#Openning file.
open_macro(file_name 0)
li s1 -1
beq a0 s1 er_name
mv s0 a0

#Reading data from file.
allocate(TEXT_SIZE)
mv s3 a0
mv s5 a0
li s4 TEXT_SIZE
mv s6 zero

read_loop:
file_read_macro(s0 s5 TEXT_SIZE)
beq a0 s1 er_read
mv s2 a0
add s6 s6 s2
bne s2 s4 end_loop
allocate(TEXT_SIZE)
add s5 s5 s2
j read_loop

end_loop:
close_macro(s0)
mv t0 s3
add t0 t0 s6
addi t0 t0 1
sb zero (t0)

#Getting file name to write to.
string_output_macro (output_message)
string_input_macro(file_name NAME_SIZE)
remove_n(file_name)
open_macro(file_name 1)
li s1 -1
beq a0 s1 er_name
mv s0 a0

#Processing and writing data.
min_byte_macro(s3)
mv s10 a0
la t0 result
sb s10 (t0)
convert_macro(min_result)
file_write_macro(s0, buffer, t6)
clear(min_result)
clear(buffer)

li t0 24
file_write_macro(s0, spaces, t0)

li t0 1
file_write_macro(s0, result, t0)
file_write_macro(s0, n, t0)

max_byte_macro(s3)
mv s11 a0
la t0 result
sb s11 (t0)
convert_macro(max_result)
file_write_macro(s0, buffer, t6)
clear(max_result)
clear(buffer)

li t0 24
file_write_macro(s0, spaces, t0)

li t0 1
file_write_macro(s0, result, t0)
file_write_macro(s0, n, t0)


#Writing data into console.
string_output_macro(result_message)
char_input_macro(t0)
string_output_macro(n)
li t1 'N'
beq t0 t1 exit
string_output_macro(min_message)
int_output_macro(s10)
string_output_macro(spaces)
char_output_macro(s10)
string_output_macro(n)

string_output_macro(max_message)
int_output_macro(s11)
string_output_macro(spaces)
char_output_macro(s11)
string_output_macro(n)

exit: 
exit
    

er_name:
la a0 er_name_mes
li a7 4
ecall
j main

er_read:
la a0 er_read_mes
li a7 4
ecall
exit
