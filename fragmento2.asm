#	C�DIGO EM C:
#int expo2(int x, int n){
#  int result = 1;
#  while (n){
# 	if (n%2==1){
# 	  result *= x;
# 	}
# 	n /= 2;
# 	x *= x;
#  }
#  return result;
#}

.data
result: .word 1   # Vari�vel para armazenar o resultado

.text
main:
    li $a0, 3       # x = 2
    li $a1, 9       # n = 7
    
    jal expo2       # Chama a fun��o expo2
    
    move $a0, $v0  # Move o resultado para o argumento $a0 para impress�o
    
    li $v0, 1      # Chamada do sistema para imprimir o valor
    syscall
    
    li $v0, 10     # Chamada do sistema para finalizar o programa
    syscall
    
expo2:
    lw $t0, result  

loop:
    blez $a1, saiDoLoop  # Verifica se n <= 0, se verdadeiro, sai do loop
    
    andi $t1, $a1, 1     # Verifica se n � �mpar
    
    bgt $t1, $zero, multipX  # Se n � �mpar, multiplica
    
    srl $a1, $a1, 1      # Divide n por 2
    mul $a0, $a0, $a0    # x = x * x
    
    j loop
    
multipX:
    mul $t0, $t0, $a0    # result *= x
    srl $a1, $a1, 1       # Divide n por 2
    mul $a0, $a0, $a0     # x *= x
    
    j loop

saiDoLoop:
    move $v0, $t0   # Move o resultado para o registrador de retorno $v0
    jr $ra          # Retorna
