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
- Mapeamento
    R16 -> Endereco UART
    R17 -> Reservado para pegar o valor dos dados do UART
    R18 -> Máscara para RVALID F
    r19 -> R17 com mascara aplicada
    r20 -> Mascar dos primeiros 8 bits
    r21 -> Carrega o valor do registrador do controle uart
:)
*/


.global _start
_start: 
    movia r16, 0x10001000 ## Endereco UART
    movia r18, 0x8000 ## Mascara RVALID 
    movi r23, LIST 
    addi r20, r0, 0xFF ## mascara primeiros 8 bits
    mov r22, r0 # Zera index de list

POLLING_READ:
    ldwio r17, (r16) ## Carrega valor em memória
    and r19,r17, r18 ## Aplica mascara para recuperar valor do RVALID 
    beq r19, r0, POLLING_READ ## Se R VALID = 0, retorna pro pooling
    and r17, r17, r20 ## Recupera apenas os bits de valor
POLLING_WRITE:
    ldwio r21, 4(r16) # Endereco UART controll
    andhi r21, r21, 0xFFFF
    beq r21, r0, POLLING_WRITE
    stwio r17, (r16)
    br POLLING_READ

stop: 
    br stop

.equ LIST, 0x500
.org LIST
.word 20 # Somente vinte caracteres permitidos
