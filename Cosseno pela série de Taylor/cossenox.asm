.data
    PI: .float 3.141592
    _180: .float 180.0
    PRECISAO: .float 0.00001
    _1: .float 1.0
    _0: .float 0.0
    _2: .float 2.0
    msg_input: .asciiz "Insira um valor em graus para descobrir seu cosseno: "
    msg_result: .asciiz "O cosseno de "
    msg_result2: .asciiz " radianos (valor ja convertido para rad) é "
.text
main:
    # Imprime a mensagem de solicitação
    li $v0, 4           # Código para impressão de uma string
    la $a0, msg_input   # Carrega o endereço da mensagem
    syscall

    # Lê o valor do usuário
    li $v0, 6           # Código para leitura de um número real
    syscall
    jal cossenoX           # Chama a função de conversão

    # Imprime o resultado
    li $v0, 4           # Código para impressão de uma string
    la $a0, msg_result  # Carrega o endereço da primeira parte da mensagem
    syscall
    mov.s $f12, $f0     # Carrega o valor do resultado para impressão
    li $v0, 2           # Código para impressão de um número real
    syscall
    li $v0, 4           # Código para impressão de uma string
    la $a0, msg_result2 # Carrega o endereço da segunda parte da mensagem
    syscall

    # Imprime o valor inserido
    li $v0, 2           # Código para impressão de um número real
    mov.s $f12, $f1     # Carrega o valor inserido para impressão
    syscall

    # Encerra o programa
    li $v0, 10          # Código para encerrar o programa
    syscall

cossenoX:
    #f0 = x
    # Conversão de graus para radianos
    l.s  $f1, PI        # Carrega o valor de pi em $f1
    mul.s $f0, $f0, $f1   
    l.s   $f1, _180   
    div.s $f0, $f0, $f1     
    
    l.s $f3, _1         # k = 1
    l.s $f12, _1     # f12 = result
    l.s $f10, _1     # f10 = termo anterior
    l.s $f11, _1     # f11 = termo atual
    
    loop:
        abs.s $f1, $f11
        l.s $f2, PRECISAO
        c.lt.s $f1, $f2
        bc1t saiDoLoop

        mul.s $f4, $f0, $f0    # $f4 = x * x = x^2
        l.s $f17, _1
        neg.s $f17, $f17       # $f17 = -1
        mul.s $f4, $f4, $f17   # $f4 = -x^2
        l.s $f16, _2           # $f17 = 2
        mul.s $f5, $f3, $f16   # $f5 = 2k
        add.s $f6, $f5, $f17 #f6 = 2k - 1 
        mul.s $f7, $f5, $f6    # $f7 = (2k)(2k - 1)
        # termo_atual = termo_anterior * (-x^2)/[2k(2k-1)]
        neg.s $f17, $f17
        mul.s $f11, $f10, $f4 
        div.s $f11, $f11, $f7

        add.s $f12, $f12, $f11 #result += termo_atual
        mov.s $f10, $f11       # termo_anterior = Termo_atual  
        add.s $f3, $f3, $f17   # k++

        j loop
    saiDoLoop:
        mov.s $f1, $f12 
        jr $ra
