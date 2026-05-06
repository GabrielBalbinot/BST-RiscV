.data	
	# menus
	_menu: .asciz "1- Inserir\n2- Remover\n3- Buscar\n4- Preorder\n"
	_menu.1: .asciz "5- Inorder\n6- Postorder\n7- Árvore completa\n"
	_menu.2: .asciz "8- Máximo\n9- Minímo\n0- Sair\n"
	
	# inputs
	_scanf: .asciz "Digite um valor: "
	
	# outputs
	_valueAlreadyExists_str: .asciz "Este valor já está presente na árvore\n"
	_valueNotExists: .asciz "Valor não encontrado\n"
	_valueAtAddress: .asciz "O valor está no endereço: "
	_maxOutput: .asciz "O maior valor é: "
	_minOutput: .asciz "O menor valor é: "
	_arvoreVazia: .asciz "A árvore está vazia. "
	_arvoreVaziaOps: .asciz "Apenas a operação de inserir está disponível\n"
.global main
.text
main:
	addi sp sp -4
	sw s0 0(sp) # armazenando s0 
	mv s0 zero # inicializa o root
	
	menu:
		j printMenu
	
	
	end_menu:
		# além de restaurar s0, perdemos a referência do root da árvore
		# desta forma "limpando" todos os dados da árvore
		lw s0 0(sp) 
		addi sp sp 4
		li a7 10
		ecall
		
printMenu:
		li a7 4
		la a0 _menu
		ecall
		la a0 _menu.1
		ecall
		la a0 _menu.2
		ecall
		
inputMenu:

	li a7 5
	ecall
	
	beqz a0 end_menu
	
	li t6 1
	beq a0 t6 insert
	
	li t6 2
	beq a0 t6 delete
	
	li t6 3
	beq a0 t6 search
	
	li t6 4
	beq a0 t6 pre
	
	li t6 5
	beq a0 t6 in
	
	li t6 6
	beq a0 t6 post
	
	li t6 7
	beq a0 t6 arvoreToda
	
	li t6 8
	beq a0 t6 max
	
	li t6 9
	beq a0 t6 min
	j menu

inputValue:
	la a0 _scanf
	li a7 4
	ecall
	li a7 5
	ecall
	jr ra	

insert:
	jal inputValue
	mv a1 a0
	mv a0 s0
	jal searchNode
	
	bnez a0 valueExists
	mv a0 s0
	
	jal insertNode
	
	mv s0 a0
	j end_insert_	
	
	valueExists:
	la a0 _valueAlreadyExists_str
	li a7 4
	ecall	
	
	end_insert_:
	j menu
	
delete:
	jal inputValue
	mv a1 a0
	mv a0 s0	
	
	jal deleteNode
	mv s0 a0
	j menu
	
search:
	jal inputValue
	mv a1 a0
	mv a0 s0
	jal searchNode
	
	beqz a0 value_not_found
	value_found:
	
	mv t0 a0
	la a0 _valueAtAddress
	li a7 4
	ecall
	mv a0 t0
	li a7 34
	ecall
	
	li a0 10
	li a7 11
	ecall
	j end_search	
	
	value_not_found:
	la a0 _valueNotExists
	li a7 4
	ecall
	
	end_search:
	j menu
	
pre:
	beqz s0 arvoreVazia
	
	mv a0 s0
	jal preorder
	j menu
in:
	beqz s0 arvoreVazia
	
	mv a0 s0
	jal inorder
	j menu
post:
	beqz s0 arvoreVazia
	
	mv a0 s0
	jal postorder
	j menu

arvoreToda:
	beqz s0 arvoreVazia
	
	mv a0 s0
	li a1 0 # profundidade = 0
	li a2 -1 # nem esq nem dir
	li a3 1 # root
	jal printTree
	j menu
	
max:
	beqz s0 arvoreVazia
	
	mv a0 s0
	jal findMax
	
	mv t0 a0	
	lw t1 0(t0)
	
	# print "O maior valor: "
	la a0 _maxOutput
	li a7 4
	ecall
	# print do maior valor
	mv a0 t1
	li a7 1
	ecall
	# print \n
	li a0 10
	li a7 11
	ecall
	j menu
	
min:
	beqz s0 arvoreVazia
	
	mv a0 s0
	jal findMin
	
	mv t0 a0	
	lw t1 0(t0)
	
	# print "O menor valor"
	la a0 _minOutput
	li a7 4
	ecall
	# print do menor valor
	mv a0 t1
	li a7 1
	ecall
	# print \n
	li a0 10
	li a7 11
	ecall
	j menu
	

arvoreVazia:
	
	li a7 4
	la a0 _arvoreVazia
	ecall
	la a0 _arvoreVaziaOps
	ecall	
	j menu	
