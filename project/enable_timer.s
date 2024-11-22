.global _enable_timer
_enable_timer:
    addi r10, r0, 1 # coloca 1 em r10
    wrctl status, r10 # passa o valor de r10 para status (CTL0)
    wrctl ienable, r10 # ativa o interval em IENABLE (CTL3

    movia r8, 0x10000000 ## carrega 0x10000000 led verm para r8
    movia r12, 10000000 # 200 ms
    movia r11, 0x10002000

    stwio r12, 8(r11) # parte baixa

    srli r14, r12, 16
    stwio r14, 12(r11)

    movi r15, 0b111
    stwio r15, 4(r11) # Inicia temporizador

    addi r15, r0, 1
    stwio r15, (r8)
    ret 
