.global _turn_on_led
_turn_on_led:
    movia r8, 0x10000000 ## carrega 0x10000000 led verm para r8
    ## Transforma da tabela ASCi para valor real
    addi r10, r4, -0x30
    # Multiplicaao do digito a esqueda => 10x = 8x + 2x
    slli r11, r10, 3
    slli r10, r10, 1
    add r10, r11, r10  

    add r9, r0, r10
    addi r10, r5, -0x30
    add r9, r9, r10 
    ## Transformacao em binario 
    addi r10, r0, 0x1
    sll r9,  r10, r9
    ldwio r11, (r8)
    or r9, r11, r9
    stwio r9, (r8)
    ret 
