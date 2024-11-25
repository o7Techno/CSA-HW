.include "strcpy.asm"

.macro copy_string %destination_address %origin_address
la a0 %destination_address
la a1 %origin_address
call strcpy
.end_macro