
.data
	_menu: .asciz "1- Inserir\n2- Remover\n3- Buscar\n4- Preorder\n"
	_menu.1: .asciz "5- Inorder\n6- Postorder\n7- Árvore completa\n"
	_menu.2: .asciz "8- Máximo\n9- Minímo\n0- Sair\n"
.text
	
	addi sp sp -4
	sw s0 0(sp) # armazenando s0 
	
	
	menu:
		j printMenu
	
	
	end_menu:
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
	beq a0 t6 preorder
	
	li t6 5
	beq a0 t6 inorder
	
	li t6 6
	beq a0 t6 postorder
	
	li t6 7
	beq a0 t6 arvoreToda
	
	li t6 7
	beq a0 t6 max
	
	li t6 7
	beq a0 t6 min
	
	
	j printMenu

