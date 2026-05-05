.global createNode
.global insertNode
.global searchNode
.global findMax
.global findMin
.global preorder
.global inorder
.global postorder
.global main
.data
	nums: .word 49 13 85 90 88 37 12 199
	size: .word 8
	solicitar_valor: .asciz "Digite um valor para buscar: "
.text

main:
	
	la s1 nums
	la s2 size
	lw s2 0(s2)
	li t4 0 # i
	li a0 0
	for:
		beq s2 t4 end_for
		slli t5 t4 2
		add t5 t5 s1
		lw t5 0(t5)
		mv a1 t5
		jal insertNode
		addi t4 t4 1
		j for
	end_for:
	
	mv s0 a0 # ponteiro do head
	
	# solicitar valor
	li a7 4
	la a0 solicitar_valor
	ecall
	li a7 5
	ecall
	
	mv a1 a0
	mv a0 s0
	jal searchNode	
	beqz a0 end_search				
	lw t0 0(a0)
	
	li a7 1
	mv a0 t0
	ecall
	li a7 11
	li a0 10
	ecall
	end_search:
	mv a0 s0
	jal findMin
	
	beqz a0 end_program
	jal print_node
	
	mv a0 s0
	jal findMax
	
	beqz a0 end_program
	jal print_node
	
	
	j end_program


createNode:
	# a1 é o valor a ser adicionado
	li a7 9 # sbrk (malloc)
	li a0 12 # 12 bytes: valor, left, right
	ecall
	sw a1 0(a0)
	sw zero 4(a0)
	sw zero 8(a0)
	jr ra
	
insertNode:
	# a0 endereço do node
	# a1 valor a ser inserido
	addi sp sp -8
	sw ra 0(sp)
	sw a0 4(sp)	
	
	beqz a0 nodeNull
	lw t0 0(a0) # t0 é o valor do node

	bge a1 t0 right
	left:
		lw a0 4(a0) # load do left
		jal insertNode
		lw t1 4(sp)
		sw a0 4(t1)
		j end
	right:
		lw a0 8(a0) # load do right
		jal insertNode
		lw t1 4(sp)
		sw a0 8(t1)
		j end
	nodeNull:
	# só ocorre na inserção do primeiro valor (head)
		jal createNode
		j end
	
	end:
		lw t1 4(sp)
		beqz t1 return_insert
		mv a0 t1
	return_insert:
		lw ra 0(sp)			
		addi sp sp 8
		jr ra

deleteNode:
	# a1 valor a ser deletado
	# a0 endereço do nó
	addi sp sp -8
	sw ra 0(sp)
	sw a0 4(sp)
	
	beqz a0 return_delete
	
	lw t0 0(a0)
	
	bne t0 a1 neq # not equal
	
	# a fazer deleção em três casos:
	# 1. node é folha (return null)
	# 2. node tem só um filho (este filho vira o node)
	# 3. node tem dois filhos (achar o menor da esquerda e "promover")
	# 3.. pode apenas alterar o valor do node atual e excluir o antigo que era o min
	lw t1 4(a0)
	lw t2 8(a0)
	
	
	neq:
		bgt t0 a1 right_delete
		
	left_delete:
		lw a0 4(sp)
		jal deleteNode
		j return_delete
		
	right_delete:
		lw a0 8(sp)
		jal deleteNote
		j return_delete	
		
	return_delete:
		lw ra 0(sp)
		addi sp sp 8
		jr ra

end_program:
	li a7 10
	ecall
	
searchNode:

	addi sp sp -4
	sw ra 0(sp)
	beqz a0 return_search	
	lw t0 0(a0)	
	beq a1 t0 return_search
	
	bgt a1 t0 search_right
	search_left:
		lw a0 4(a0)
		j recursion
	search_right:
		lw a0 8(a0)
	recursion:
		jal searchNode	
	return_search:
	lw ra 0(sp)
	addi sp sp 4
	jr ra	

findMax:

	addi sp sp -4
	sw ra 0(sp)

	beqz a0 end_findMax	
	lw t0 8(a0)
	beqz t0 end_findMax
	
	mv a0 t0
	jal findMax	
	end_findMax:
		lw ra 0(sp)
		addi sp sp 4
		jr ra
		
findMin:

	addi sp sp -4
	sw ra 0(sp)

	beqz a0 end_findMin	
	lw t0 4(a0)
	beqz t0 end_findMin
	
	mv a0 t0
	jal findMin	
	end_findMin:
		lw ra 0(sp)
		addi sp sp 4
		jr ra

print_node:
	beqz a0 return_print
	
	li a7 1
	mv t1 a0 # endereço do node
	lw a0 0(a0) # node->value
	ecall
	li a7 11
	li a0 32
	ecall
	mv a0 t1
	return_print:
	jr ra
	
preorder:
	
	addi sp sp -8
	sw ra 0(sp)
	sw a0 4(sp)	
	
	beqz a0 return_pre
	jal print_node
	
	lw a0 4(sp)
	lw a0 4(a0)
	jal preorder
	
	lw a0 4(sp)
	lw a0 8(a0)
	jal preorder	
	
	return_pre:
		lw ra 0(sp)
		lw a0 4(sp)
		addi sp sp 8
		jr ra	
	
	
inorder:
	
	addi sp sp -8
	sw ra 0(sp)
	sw a0 4(sp)	
	
	beqz a0 return_in
	
	lw a0 4(sp)
	lw a0 4(a0)
	jal inorder
	
	lw a0 4(sp)
	jal print_node
	# erro aqui: se node for null (0) tenta acessar endereço "proibido"
	lw a0 4(sp)
	lw a0 8(a0)
	jal inorder	
	
	return_in:
		lw ra 0(sp)
		lw a0 4(sp)
		addi sp sp 8
		jr ra
		
postorder:
	
	addi sp sp -8
	sw ra 0(sp)
	sw a0 4(sp)	
	
	beqz a0 return_post
	
	lw a0 4(sp)
	lw a0 4(a0)
	jal postorder
	
	lw a0 4(sp)
	lw a0 8(a0)
	jal postorder
	lw a0 4(sp)
	jal print_node
	
	return_post:
		lw ra 0(sp)
		lw a0 4(sp)
		addi sp sp 8
		jr ra
	
	
	
	
