		j main
		j interrupt
		j exception
main:		lui $s1, 0x4000
		lui $sp, 0x0000
		addi $sp, $sp, 0x03FC
		lui $s2, 0x0000
		addi $t1, $0, 0x0040
		sw $t1, 0($s2)
		addi $t1, $0, 0x0079
		sw $t1, 4($s2)
		addi $t1, $0, 0x0024
		sw $t1, 8($s2)
		addi $t1, $0, 0x0030
		sw $t1, 12($s2)
		addi $t1, $0, 0x0019
		sw $t1, 16($s2)
		addi $t1, $0, 0x0012
		sw $t1, 20($s2)
		addi $t1, $0, 0x0002
		sw $t1, 24($s2)
		addi $t1, $0, 0x0078
		sw $t1, 28($s2)
		addi $t1, $0, 0x0000
		sw $t1, 32($s2)
		addi $t1, $0, 0x0010
		sw $t1, 36($s2)
		addi $t1, $0, 0x0008
		sw $t1, 40($s2)
		addi $t1, $0, 0x0003
		sw $t1, 44($s2)
		addi $t1, $0, 0x0046
		sw $t1, 48($s2)
		addi $t1, $0, 0x0021
		sw $t1, 52($s2)
		addi $t1, $0, 0x0006
		sw $t1, 56($s2)
		addi $t1, $0, 0x000E
		sw $t1, 60($s2)
		lui $t1, 0x0000
		sw $t1, 8($s1)
		lui $t2, 0x0000
		addi $t2, $t1, 0xff80
		sw $t2, 0($s1)
		lui $t1, 0x0000
		addi $t1, $t1, 0xffff
		sw $t1, 4($s1)
		lui $t1, 0x0000
		addi $t1, $t1, 0x0003
		sw $t1, 8($s1)
		lui $t2, 0x0000
		addi $t2, $t2, 0x0013
		sw $t2, 32($s1)
IOloop:		lw $t2, 32($s1)
		andi $t1, $t2, 0x0008
		beq $t1, $0, IOloop
		lw $s5, 28($s1)
IOloop2:	lw $t2, 32($s1)
		andi $t1, $t2, 0x0008
		beq $t1, $0, IOloop2
		lw $s6, 28($s1)
		add $a0, $0, $s5
		add $a1, $0, $s6
		jal func
		sw $v0, 24($s1)
		sw $v0, 12($s1)
endloop:	j endloop
func:		slt $t1, $a0, $a1
		beq $t1, $0, loop1
		add $t2, $0, $a1
		add $a1, $0, $a0
		add $a0, $0, $t2
loop1:		beq $a1, $0, exit1
loop2:		slt $t1, $a0, $a1
		bne $t1, $0, exit2
		sub $a0, $a0, $a1
		j loop2
exit2:		add $t2, $0, $a1
		add $a1, $0, $a0
		add $a0, $0, $t2
		j loop1 
exit1:		add $v0, $0, $a0
		jr $ra
interrupt:	addi $sp, $sp, -12
		sw $t1, 0($sp)
		sw $t2, 4($sp)
		sw $t3, 8($sp)
		lui $t1, 0x0000
		addi $t1, $t1, 0x0001
		sw $t1, 8($s1)

		andi $t1, $s5, 0x000F
		sll $t1, $t1, 2
		add $t2, $t1, $s2
		lw $t3, 0($t2)
		addi $t3, $t3, 0x0100
		sw $t3, 20($s1)

		andi $t1, $s5, 0x00F0
		srl $t1, $t1, 2
		add $t2, $t1, $s2
		lw $t3, 0($t2)
		addi $t3, $t3, 0x0200
		sw $t3, 20($s1)

		andi $t1, $s6, 0x000F
		sll $t1, $t1, 2
		add $t2, $t1, $s2
		lw $t3, 0($t2)
		addi $t3, $t3, 0x0400
		sw $t3, 20($s1)

		andi $t1, $s6, 0x00F0
		srl $t1, $t1, 2
		add $t2, $t1, $s2
		lw $t3, 0($t2)
		addi $t3, $t3, 0x0800
		sw $t3, 20($s1)

		sll $0, $0, 0
		sll $0, $0, 0
		sll $0, $0, 0
		sll $0, $0, 0
		lui $t1, 0x0000
		sw $t1, 20($s1)

		lui $t2, 0x0000
		addi $t2, $t2, 0x0003
		sw $t2, 8($s1)
		lw $t3, 8($sp)
		lw $t2, 4($sp)
		lw $t1, 0($sp)
		addi $sp, $sp, 12
		jr $k0
exception:	jr $k0