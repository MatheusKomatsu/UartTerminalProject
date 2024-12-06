.global _timer_off
_timer_off:
    andi r15, r15, 0b01
    movia r8, 0x10000020 
    stbio r0, 0(r8) # mostra no display
    movia r8, TIMER
    stw r0, (r8) 
    ret 
.equ TIMER, 0x700