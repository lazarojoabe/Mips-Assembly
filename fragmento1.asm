#		CÓDIGO EM C:
#int expo1(int x, int n){
#   int result = 1;
#   while (n>0){
#      result *= x;
#      n--;
#   }
#   return result;
# }

.data
#$a0 = x, $a1 = n
result: .word 1

.text
main:
	li $a0, 2 # x = 2
	li $a1, 7 # n = 7
	jal expo1 #chamando a função expo1( ) 	
	
	#printando o resultado: 
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10           # Chamada do sistema para finalizar o programa
	syscall

.text
expo1: 
	lw $t0, result #carregando o valor incial de result para $t0
	
	loop: 
		blez $a1, saiDoLoop # se n <= 0, ele não entra no loop
		mul $t0, $t0, $a0 #result = result * x
		addi $a1, $a1, -1 # n = n -1 => n--
		j loop # volta a fazer a verificação do loop
		
	saiDoLoop:
		move $v0, $t0
		jr $ra
	
