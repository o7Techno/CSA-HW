#  This macro inputs an integer and stores it in register %register.
.macro input_macro (%register)
#  Input: nothing.
#  Return: Integer from keyboard.
call read_int
mv %register a0
.end_macro

#  This macro outputs a string given in address %address.
.macro string_output_macro (%address)
la a0 %address
#  Input: a0 string value address to print.
#  Return: nothing.
call print_string
.end_macro

#  This macro calls a calculate_pi function with %amount_address parameter.
.macro approx_pi (%amount_address)
mv a0 %amount_address
#  Input: a0 amount of terms for function.
#  Returns: fa0 approxitmated pi value.
call calculate_pi
.end_macro

#  This macro outputs a double given in register %register.
.macro double_output_macro (%register)
fmv.d fa0 %register
#  Input: fa0 double value to print.
#  Return: nothing.
call print_double
.end_macro

#  This macro runs the auto-testing.
.macro testing_macro
.data
error: .asciz "Incorrect.\n"
cor: .asciz "Correct.\n"
.text
la s0 test_begin
la s1 ans_begin
mv s10 s1
test_for:
bge s0 s10 end_test_for
lw s2 (s0)
addi s0 s0 4
approx_pi (s2)
fld fs3 (s1)
addi s1 s1 8
feq.d s3 fa0 fs3
beqz s3 incor_test

j test_for

incor_test:
string_output_macro (error)

j out

end_test_for:
string_output_macro (cor)
j out

out:
.end_macro

#  This macro allows user to select the mode in which they want to run the programm and runs the program with that mode.
.macro mode
.data
mode_message: .asciz "If you want to execute the function given in task press 0, if you want to go through testing values press any other number.\nKeep in mind that auto-testing takes a while.\n"
message: .asciz "To approximate pi with 0.1% precision this script uses Rieman zetta-funcion to 2000 terms\nIf you select 0 you can input your own amount of terms or input any other number to procede with the default settings.\n"
terms: .asciz "Input the amount of terms [2; 40000] :\n"
incorrect: .asciz "Incorrect amount of terms.\n"
.text
string_output_macro (mode_message)
input_macro (t0)
beqz t0 no_test

testing_macro
j out

no_test:
string_output_macro (message)
input_macro (t0)
beqz t0 input_terms

li t1 2000
j call_func

input_terms:
string_output_macro (terms)
input_macro (t1)
li t0 40000
bgt t1 t0 incorrect_input
li t0 2
blt t1 t0 incorrect_input
j call_func
incorrect_input:
string_output_macro (incorrect)
j input_terms

call_func:
approx_pi (t1)
double_output_macro (fa0)

out:
.end_macro