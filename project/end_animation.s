.global _end_animation
_end_animation:    
    andi r15, r15, 0b10
    movia r8, 0x10000000 ## carrega 0x10000000 led verm para r8
    stwio r0, (r8) # apaga os leds
    ret 
