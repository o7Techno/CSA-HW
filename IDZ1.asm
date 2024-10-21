#Косинов Денис Константинович БПИ239. 33 Вариант.

.data
a_begin: .space 40
#  Т.к. по условию вариантанужно в массив b записывать разности между соседними элементами, то
#  в b[i] будет лежать разность между a[i] и a[i + 1], тогда в b будет на 1 элемент меньше, чем в a. 
b_begin: .space 36

test_begin: .
.word 2
.word 3
.word -5
.word 3
.word 12
.word 7
.word -9
.word 4
.word -1
.word 6
.word -8
.word 5
.word 10
.word -22
.word 3
.word 7
.word 19
.word 6
.word 8
.word -2
.word 10
.word 5
.word -6
.word 4
.word 7
.word 11
.word 14
.word -3
.word 9
.word 17
.word 5
.word -12
.word 8
.word -6
.word 1
.word 0
.word 4
.word -3
.word 7
.word 2
.word 6
.word 20
.word -15
.word 30
.word -25
.word 18
.word 2
.word 6
.word 13
.word 4
.word 7
.word -16
.word 8
.word 7
.word 2
.word 2
.word -1
.word 5
.word 9
.word -7
.word 11
.word 14
.word 1
test_end:
test_ans_begin:
.word 8
.word 5
.word 16
.word -7
.word 14
.word -13
.word -25
.word -4
.word -12
.word 13
.word -2
.word 10
.word -12
.word 5
.word 11
.word -4
.word -3
.word 17
.word 12
.word 17
.word -20
.word 14
.word -7
.word 1
.word -4
.word 7
.word -4
.word -14
.word 35
.word -45
.word 55
.word -43
.word -7
.word 23
.word -24
.word 1
.word 3
.word 16
.word -18
.word -3
.word 13
test_ans_end:
test_res: .space 176

message: .asciz "Input the amount of elements (1; 10]\n"
.include "functions.asm"
.global main

.text
main:

#  Selects whether the data will be inputed or use the testing program and continues with the mode given.
mode

exit:
li a7 10
ecall





