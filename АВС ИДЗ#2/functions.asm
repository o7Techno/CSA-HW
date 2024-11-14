.include "macros_lib.inc"
.global print_double
.global read_int
.global print_string
.global calculate_pi

#  This subroutine takes a double value in fa0 and outputs it on display.
#  Input: fa0 double value to print.
#  Return: nothing.
print_double:
li a7 3
ecall
ret


#  This subroutine reads an int value from keyboard.
#  Input: nothing.
#  Return: Integer from keyboard.
read_int:
li a7 5
ecall
ret

#  This subroutine takes a string value address in a0 and outputs it on display.
#  Input: a0 string value address to print.
#  Return: nothing.
print_string:
li a7 4
ecall
ret

#  This function approximates pi using Rieman zetta-function.
#  Input: a0 amount of terms for function.
#  Returns: fa0 approxitmated pi value.
calculate_pi:
mv t5 a0
li t0 1
fcvt.d.w ft2 zero
#  Calculating sum value.
calculate_for:
bge t0 t5 calculate_endfor
mul t1 t0 t0
fcvt.d.w ft0 t1
li t3 1
fcvt.d.w ft1 t3
fdiv.d ft1 ft1 ft0
fadd.d ft2 ft2 ft1
fmv.d fa0 ft2
addi t0 t0 1
j calculate_for
calculate_endfor:
li t3 6
#  Rieman zetta-function calculates pi^2/6, that is why the calculation is required.
fcvt.d.w ft1 t3
fmul.d ft2 ft2 ft1
fsqrt.d fa0 ft2
ret