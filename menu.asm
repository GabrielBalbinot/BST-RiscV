.include "bst.asm"

.data
	menu: .asciz "1- Adicionar valor\n2- Remover valor\n3- Buscar valor\n4- Mostrar árvore\n5- Preorder\n6- Inorder\n7- Postorder\n0- Sair\n"

.text
	
	menu_init:
		li a7 4
		la a0 menu
		ecall
		li a7 5
		ecall
		
		beqz a0 end_menu
		j menu_init
	
	
	end_meun:
		li a7 10
		ecall