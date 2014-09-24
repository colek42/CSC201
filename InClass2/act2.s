# Graded activity two for CSC 201, Fall 2014
# put your name here

           .data
prompt1:   .asciiz "Enter a number (negative to quit): "   # prompt message
value:     .asciiz "The value of f = "                 # answer message
endline:   .asciiz "\n"                                # new line

           .text
main:
loop:      la    $a0, prompt1       # load the addr of prompt1 into $a0
           li    $v0, 4             # 4 is the print_string syscall
           syscall                  # print the prompt

           li    $v0, 5             # 5 is the read integer syscall
           syscall                  # read the integer, n

           blt   $v0, $zero, out    # negative number ends input and also program
           move  $a0, $v0           # put n in $a0 for function call
           jal   f                  # call function
           move  $s0, $v0           # save function value for printing

           la    $a0, value         # load the addr of value into $a0
           li    $v0, 4             # 4 is the print_string syscall
           syscall                  # print the string, "The value of f = "

           move  $a0, $s0           # put f(n) in $a0 for printing
           li    $v0, 1             # 1 is the print_int syscall
           syscall                  # print the value of f at n

           la    $a0, endline       # load the addr of endline into $a0
           li    $v0, 4             # 4 is the print_string syscall
           syscall                  # print n endline character
           j     loop               # go back and read another number

## exit the program.
out:       li    $v0, 10            # 10 is the exit program syscall
           syscall                  # exit program

# f(0) = 13, and f(n) = 2f(n-1) + n - 15 if n > 0

# Register usage
# $a0 = n
# $v0 = return value

f:
	#li	$t1, 13
	
	beq	$a0, $0, ret
	
	addi $sp, $sp -8      		# push AR onto stack
        sw   $ra, 0($sp)		# save return address on stack
        sw   $a0, 4($sp)      		# save $a0 to stack    
	        
        addi	$a0, $a0, -1
        
        jal	f
        
        lw   $ra, 0($sp)		# restore return address from stack
        lw   $a0, 4($sp)      		# restore $a0 from stack
        addi $sp, $sp 8       		# pop AR from stack
        
        li	$t2, 2       
        mul	$v0, $v0, $t2
        
        add	$v0, $v0, $a0
        
        
        addi	$v0, $v0, -15
        
        jr	$ra
        
ret:
	li	$v0, 13
	jr	$ra
		
	

