
.data
	_menu: .asciz "1- Inserir\n2- Remover\n3- Buscar\n4- Preorder\n"
	_menu.1: .asciz "5- Inorder\n6- Postorder\n7- Árvore completa\n"
	_menu.2: .asciz "8- Máximo\n9- Minímo\n0- Sair\n"
.text
	
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
	j printMenu