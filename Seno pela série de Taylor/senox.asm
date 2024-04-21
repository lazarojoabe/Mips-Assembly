.data
    PI: .float 3.141592
    _180: .float 180.0
    PRECISAO: .float 0.00001
    _1: .float 1.0
    _0: .float 0.0
    _2: .float 2.0
    msg_input: .asciiz "Insira um valor em graus para descobrir seu seno: "
    msg_result: .asciiz "O seno de "
    msg_result2: .asciiz " radianos (valor ja convertido para rad) � "
.text
main:
    # Imprime a mensagem de solicita��o
    li $v0, 4           # C�digo para impress�o de uma string
    la $a0, msg_input   # Carrega o endere�o da mensagem
    syscall

    # L� o valor do usu�rio
    li $v0, 6           # C�digo para leitura de um n�mero real
    syscall
    jal senox           # Chama a fun��o de convers�o

    # Imprime o resultado
    li $v0, 4           # C�digo para impress�o de uma string
    la $a0, msg_result  # Carrega o endere�o da primeira parte da mensagem
    syscall
    mov.s $f12, $f0     # Carrega o valor do resultado para impress�o
    li $v0, 2           # C�digo para impress�o de um n�mero real
    syscall
    li $v0, 4           # C�digo para impress�o de uma string
    la $a0, msg_result2 # Carrega o endere�o da segunda parte da mensagem
    syscall

    # Imprime o valor inserido
    li $v0, 2           # C�digo para impress�o de um n�mero real
    mov.s $f12, $f1     # Carrega o valor inserido para impress�o
    syscall

    # Encerra o programa
    li $v0, 10          # C�digo para encerrar o programa
    syscall

senox:
    #f0 = x
    # Convers�o de graus para radianos
    l.s  $f1, PI        # Carrega o valor de pi em $f1
    mul.s $f0, $f0, $f1   
    l.s   $f1, _180   
    div.s $f0, $f0, $f1     
    
    l.s $f3, _1         # k = 1
    mov.s $f12, $f0     # f12 = result = x
    mov.s $f10, $f0     # f10 = termo anterior = x
    mov.s $f11, $f0     # f11 = termo atual = x
    
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
        neg.s $f17, $f17
        add.s $f6, $f5, $f17   # $f6 = 2k + 1
        mul.s $f7, $f5, $f6    # $f7 = (2k)(2k + 1)
        # termo_atual = termo_anterior * (-x^2)/[2k(2k+1)]
        mul.s $f11, $f10, $f4 
        div.s $f11, $f11, $f7

        add.s $f12, $f12, $f11
        mov.s $f10, $f11       # termo_anterior = Termo_atual  
        add.s $f3, $f3, $f17   # k++

        j loop
    saiDoLoop:
        mov.s $f1, $f12 
        jr $ra
