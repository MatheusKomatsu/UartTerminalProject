
.global _start_animation
_start_animation:
   movia r8, 0x10000000 ## carrega 0x10000000 led verm para r8
   movia r9, 0x10000040 # carrega 0x10000040 switchs para r8
   ldwio r10, (r9) # carrega switch
   andi r11, r10, 0x1
   addi r12, r0, 0x1
   beq r11, r12, SWITCH_UP

SWITCH_DOWN: # baixo animação da esquerda pra direita
   ldwio r12, (r8) # carrega led
   movia r11, 0b111111111111111111
   and r12, r12, r11 # faz mascara
   addi r10, r0, 1
   beq r12, r10, IF1
   srli r12, r12, 1
   stwio r12, (r8)
ret
IF1:
    addi r12, r0, 0b100000000000000000
    stwio r12, (r8)
ret

SWITCH_UP: # baixo animação da direita pra esquerda 
   ldwio r12, (r8) # carrega led
   movia r11, 0b111111111111111111
   and r12, r12, r11 # faz mascara
   movia r11, 0b100000000000000000   
   beq r12 ,r11 ,IF2
   slli r12, r12, 1
   stwio r12, (r8)
ret   
IF2:
    addi r12, r0, 1
    stwio r12, (r8)
ret
