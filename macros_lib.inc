.macro input_macro ()
start:
#  Выводим начальное сообщение.
la a0 message
jal t0 print_string

jal t0 read_int
mv s1 a0
li s2 10
li s3 1

#  Проверка корректности входных данных.
ble s1 s3 incorrect
bgt s1 s2 incorrect
la a1 a_begin
# Вход: a0 - размер массива, a1 - адрес начала массива.
# Выход: ничего (записывает данные в data).
call input
j out

#  Если неверные входные данные.
incorrect:
.data
incorrect_message: .asciz "Incorrect ammount of elements.\n"
.text
la a0 incorrect_message
jal t0 print_string
j start

out:
.end_macro


.macro array_creator_macro ()
mv a0 s1
la a1 a_begin
la a2 b_begin
#  Создаем новый массив.
#  Вход: a0 - размер выходного массива, a1 - адрес начала входного массива, a2 - адрес начала выходного массива.
#  Выход: ничего (записывает данные в data).
call array_creator
.end_macro

.macro output_macro ()
mv a0 s1
la a1 b_begin
#  Вход: a0 - размер выходного массива, a1 - адрес начала выходного массива.
#  Выход: ничего (выводит данные в консоль).
call output
.end_macro

.macro mode ()
.data
mode_message: .asciz "If you want to input your own array press 0, if you want to go through testing arrays press any other number.\n"
.text
la a0 mode_message
jal t0 print_string
jal t0 read_int
beqz a0 normal
j test

normal:
#  Handles the whole input part of the programm.
input_macro

#  Вычитаем 1, т.к. размер выходного массива на 1 меньше входного
addi s1 s1 -1

#  Handles new array creation.
array_creator_macro

#  Handles the output of the array.
output_macro
j exit

test:
la s4 test_begin
la s6 test_end
la s9 test_res

test_for:
bge s4 s6 end_test_for
lw s7 (s4)
addi s7 s7 -1
addi s4 s4 4
mv a0 s7
mv a1 s4
mv a2 s9

#  Создаем новый массив.
#  Вход: a0 - размер выходного массива, a1 - адрес начала входного массива, a2 - адрес начала выходного массива.
#  Выход: ничего (записывает данные в data).
call array_creator
li t1 4
mul s8 s7 t1
add s9 s9 s8
addi s8 s8 4
add s4 s4 s8
j test_for

end_test_for:
la a0 test_ans_begin
la a1 test_res
la a2 test_ans_end

#  Вход: a0 - адрес начала первого массива, a1 - адрес начала второго массива, a2 - адрес окончания первого массива.
#  Выход - ничего (Выводит сообщения, что все данные совпадают или есть не совподающие данные).
call check_arrays
j exit

.end_macro
