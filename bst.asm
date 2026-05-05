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
	nums: .word 37 5 13 85 90 88 0 110
	size: .word 8
	prefix_str: .space 256
	solicitar_valor: .asciz "Digite um valor para buscar: "
	
	# prefixos para impressão de árvore
	.P1: .asciz "|-- "
	.P2: .asciz "+-- "
	.P3: .asciz "|" 
	.P4: .asciz " "
	
	
.text

j main

printTree:
	# a0 é o nó
	# a1 é a profundidade
	# a2 diz se é esquerda ou direita (0, 1)
	# a3 diz se é raiz ou não
	
	addi sp sp -12
	sw ra 0(sp)
	sw a0 4(sp)
	sw a1 8(sp)
	
	beqz a0 print_tree_ret
	beqz a3 not_root
	jal print_node
	li a0 10
	li a7 11
	ecall
	j rec
	
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
		bnez a2 print_dir
		print_esq:
		la a0 .P1
		li a7 4
		ecall
		j .end
		print_dir:			
		la a0 .P2
		li a7 4
		ecall
	.end:
	mv a0 t0
	jal print_node
	li a0 10
	li a7 11
	ecall
	rec:
	lw a0 4(sp)
	lw a1 8(sp)
	addi a1 a1 1
	li a2 0
	li a3 0
	lw a0 4(a0) # esq
	jal printTree
	
	lw a0 4(sp)
	lw a1 8(sp)
	addi a1 a1 1
	li a2 1
	li a3 0
	lw a0 8(a0) # dir
	jal printTree
	
	
	
	print_tree_ret:
	lw ra 0(sp)
	lw a0 4(sp)
	lw a1 8(sp)
	addi sp sp 12
	jr ra

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
	#li a7 4
#	la a0 solicitar_valor
#	ecall
##	li a7 5
#	ecall
#	mv a1 a0
#	mv a0 s0
#	jal delete_node
#	
#	mv s0 a0
#	
#	jal preorder
#	jal inorder
#	jal postorder		
	mv a0 s0
	li a1 0
	li a2 0
	li a3 1
	jal printTree
	j end_program


createNode:
	# a1 é o valor a ser adicionado
	li a7 9 # sbrk (malloc)
	li a0 12 # 12 bytes (3 words): valor, left, right
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
	
	beqz a0 first_node
	lw t0 0(a0) # t0 é o valor do node

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
	# só ocorre na inserção do primeiro valor (head)
		jal createNode
		j end_insert
	
	end_insert:
		lw t1 4(sp)
		beqz t1 return_insert
		mv a0 t1
	return_insert:
		lw ra 0(sp)			
		addi sp sp 8
		jr ra

delete_node:
    # a0 = nó atual, a1 = valor a deletar
    addi sp, sp, -8
    sw   ra, 0(sp)
    sw   a0, 4(sp)

    beqz a0, return_del    # nó null, não encontrou

    lw   t0, 0(a0)         # valor do nó atual
    blt  a1, t0, del_left
    bgt  a1, t0, del_right

    # encontrou o nó
    lw   t1, 4(a0)         # left
    lw   t2, 8(a0)         # right

    # caso 1: folha
    bnez t1, tem_esq
    bnez t2, tem_dir
    li   a0, 0             # retorna null pro pai
    j    return_del

    # caso 2: só filho direito
tem_dir:
    beqz t1, so_direito

    # caso 2: só filho esquerdo
tem_esq:
    beqz t2, so_esquerdo

    # caso 3: dois filhos — acha sucessor (menor da subárvore direita)
dois_filhos:
    lw   t3, 8(a0)         # t3 = subárvore direita
find_min:
    lw   t4, 4(t3)         # t4 = left do candidato
    beqz t4, achou_min
    mv   t3, t4
    j    find_min
achou_min:
    lw   t4, 0(t3)         # t4 = valor do sucessor
    lw   t5, 4(sp)         # restaura nó atual
    sw   t4, 0(t5)         # substitui valor pelo sucessor

    # deleta o sucessor na subárvore direita
    lw   a0, 8(t5)         # a0 = subárvore direita
    mv   a1, t4            # a1 = valor do sucessor
    jal  ra, delete_node
    lw   t5, 4(sp)         # restaura nó atual
    sw   a0, 8(t5)         # atualiza filho direito
    mv   a0, t5            # retorna nó atual
    j    return_del

so_direito:
    mv   a0, t2            # retorna filho direito pro pai
    j    return_del

so_esquerdo:
    mv   a0, t1            # retorna filho esquerdo pro pai
    j    return_del

del_left:
    lw   a0, 4(a0)
    jal  ra, delete_node
    lw   t1, 4(sp)
    sw   a0, 4(t1)         # pai.left = retorno
    mv   a0, t1
    j    return_del

del_right:
    lw   a0, 8(a0)
    jal  ra, delete_node
    lw   t1, 4(sp)
    sw   a0, 8(t1)         # pai.right = retorno
    mv   a0, t1

return_del:
    lw   ra, 0(sp)
    addi sp, sp, 8
    jr   ra

end_program:
	li a7 10
	ecall
	
searchNode:
	# searchNode é a função de busca
	# search_node é uma label para facilitar o direcionamento
	# e compreensão do código
	
	addi sp sp -4
	sw ra 0(sp)
	beqz a0 return_search	
	lw t0 0(a0)	
	beq a1 t0 return_search
	
	bgt a1 t0 search_right
	search_left:
		lw a0 4(a0)
		j search_node
	search_right:
		lw a0 8(a0)
	search_node: 
		jal searchNode	
	return_search:
		lw ra 0(sp)
		addi sp sp 4
		jr ra	

findMax:
	# empurra o valor de ra para stack
	addi sp sp -4
	sw ra 0(sp)
	
	# caso o nó ou o valor ou o endereço da direita sejam iguais a zero, achamos o maior valor da árvore
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
	# empurra o valor de ra para stack
	addi sp sp -4
	sw ra 0(sp)
	
	# caso o nó ou o valor ou o endereço da esquerda sejam iguais a zero, achamos o maior valor da árvore
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
	

	
