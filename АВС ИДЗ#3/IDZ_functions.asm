.text
.global max_byte
.global min_byte
.global read_int
.global print_int
.global read_string
.global print_string
.global read_char
.global print_char
.global open
.global close



#  This subroutine reads an int value from keyboard.
#  Input: nothing.
#  Return: Integer from keyboard.
read_int:
li a7 5
ecall
ret

#  This subroutine takes an int value register in a0 and outputs it on display.
#  Input: a0 int value register to print.
#  Return: nothing.
print_int:
li a7 1
ecall
ret


#  This subroutine reads a string value from keyboard.
#  Input: a0 buffer address to write from; a1 max buffer length.
#  Return: nothing.
read_string:
li a7 8
ecall
ret


#  This subroutine takes a string value address in a0 and outputs it on display.
#  Input: a0 string value address to print.
#  Return: nothing.
print_string:
li a7 4
ecall
ret

#  This subroutine reads an int value from keyboard.
#  Input: nothing.
#  Return: Integer from keyboard.
read_char:
li a7 12
ecall
ret

#  This subroutine takes a char value register in a0 and outputs it on display.
#  Input: a0 char value register to print.
#  Return: nothing.
print_char:
li a7 11
ecall
ret

#  This subroutine opens a file.
#  Input: a0 file name; a1 open mode (read/write).
#  Return: a0 file descriptor or -1 if unsuccessful.
open:
li a7 1024
ecall
ret


#  This subroutine closes a file.
#  Input: a0 file descriptor.
#  Return: nothing.
close:
li a7 57
ecall
ret


#  This subroutine reads data from file.
#  Input: a0 file descriptor; a1 buffer address; a2 string size to read.
#  Return: nothing.
read_file:
li a7 63
ecall
ret


#  This subroutine writes data into file.
#  Input: a0 file descriptor; a1 buffer address to write from; a2 string size to write
#  Return: nothing.
write_file:
li a7 64
ecall
ret


#  This subroutine takes string address in a0 and calculates the mininal byte in the string.
#  Input: a0 string address
#  Return: minimal byte in string
min_byte:
li t0 100000
min_loop:
lb t1 (a0)
beqz t1 end_min
blt t1 t0 new_min
addi a0 a0 1
j min_loop
new_min:
mv t0 t1
addi a0 a0 1
j min_loop
end_min:
mv a0 t0
ret


#  This subroutine takes string address in a0 and calculates the maximal byte in the string.
#  Input: a0 string address
#  Return: maximal byte in string
max_byte:
li t0 0
max_loop:
lb t1 (a0)
beqz t1 end_max
bgt t1 t0 new_max
addi a0 a0 1
j max_loop
new_max:
mv t0 t1
addi a0 a0 1
j max_loop
end_max:
mv a0 t0
ret
