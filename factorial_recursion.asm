main:
li s1 1
li s2 0
loop:
mv a0 s1
call factorial
ble a0 s2 end_main
mv s2 a0
addi s1 s1 1
j loop

end_main:
addi s1 s1 -2
mv a0 s1
li a7 1
ecall
li a7 10
ecall


#Функция возвращает факториал числа в a0 (считает реккурсивно).
factorial1:
addi t0 a0 -1
bge t0 zero factorial2
li a0 1
jalr zero 0(ra)
factorial2:
addi sp sp -8
sw ra 4(sp)
sw a0 (sp)
addi a0 a0 -1
jal ra factorial1
mv t1 a0
lw a0 (sp)
lw ra 4(sp)
addi sp sp 8
mul a0 a0 t1
jalr zero 0(ra)
