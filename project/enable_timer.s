.global _enable_timer
_enable_timer:
    addi r16, r0, 1 # coloca 1 em r16
    wrctl status, r16 # passa o valor de r16 para status (CTL0)
    wrctl ienable, r16 # ativa o interval em IENABLE (CTL3

    movia r18, 10000000 # 200 ms   
    movia r17, 0x10002000

    stwio r18, 8(r17) # parte baixa

    srli r19, r18, 16
    stwio r19, 12(r17)

    movi r20, 0b111
    stwio r20, 4(r17) # Inicia temporizador
    ret 
