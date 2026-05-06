.global insertNode
.global searchNode
.global deleteNode
.global findMax
.global findMin
.global printTree
.global preorder
.global inorder
.global postorder
.data
	# prefixos para impress o da  rvore
	
	# caso os símbolos não funcionem corretamente (?)
	# utilize o padrão abaixo comentado	
	#.P1: .asciz "├── "
	#.P2: .asciz "└── "	
	.P1: .asciz "|-- "
	.P2: .asciz "`-- "	
.text
createNode:
	# a1 = valor a ser incluído
	li a7 9 # sbrk (malloc)
	li a0 12 # 12 bytes (3 words): valor, left, right
	ecall
	sw a1 0(a0)
	sw zero 4(a0)
	sw zero 8(a0)
	jr ra
	
insertNode:
	# a0 = node
	# a1 valor a ser inserido
	addi sp sp -8
	sw ra 0(sp)
	sw a0 4(sp)	
	
	beqz a0 first_node
	lw t0 0(a0) # t0 = node->val

	bge a1 t0 right_insert
	left_insert:
		lw a0 4(a0) # load do left
		jal insertNode
		lw t1 4(sp)
		sw a0 4(t1)
		j end_insert
	right_insert:
		lw a0 8(a0) # load do right
		jal insertNode
		lw t1 4(sp)
		sw a0 8(t1)
		j end_insert
	first_node:
	# ocorre apenas ao inserir o primeiro valor (root)
		jal createNode
	
	end_insert:
		lw t1 4(sp) # não lembro o que faz aqui...
		beqz t1 return_insert
		mv a0 t1
	return_insert:
		lw ra 0(sp)			
		addi sp sp 8
		jr ra

deleteNode:
    # a0 = node, a1 = valor a deletar
    addi sp sp -8
    sw   ra 0(sp)
    sw   a0 4(sp)

    beqz a0 return_del    # root null, valor inexistente

    lw   t0 0(a0)         # node->val
    blt  a1 t0 del_left
    bgt  a1 t0 del_right

    # encontrou o node
    lw   t1 4(a0)         # left
    lw   t2 8(a0)         # right

    # caso 1: folha
    bnez t1 tem_esq
    bnez t2 tem_dir
    li   a0 0             # retorna null pro node
    j    return_del

    # caso 2.1: apenas filho direito
	tem_dir:
    	beqz t1 so_direito

    # caso 2.2: apenas filho esquerdo
	tem_esq:
	    beqz t2 so_esquerdo

    # caso 3: dois filhos = achar sucessor (menor da subarvore direita)
	dois_filhos:
    	lw   t3 8(a0)         # t3 = subarvore direita
	find_min:
    	lw   t4 4(t3)         # t4 = left do candidato
    	beqz t4 achou_min
    	mv   t3 t4
    	j    find_min
	achou_min:
    	lw   t4 0(t3)         # t4 = valor do sucessor
    	lw   t5 4(sp)         # restaura node atual
    	sw   t4 0(t5)         # substitui valor pelo sucessor

    # deleta o sucessor na subarvore direita
    lw   a0 8(t5)         # a0 = subarvore direita
    mv   a1 t4            # a1 = valor do sucessor
    jal  deleteNode
    lw   t5 4(sp)         # restaura node atual
    sw   a0 8(t5)         # atualiza filho direito
    mv   a0 t5            # retorna node atual
    j    return_del

	so_direito:
    	mv   a0 t2            # retorna filho direito pro node
	    j    return_del

	so_esquerdo:
    	mv   a0 t1            # retorna filho esquerdo pro node
    	j    return_del

	del_left:
    	lw   a0 4(a0)
    	jal  deleteNode
    	lw   t1 4(sp)
    	sw   a0 4(t1)         # node->left = retorno
    	mv   a0 t1
    	j    return_del

	del_right:
    	lw   a0 8(a0)
    	jal deleteNode
    	lw   t1 4(sp)
    	sw   a0 8(t1)         # node->right = retorno
    	mv   a0 t1

	return_del:
    	lw   ra 0(sp)
    	addi sp sp 8
    	jr   ra

searchNode:
	# a0 o root e nodes subsequentes
	# a1 o valor a ser buscado
	# a0 ser  o endere o de retorno, se for 0, então não existe
	addi sp sp -4
	sw ra 0(sp)
	beqz a0 return_search	
	lw t0 0(a0)	
	beq a1 t0 return_search
	
	bgt a1 t0 search_right
	search_left:
		lw a0 4(a0)
		j search_next
	search_right:
		lw a0 8(a0)
	search_next: 
		jal searchNode	
	return_search:
		lw ra 0(sp)
		addi sp sp 4
		jr ra	

findMax:
	addi sp sp -4
	sw ra 0(sp)
	
	# if node == null || node->right == null
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
	
	# if node == null || node->left == null
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
	beqz a0 return_print_node
	
	li a7 1
	mv t1 a0 # endereço do node
	lw a0 0(a0) # node->value
	ecall
	li a7 11
	li a0 32
	ecall
	mv a0 t1
	return_print_node:
	jr ra
	
printTree:
	# a0 = node
	# a1 = profundidade
	# a2 = esquerda ou direita (0 ou 1, respectivamente)
	# a3 = raiz? (0 ou 1)
	
	addi sp sp -12
	sw ra 0(sp)
	sw a0 4(sp)
	sw a1 8(sp)
	
	beqz a0 printTree_ret
	beqz a3 not_root
	jal print_node
	li a0 10
	li a7 11
	ecall
	
	j printTree_nextNodes
	
	not_root:
	mv t0 a0
	li t2 0 # contador
	mv t3 a1 # profundidade
	
	print_spaces:
		li a0 32
		li a7 11
		beq t2 t3 end_print_spaces
		ecall
		ecall
		ecall
		addi t2 t2 1
		j print_spaces	
	end_print_spaces:
	
	bnez a2 print_P2
	
	print_P1:
		la a0 .P1
		li a7 4
		ecall
		j post_Ps
		
	print_P2:			
		la a0 .P2
		li a7 4
		ecall
		
	post_Ps:
	mv a0 t0
	jal print_node
	li a0 10
	li a7 11
	ecall
	
	printTree_nextNodes:	
	# carregar os valores necessários para acessar o lado esquerdo da árvore
		lw a0 4(sp) # node
		lw a1 8(sp) # profundidade
		addi a1 a1 1 # profunidade++
		li a2 0
		li a3 0
		lw a0 4(a0) # node->left
		jal printTree
	
		lw a0 4(sp)
		lw a1 8(sp)
		addi a1 a1 1
		li a2 1
		li a3 0
		lw a0 8(a0) # node->right
		jal printTree
		
	printTree_ret:
		lw ra 0(sp)
		lw a0 4(sp)
		lw a1 8(sp)
		addi sp sp 12
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
