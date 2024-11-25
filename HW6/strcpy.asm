.global strcpy
.text
strcpy:
mv t0 a0
mv t1 a1 
loop:
lb t4 (t1)
sb t4 (t0)
beqz t4 end_loop
addi t0 t0 1
addi t1 t1 1
j loop
end_loop:
ret