main:
li s1 1
loop:
mv a0 s1
call factorial
bltz a0 end_main
addi s1 s1 1
j loop

end_main:
addi s1 s1 -2
mv a0 s1
li a7 1
ecall
li a7 10
ecall


#Функция возвращает факториал числа в a0 и если произошло переполнение возвращает -1
factorial:
mv t3 a0
li t1 1
mv t4 t1
li t2 1
for:
bgt t2 t3 end_for
mul t1 t1 t2
blt t1 t4 overflow
mv t4 t1
addi t2 t2 1
j for
end_for:
mv a0 t1
ret
overflow:
li a0 -1
ret