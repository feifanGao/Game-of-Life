# COMP1521 19t2 ... Game of Life on a NxN grid
#
# Written by <<YOU>>, June 2019

## Requires (from `boardX.s'):
# - N (word): board dimensions
# - board (byte[][]): initial board state
# - newBoard (byte[][]): next board state
	.data
msg1:	.asciiz "# Iterations: "
msg2:	.asciiz "=== After iteration "
msg3:	.asciiz " ===\n"


## Provides:
	.globl	main
	.globl	decideCell
	.globl	neighbours
	.globl	copyBackAndShow

########################################################################
# .TEXT <main>
	.text
main:

# Frame:	...
# Uses:		...
# Clobbers:	...

# Locals:	...

# Structure:
#	main
#	-> [prologue]
#	-> ...
#	-> [epilogue]

# Code:

	# Your main program code goes here.  Good luck!
	addi	$sp, $sp, -4
	sw	$fp, ($sp)	# push $fp
	la	$fp, ($sp)
	addi	$sp, $sp, -4
	sw	$ra, ($sp)	# push $ra
	addi	$sp, $sp, -4
	sw	$s0, ($sp)	# push $s0 maxiters
	addi	$sp, $sp, -4
	sw	$s1, ($sp)	# push $s1 n = 1 = s1
	addi	$sp, $sp, -4
	sw	$s2, ($sp)	# push $s2 i = 0 = s2
	addi	$sp, $sp, -4
	sw	$s3, ($sp)	# push $s3 j = 0 = s3
	addi	$sp, $sp, -4
	sw	$s4, ($sp)	# push $s4 s4 = nn = neighbours (i, j);
	addi	$sp, $sp, -4
	sw	$s5, ($sp)	# push $s5 s5 = addr od board
	addi	$sp, $sp, -4
	sw	$s6, ($sp)	# push $s6
	addi	$sp, $sp, -4 
	sw	$s7, ($sp)	# push $s7 s7 = addr of newBoard
	
	lw 		$s6, N	# s6 = N's value
	la 		$s5, board	# s5 = addr of board
	la 		$s7, newBoard # s7 = addr of newBoard

	#s0 = int maxiters;
	la		$a0, msg1
	li		$v0, 4
	syscall		# printf ("# Iterations: ");

	li		$v0, 5
	syscall			
	move	$s0, $v0 # scanf("%d", into $s0) is maxiters

main_n_init:
	li		$s1, 1		# n = 1 = s1
main_n_cond:
	bgt		$s1, $s0, main_n_f	#for (; n <= maxiters; n++)
	nop

main_i_init:
	li		$s2, 0		# i = 0 = s2
main_i_cond:
	bge		$s2, $s6, main_i_f	#for (; i < N; i++)
	nop	

main_j_init:
	li		$s3, 0		# j = 0 = s3
main_j_cond:
	bge		$s3, $s6, main_j_f	#for (; j < N; j++)
	nop	

	move	$a0, $s2		#            i
	move	$a1, $s3		#            j
	jal		neighbours	# neighbours (i, j);
	#nop
	move 	$s4, $v0	# s4 = nn = neighbours (i, j);

	mul		$t0, $s2, $s6	# % <- row(i) * N
	add		$t1, $t0, $s3	#    + col(j)
	addu	$t0, $s5, $t1	# t0 = &board[i][j]
	lb		$t4, ($t0)		# t4 = board[i][j]
	
	addu	$t1, $s7, $t1	# t1 = &newboard[i][j]
	#lb	$t1, ($t1)    
############################
	move	$a0, $t4		#   board[i][j]
	move	$a1, $s4		#   nn
	jal		decideCell		# decideCell (board[i][j], nn);
	sb		$v0, ($t1)		# 
############################	

main_j_step:
	addi	$s3, $s3, 1	# j++
	j		main_j_cond
	nop	
main_j_f:

main_i_step:
	addi	$s2, $s2, 1	# i++
	j		main_i_cond
	nop	
main_i_f:

	la		$a0, msg2
	li		$v0, 4
	syscall		# printf ("=== After iteration ")

	move 	$a0, $s1
	li		$v0, 4
	syscall		# printf ("n")

	la		$a0, msg3
	li		$v0, 4
	syscall		# printf (" ===\n")

	jal		copyBackAndShow

main_n_step:
	addi	$s1, $s1, 1	# n++
	j		main_n_cond
	nop	
main_n_f:
	
main__post:
	lw	$s7, ($sp)	# pop $s7
	addi	$sp, $sp, 4
	lw	$s6, ($sp)	# pop $s6
	addi	$sp, $sp, 4
	lw	$s5, ($sp)	# pop $s5
	addi	$sp, $sp, 4
	lw	$s4, ($sp)	# pop $s4
	addi	$sp, $sp, 4
	lw	$s3, ($sp)	# pop $s3
	addi	$sp, $sp, 4
	lw	$s2, ($sp)	# pop $s2
	addi	$sp, $sp, 4
	lw	$s1, ($sp)	# pop $s1
	addi	$sp, $sp, 4
	lw	$s0, ($sp)	# pop $s0
	addi	$sp, $sp, 4
	lw	$ra, ($sp)	# pop $ra
	addi	$sp, $sp, 4
	lw	$fp, ($sp)	# pop $fp
	addi	$sp, $sp, 4
	li $v0, 0
	jr	$ra

	# Put your other functions here

	.text
decideCell:
	addi	$sp, $sp, -4
	sw	$fp, ($sp)	# push $fp
	la	$fp, ($sp)
	addi	$sp, $sp, -4
	sw	$ra, ($sp)	# push $ra

	move	$t0, $a0 # old = t0
	move	$t5, $a1 # nn = t5
	li 		$t1, 1
	li 		$t2, 2
	li 		$t3, 3

d_out_if:    
	li 		$t4, 1
	bne 	$t0, $t4, d_out_else_if

d_in_if:
	bge $t5, $t2, d_in_else_if
	li	$v0, 0
	j 	d__post

d_in_else_if:
	bne	$t5, $t2, d_in_else_if_3	# if nn == 2 then 1
	li 	$v0, 1
	j 	d__post

d_in_else_if_3:
	bne	$t5, $t3, d_in_else	# if nn == 3 then 1 
	li 	$v0, 1
	j 	d__post

d_in_else:
	li	$v0, 0       #else ret = 0;
	j 	d__post

d_out_else_if:
	bne $t5, $t3, d_out_else
	li 	$v0, 1          # if nn == 3 then 1 
	j 	d__post

d_out_else:
	li 	$v0, 0        #else ret = 0;
d__post:
	
	lw	$ra, ($sp)	# pop $ra
	addi	$sp, $sp, 4
	lw	$fp, ($sp)	# pop $fp
	addi	$sp, $sp, 4
	jr	$ra

	.text
neighbours:
	addi	$sp, $sp, -4
	sw	$fp, ($sp)	# push $fp
	la	$fp, ($sp)
	addi	$sp, $sp, -4
	sw	$ra, ($sp)	# push $ra
	# addi	$sp, $sp, -4
	# sw	$s0, ($sp)	# push $s0 i
	# addi	$sp, $sp, -4
	# sw	$s1, ($sp)	# push $s1 j
	# addi	$sp, $sp, -4
	# sw	$s2, ($sp)	# push $s2 nn = 0
	# addi	$sp, $sp, -4
	# sw	$s3, ($sp)	# push $s3 s3 = x = -1
	# addi	$sp, $sp, -4
	# sw	$s4, ($sp)	# push $s4 s4 = y = -1
	# addi	$sp, $sp, -4
	# sw	$s5, ($sp)	# push $s5 s5 = N-1
	addi	$sp, $sp, -4
	sw	$s6, ($sp)	# push $s6 addr of board
	
	move	$t0, $a0 # i
	move	$t1, $a1 # j
	la $s6, board	# s6 = addr of board

	li 	$t2, 0 # nn = 0
	li 	$t9, 1 # t9 = 1
	lw 	$t5, N
	#move 	$t4, $s5 # t4 = N
	sub $t5, $t5, $t9 # t5 = N-1

neigh_out_loop_init:
	li	$t3, -1		# s3 = x = -1
neigh_out_loop_cond:
	bgt	$t3, $t9, neigh_out_loop_f	#  for x <= 1; x++
	nop	
neigh_in_loop_init:
	li	$t4, -1		# s4 = y = -1
neigh_in_loop_cond:
	bge	$t4, $t9, neigh_in_loop_f	#  for y <= 1; y++
	nop	

	add $t7, $t0, $t3	# t7 = i + x
	add $t8, $t1, $t4	# t8 = j + y

neigh_first_if_con1: # if (i + x < 0 	
	bgez $t7, neigh_first_if_con2	
	j 	neigh_in_loop_step	#  then continue

neigh_first_if_con2: #  || i + x > N - 1)
	ble	$t7, $t5, neigh_first_if_con3	 
	j 	neigh_in_loop_step

neigh_first_if_con3: # if (j + y < 0 
	bge	$t8, $0, neigh_first_if_con4	
	j 	neigh_in_loop_step	#  then continue

neigh_first_if_con4: #  ||j + y > N - 1)
	ble	$t8, $t5, neigh_first_if_con5	 
	j 	neigh_in_loop_step	#  then continue

neigh_first_if_con5: #	if (x == 0 && y == 0) continue;
	bnez $t3, neigh_first_if_con6
	bnez $t4, neigh_first_if_con6	
	j 	neigh_in_loop_step	#  then continue

neigh_first_if_con6:
	mul	$t6, $t7, $t4	# % <- t7 * N
	add	$t6, $t6, $t8	#    + t8[col]
	# li	$t7, 4
	# mul	$t6, $t6, $t7	#    * sizeof(word)
	addu	$t6, $s6, $t6	#    + &board[0][0]
	lb		$t6, ($t6)			#	board[i + x][j + y] = t6
	bne 	$t6, 1, neigh_in_loop_step
	addi 	$t2, $t2, 1	# nn++

neigh_in_loop_step:
	addi	$t4, $t4, 1	# y++
	j		neigh_in_loop_cond
	nop	
neigh_in_loop_f:

neigh_out_loop_step:
	addi	$t3, $t3, 1	# x++
	j		neigh_out_loop_cond
	nop	

neigh_out_loop_f:
	move $v0, $t2

	lw	$s6, ($sp)	# pop $s6
	addi	$sp, $sp, 4
	# lw	$s5, ($sp)	# pop $s5
	# addi	$sp, $sp, 4
	# lw	$s4, ($sp)	# pop $s4
	# addi	$sp, $sp, 4
	# lw	$s3, ($sp)	# pop $s3
	# addi	$sp, $sp, 4
	# lw	$s2, ($sp)	# pop $s2
	# addi	$sp, $sp, 4
	# lw	$s1, ($sp)	# pop $s1
	# addi	$sp, $sp, 4
	# lw	$s0, ($sp)	# pop $s0
	# addi	$sp, $sp, 4
	lw	$ra, ($sp)	# pop $ra
	addi	$sp, $sp, 4
	lw	$fp, ($sp)	# pop $fp
	addi	$sp, $sp, 4
	jr	$ra

	.text
copyBackAndShow:
	addi	$sp, $sp, -4
	sw	$fp, ($sp)	# push $fp
	la	$fp, ($sp)
	addi	$sp, $sp, -4
	sw	$ra, ($sp)	# push $ra

	lw $t2, N		# s2 = N's value
	la $t3, board	# s3 = addr od board
	la $t4, newBoard # s4 = addr of newBoard

copy_out_loop_init:
	li	$t0, 0		# s0 = i = 0
copy_out_loop_cond:
	bge	$t0, $t2, copy_out_loop_f	#  for (int i = 0; i < N; i++)
	nop	
copy_in_loop_init:
	li	$t1, 0		# s1 = j = 0
copy_in_loop_cond:
	bge	$t1, $t2, copy_in_loop_f	#  for (int j = 0; j < N; j++)
	nop	

	#TODO board[i][j] = newboard[i][j];
	mul	$t5, $t0, $t2	# % <- row(i) * N
	add	$t6, $t5, $t3	#    + col(j)
	addu	$t5, $t4, $t6	# = &newboard[0][0]
	lb	$t5, ($t5)

	addu $t7, $t3, $t6	# = &board[i][j]
	sb	$t5, ($t7)
	lb	$t7, ($t7)

copy_if:
	# TODO if (board[i][j] == 0)
	bnez $t7, copy_else
	li	$a0, '.'
	li	$v0, 11
	syscall			# putchar('.')

copy_else:
	li	$a0, '#'
	li	$v0, 11
	syscall			# putchar('#')

copy_in_loop_step:
	addi	$t1, $t1, 1	# j++
	j		copy_in_loop_cond
	nop	
copy_in_loop_f:

	li	$a0, '\n'
	li	$v0, 11
	syscall			# putchar('\n')

copy_out_loop_step:
	addi	$t0, $t0, 1	# i++
	j		copy_out_loop_cond
	nop	
copy_out_loop_f:

copy__epi:
	lw	$ra, ($sp)	# pop $ra
	addi	$sp, $sp, 4
	lw	$fp, ($sp)	# pop $fp
	addi	$sp, $sp, 4
	jr	$ra


