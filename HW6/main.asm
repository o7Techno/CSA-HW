.eqv BUFSIZE 100
.data
mode: .asciz "Select mode\n1. Input your own string\n2. Run with default string\n"
incor: .asciz "Incorrect input\n"
input: .asciz "Input your string(< 100 chars)\n"

source: .space BUFSIZE
default_source: .asciz "This is the default testing string."
destination: .space BUFSIZE

.include "macro.inc"

.text
.global main

main:
la a0 mode
li a7 4  
ecall
li a7 5          
ecall
li t0 1
beq a0 t0 str_input
li t0 2
beq a0 t0 testing
j incorrect

incorrect:
la a0 incor
li a7 4
ecall
j main

str_input:
la a0 input
li a7 4
ecall
la a0 source
li a1 BUFSIZE
li a7 8
ecall
copy_string(destination, source)
j exit

testing:
copy_string(destination, default_source)
j exit

exit:
li a7 4
ecall
li a7 10
ecall
