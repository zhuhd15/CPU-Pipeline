main:		addi $a0, $0, 60
		addi $a1, $0, 36
		jal func
endloop:        j endloop

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