.data	
	# menus
	_menu: .asciz "1- Insert\n2- Delete\n3- Search\n4- Preorder\n"
	_menu.1: .asciz "5- Inorder\n6- Postorder\n7- Full tree\n"
	_menu.2: .asciz "8- Maximum\n9- Minimum\n0- Leave\n\n"
	
	# inputs
	_scanf: .asciz "Type a value: "
	
	# outputs
	_valueAlreadyExists_str: .asciz "This value is already on the tree\n"
	_valueNotExists: .asciz "Value not found\n"
	_valueAtAddress: .asciz "The value is at the address: "
	_maxOutput: .asciz "The max value is: "
	_minOutput: .asciz "The min value is: "
	_emptyTree: .asciz "The tree is empty\n"
	_emptyTreeOps: .asciz "Just the insert operation is available\n"
.global main
.text
main:
	addi sp sp -4
	sw s0 0(sp) # storing s0 
	mv s0 zero # initialize root = null
	
	menu:
		j printMenu
	continue_menu:
		li a7 11
		li a0 10
		ecall
		j menu
	
	end_menu:
		# restore s0 and lost the reference to root of tree
		# essentially cleaning the tree, as there is no syscall such as free 
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
	j continue_menu

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
	j continue_menu
	
delete:
	jal inputValue
	mv a1 a0
	mv a0 s0	
	
	jal deleteNode
	mv s0 a0
	j continue_menu
	
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
	j continue_menu
	
pre:
	beqz s0 emptyTree
	
	mv a0 s0
	jal preorder
	# \n
	li a7 11
	li a0 10
	ecall
	
	j continue_menu
in:
	beqz s0 emptyTree
	
	mv a0 s0
	jal inorder
	# \n
	li a7 11
	li a0 10
	ecall
	
	j continue_menu
post:
	beqz s0 emptyTree
	
	mv a0 s0
	jal postorder
	# \n
	li a7 11
	li a0 10
	ecall
	
	j continue_menu

arvoreToda:
	beqz s0 emptyTree
	
	mv a0 s0
	li a1 0 # depth = 0
	li a2 -1 # not left nor right
	li a3 1 # root
	jal printTree
	j continue_menu
	
max:
	beqz s0 emptyTree
	
	mv a0 s0
	jal findMax
	
	mv t0 a0	
	lw t1 0(t0)
	
	# print "The max value: "
	la a0 _maxOutput
	li a7 4
	ecall
	# print max value
	mv a0 t1
	li a7 1
	ecall
	# print \n
	li a0 10
	li a7 11
	ecall
	j continue_menu
	
min:
	beqz s0 emptyTree
	
	mv a0 s0
	jal findMin
	
	mv t0 a0	
	lw t1 0(t0)
	
	# print "The min value"
	la a0 _minOutput
	li a7 4
	ecall
	# print min value
	mv a0 t1
	li a7 1
	ecall
	# print \n
	li a0 10
	li a7 11
	ecall
	j continue_menu
	

emptyTree:
	
	li a7 4
	la a0 _emptyTree
	ecall
	la a0 _emptyTreeOps
	ecall	
	j continue_menu	
