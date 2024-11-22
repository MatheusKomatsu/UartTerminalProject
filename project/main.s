/*
Part 1
- Objetivo
    Escrever no terminal UART, ver texto saindo no mesmo terminal e armazenar o comando final reproduzido, 
    para que possa ser utilizado na selecao da funcao no futurp


- Problmeas
    Armazenar mais de um caracter, para compreender comandos maiores

- Como fazer?
    Reservar espaço da memória para armazenar caracteres do comando
    Armazeznar endereço do registrador de dados UART
    Mensagem para usuário ("Entre com o comando")
    FAzer um pooling para verificar este campo de memória
    Se o RVALID for 1, armazenar os dados no mesmo campo de memória
    Se caracter == "\n", parar leitura e levar lista na memória
    Fazer Parse do comando para entender se é válido
    Se for válido, fazer chamada da função correspondente

 - Dados importantes
    Endereço Data register UART -> 0x10001000
    Endereço Control register UART -> 0x10001004
    Máscara RVALID 0xFFFF
:)
*/

.org 0x20
RTI: 
/* Exception handler */
    rdctl et, ipending /* Check if external interrupt occurred */
    beq et, r0, OTHER_EXCEPTIONS /* If zero, check exceptions */
    subi ea, ea, 4 /* Hardware interrupt, decrement ea to execute the interrupted */

    /* instruction upon return to main program */

    andi r13, et, 1 /* Check if irq0 asserted */
    beq r13, r0, OTHER_INTERRUPTS /* If not, check other external interrupts */
    call EXT_IRQ0 /* If yes, go to IRQ0 service routine */

OTHER_INTERRUPTS:
    /* Instructions that check for other hardware interrupts should be placed here */

    br END_HANDLER /* Done with hardware interrupts */
    
OTHER_EXCEPTIONS:
    /* Instructions that check for other types of exceptions should be placed here */

END_HANDLER:
    eret /* Return from exception */

.org 0x100
    /* Interrupt-service routine for the desired hardware interrupt */
    EXT_IRQ0:

        call _start_animation

        ret # retorna a rotina

.global _start
_start: 
    movia r16, 0x10001000 ## Endereco UART
    
REPEATER_COMMAND:
    # TODO: Must me reset after each command
    movi r23, LIST 
    addi r20, r0, 0xFF ## mascara primeiros 8 bits

SHOW_ENTRY_MESSAGE:
    # Checar buffer
    ldwio r21, 4(r16) # Endereco UART controll
    andhi r21, r21, 0xFFFF
    beq r21, r0, SHOW_ENTRY_MESSAGE

    # Imprime mensagem inicial
    movia r22, REPEATER_MESSAGE
PRINT_ENTRY_MESSAGE:  
    # Carrega Byte a byte os caracteres da mensagem
    ldb r17, (r22)
    beq r17, r0, POLLING_READ
    stwio r17, (r16) # Faz caracter aparecer no prompt
    addi r22, r22, 1 # Avança character
    br PRINT_ENTRY_MESSAGE

POLLING_READ:
    ldwio r17, (r16) ## Carrega valor em memória
    andi r19,r17, 0x8000 ## Aplica mascara para recuperar valor do RVALID 
    beq r19, r0, POLLING_READ ## Se R VALID = 0, retorna pro pooling
    and r17, r17, r20 ## Recupera apenas os bits de valor
POLLING_WRITE:
    ldwio r21, 4(r16) # Endereco UART controll
    andhi r21, r21, 0xFFFF
    beq r21, r0, POLLING_WRITE
    stwio r17, (r16) # Faz caracter aparecer no prompt

    movi r22, 0x08 # usado para identificar Backspace
    bne r17,r22, ADD_CHARACTER
    addi r23, r23, -4 # Volta uma posicao na lista de caracteres
    stwio r0, (r23) # Zera a posicao anterior da lista
    br COMPARISON_END_TEXT
ADD_CHARACTER:
    stwio r17, (r23) # Armazena caracter na memória
    addi r23, r23, 4 # Progride uma posicao na lista de caracteres

COMPARISON_END_TEXT:
    movi r18, 0x0A # Procura por fim de linha (carriage Reutnr )
    bne r17,r18, POLLING_READ

## TRATAMETNO PARSE DO COMANDO
PARSE_COMMAND:
## Vericia 3 casos aceito, 0X, 1X,2X, na lista de caracteres do comando
    movi r23, LIST
    ldw r20, (r23)
## Compara com caracter "0"
    addi r21, r0, 0x30 
    beq r20, r21, CASE0X
## Compara com caracter "1"
    addi r21, r0, 0x31
    beq r20, r21, CASE1X
## Compara com caracter "2"
    addi r21, r0, 0x32
    beq r20, r21, CASE2X
    br REPEATER_COMMAND
    
CASE0X:
## Avanca na lista
    addi r23,r23, 4
    ldw r20, (r23)
    addi r21, r0, 0x30
    beq r20, r21, CASE00
    addi r21, r0, 0x31 
    beq r20, r21, CASE01
    br REPEATER_COMMAND
CASE00:
    addi r23,r23, 4
    ldw r20, (r23)
    ## Verifica espaco
    addi r21, r0, 0x20
    bne r20,r21, REPEATER_COMMAND 
    ## Verifica se comando esta corretp
    addi r23,r23, 4
    ldw r20, (r23)
    addi r21, r0, 0xa
    beq r21, r20, REPEATER_COMMAND      
    ## se estover correto, carrega parametro
    mov r4, r20
    addi r23,r23, 4
    ldw r20, (r23)
    addi r21, r0, 0xa
    beq r21, r20, REPEATER_COMMAND
    mov r5, r20
    call _turn_on_led
    br REPEATER_COMMAND 

CASE01:
    addi r23,r23, 4
    ldw r20, (r23)
    ## Verifica espaco
    addi r21, r0, 0x20
    bne r20,r21, REPEATER_COMMAND 
    ## Verifica se comando esta corretp
    addi r23,r23, 4
    ldw r20, (r23)
    addi r21, r0, 0xa
    beq r21, r20, REPEATER_COMMAND      
    ## se estover correto, carrega parametro
    mov r4, r20
    addi r23,r23, 4
    ldw r20, (r23)
    addi r21, r0, 0xa
    beq r21, r20, REPEATER_COMMAND
    mov r5, r20
    call _turn_off_led
    br REPEATER_COMMAND 
CASE1X:
    addi r23,r23, 4
    ldw r20, (r23)
    addi r21, r0, 0xa
    beq r21, r20, REPEATER_COMMAND  
    addi r21, r0, 0x30
    beq r21, r20, CASE10
    addi r21, r0, 0x31
    beq r21, r20, CASE11
    br REPEATER_COMMAND
CASE10:
    call _enable_timer
    br REPEATER_COMMAND
CASE11:
    call _end_animation
    br REPEATER_COMMAND	
CASE2X:
    addi r23,r23, 4
    ldw r20, (r23)
    addi r21, r0, 0xa
    beq r21, r20, REPEATER_COMMAND  
    addi r21, r0, 0x30
    beq r21, r20, CASE20
    addi r21, r0, 0x31
    beq r21, r20, CASE21
    br REPEATER_COMMAND
CASE20:
    call _enable_timer
    br REPEATER_COMMAND
CASE21:
    call _timer_off
    br REPEATER_COMMAND

## FIM DO TRATAMENTO PARSE DO COMANDo
    br REPEATER_COMMAND # Reiniciar repetidor para entrada de comandos

stop: 
    br stop

.equ LIST, 0x500
## NOT IMPLEMENTED YET
##.org LIST
##.word 20 # Somente vinte caracteres permitidos
REPEATER_MESSAGE:
.asciz "Entre com o comando: "