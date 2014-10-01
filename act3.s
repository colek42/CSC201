# Graded activity three for CSC 201, Fall 2014

# Name:  Nicholas Kennedy

# Register usage:
#   $a0 = 10000000 (hex) - the base address of the array
#   $a1 = $v0 = the number of non-negative integers read into the array

         .data
         .align 2
prompt:  .asciiz "\nEnter non-negative integers (negative to quit) "
newline: .asciiz "\n"
         .text
         .globl main
main:

# See section 6.4.5 (pages 320 - 322) of (Harris & Harris, 2nd ed)
# or chapter 4 of Britton for printing and reading using syscall.

# print the prompt messages
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt      # $a0 = address of first prompt
         syscall               # print first prompt
# Main program - calls read, act4, and print functions
         li   $a0, 0x10000000  # $a0 = base address of array = 10000000 (hex)
         jal  reada            # read numbers into array
         move $a1, $v0         # $a1 = number of ints read, send to print proc
         jal  act3             # call the function you are to write
         jal  printa           # print numbers from array to screen
# Call system exit
         li   $v0, 10          # $v0 = exit system call code
         syscall               # halt program execution

# Algorithm for reading numbers into an array
reada:   move $t0, $a0         # $t0 = base address of array
         move $t1, $zero       # $t1 = counter = 0
read:    li   $v0, 5           # $v0 = read_int system call code
         syscall               # read an integer - n
         slt  $t2, $v0, $zero  # if n < 0 then stop reading
         bne  $t2, $zero, exit # exit procedure and return to caller
         sw   $v0, 0($t0)      # a[i] = n
         addi $t1, $t1, 1      # i = i + 1
         addi $t0, $t0, 4      # $t0 = address of a[i + 1]
         j    read             # go back up and read another integer
exit:    move $v0, $t1         # return number of integers read into array
         jr   $ra              # return to calling routine

# Algorithm for printing numbers from an array
printa:  move $t0, $a0         # $t0 = base address of array
         move $t1, $zero       # $t1 = counter = 0
print:   beq  $t1, $a1, exitp  # if (array index = array size), then exit
         lw   $t2, 0($t0)      # $t2 = a[i]
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, newline     # $a0 = address of newline character
         syscall               # print new line
         li   $v0, 1           # $v0 = print_int system call code
         move $a0, $t2         # $a0 = a[i]
         syscall               # print a[i]
         addi $t1, $t1, 1      # i = i + 1
         addi $t0, $t0, 4      # $t0 = address of a[i + 1]
         j    print            # go back up and print another integer
exitp:   li   $v0, 4           # $v0 = print_string system call code
         la   $a0, newline     # $a0 = address of newline character
         syscall               # print new line
         jr   $ra

# Algorithm you are to write for activity three (act3)
 
# i = 0, j = n-1
# while (i < j)
#   exchange(a[i], a[j])
#   i = i+1, j = j-1

# Register usage
# $a0 = base address of array a (i.e. address of a[0])
# $a1 = n (size of array)
# $t0 = i
# $t1 = j
# $t2 = 4i and address of a[i] (double duty)
# $t3 = 4j and address of a[j] (double duty)
# $t4 = a[i] before exchange
# $t5 = a[j] before exchange

act3:   

li 	$t0, 0
subi 	$t1, $a1, 1


loop:
sll	$t2, $t0, 2
sll	$t3, $t1, 2
add	$t2, $t2, $a0
add	$t3, $t3, $a0
lw	$t4, 0($t2)
lw	$t5, 0($t3)

sw	$t5, 0($t2)
sw	$t4, 0($t3)

addi	$t0, $t0, 1
subi	$t1, $t1, 1

blt	$t0, $t1, loop

jr	$ra




