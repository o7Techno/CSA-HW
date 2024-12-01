#  This macro inputs an integer and stores it in register %register.
.macro int_input_macro (%register)
#  Input: nothing.
#  Return: Integer from keyboard.
call read_int
mv %register a0
.end_macro

#  This macro outputs an integer in console.
.macro int_output_macro (%register)
mv a0 %register
#  Input: a0 int value register to print.
#  Return: nothing.
call print_int
.end_macro

#  This macro inputs a string value and stores it in buffer from address %buffer_address with size %max_buffer_size.
.macro string_input_macro(%buffer_address %max_buffer_size)
la a0 %buffer_address
li a1 %max_buffer_size
#  Input: a0 buffer address to write from; a1 max buffer length.
#  Return: nothing.
call read_string
.end_macro


#  This macro outputs a string given in address %address.
.macro string_output_macro (%address)
la a0 %address
#  Input: a0 string value address to print.
#  Return: nothing.
call print_string
.end_macro


#  This macro inputs a char and stores it in register %register.
.macro char_input_macro(%register)
#  Input: nothing.
#  Return: Integer from keyboard.
call read_char
mv %register a0
.end_macro

#  This macro outputs a char in console.
.macro char_output_macro(%register)
mv a0 %register
#  Input: a0 char value register to print.
#  Return: nothing.
call print_char
.end_macro

#This macro removes \n left at the end of every string inputed from console in RARS.
.macro remove_n (%address)
li t0 '\n'
la t1 %address
for:
lb t2 (t1)
beq t0 t2 end_for
addi t1 t1 1
j for
end_for:
sb zero (t1)
.end_macro

#This macro clears 16 bytes from address %address.
.macro clear (%address)
la t0 %address
mv t1 zero
li t2 16
clear_for:
bge t1 t2 end_clear_for
sb zero (t0)
addi t0 t0 1
addi t1 t1 1
j clear_for
end_clear_for:
.end_macro

#This macro calculates the maximal byte in a string given at address %address.
.macro max_byte_macro(%address)
mv a0 %address
#  Input: a0 string address
#  Return: maximal byte in string
call max_byte
.end_macro


#This macro calculates the minimal byte in a string given at address %address.
.macro min_byte_macro(%address)
mv a0 %address
#  Input: a0 string address
#  Return: minimal byte in string
call min_byte
.end_macro


#This macro opens a file with name %file_name and options %opt
.macro open_macro(%file_name, %opt)
la a0 %file_name
li a1 %opt
#  Input: a0 file name; a1 open mode (read/write).
#  Return: a0 file descriptor or -1 if unsuccessful.
call open
.end_macro


#This macro closes a file with file descriptor %file_descriptor
.macro close_macro(%file_descriptor)
mv a0 %file_descriptor
#  Input: a0 file descriptor
#  Return: nothing
call close
.end_macro

#This macro reads data from file.
.macro file_read_macro(%file_descriptor, %reg, %size)
mv a0 %file_descriptor
mv a1 %reg
li a2 %size
#  Input: a0 file descriptor; a1 buffer address; a2 string size to read
#  Output: nothing
call read_file
.end_macro


#This macro writes data into file.
.macro file_write_macro(%file_descriptor, %buffer, %size)
mv a0 %file_descriptor
la a1 %buffer
mv a2 %size
#  Input: a0 file descriptor; a1 buffer address to write from; a2 string size to write
#  Return: nothing.
call write_file
.end_macro

#This macro converts an integer from address into string.
.macro convert_macro(%address)
la t0 %address
li t1 10
mv t5 zero
convert_while:
beqz a0 convert_end_while
rem t2 a0 t1
addi t2 t2 48
sb t2 (t0)
addi t0 t0 1
addi t5 t5 1
div a0 a0 t1
j convert_while

convert_end_while:
addi t0 t0 -1
la t4 buffer
mv t6 t5
convert_new_while:
beqz t5 convert_end
lb t2 (t0)
sb t2 (t4)
addi t4 t4 1
addi t0 t0 -1
addi t5 t5 -1
j convert_new_while

convert_end:
.end_macro

#This macro allocates memory of size %size in heap.
.macro allocate(%size)
li a7 9
li a0 %size
ecall
.end_macro

#This macro exits the programm.
.macro exit
li a7 10
ecall
.end_macro



