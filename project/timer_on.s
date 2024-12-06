.global _timer_on
_timer_on:  

    ## Endereço
    movia r12, COD_7SEG
    ## Primeiro digitos
    movia r10, TIMER
    ldw r8, (r10)
    addi r9, r0, 9
    beq r8,r9, MOVE_DIGIT_UP_1
    addi r8,r8, 1
DISPLAY_DIGIT1:
    stw r8, (r10)
    add r11, r8, r12 ## Pega equivalente  no disaply
    ldb r11, 0(r11) # carrega pra memoria 

    movia r12, 0x10000020 
    stbio r11, 0(r12) # mostra no display

MOVE_DIGIT_UP_1:
ret 

.equ TIMER, 0x700

COD_7SEG: 
.byte 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F

/*
0 - 0011 1111 - 3F
1 - 0000 0110 - 06
2 - 0101 1011 - 5C
3 - 0100 1111 - FC
4 - 0110 0110 - 66
5 - 0110 1101 - 6D
6 - 0111 1101 - 7D
7 - 0000 0111 - 07
8 - 0111 1111 - 7F
9 - 0110 1111 - 6F
 */
