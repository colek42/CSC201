li	$s0, 1		#amount to decrement by
li	$t0, 10		#starting number
move	$a1, $t0
jal	dec


dec:
	move	$t0, $a1
	sub	$t1, $t0, $s0
	move	$a0, $t1
	jal	square



square:	
	move	$t0, $a0
	mult	$t0, $t0
	mflo	$t1		#assume result is 32-bit
	move	$a0, $t1
	move    $a1, $t0
	jal	print


print:
	li	$v0, 1		#load syscall value of 1 to display output of $a0
	syscall
	blez	$a1, end
	
	jal	dec

end:
	syscall