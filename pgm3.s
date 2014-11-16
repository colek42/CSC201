# COURSE:     CSC 201
# ASSIGNMENT: 3
# STUDENT:    Nicholas J Kennedy
# INSTRUCTOR: Dr. V. Dwight House
# DATE DUE:   Sunday, November 16, 2014, by noon
# PURPOSE:    To read entries of a square confusion matrix and find the number of matches and errors.
# INPUT:      A file of integers, one per line, terminated by zero. The first number will be
#             positive. Input is from stdin (standard input).
# OUTPUT:     The output is a message giving the number of matches and errors.
#             sum. Output is to stdout (standard output).

         .data
         .align 2
prompt1: .asciiz "\n\nThis program reads a list of integers into a matrix,"
prompt2: .asciiz "\nand then checks for confusion in machine learning."
prompt3: .asciiz "\n\nEnter the size of matrix (zero to quit): "
answer1: .asciiz "\nThe number of matches is: "
answer2: .asciiz "\nThe number of errors is: "
         .text
         .globl main
main:    
# print the prompt messages      See appendix B of P&H or chapter 4 of Britton
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt1     # $a0 = address of first prompt
         syscall               # print first prompt
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt2     # $a0 = address of second prompt
         syscall               # print second prompt

# Main program - calls read and sum functions
mloop:   li   $v0, 4           # $v0 = print_string system call code
         la   $a0, prompt3     # $a0 = address of third prompt
         syscall               # print third prompt

         li   $v0, 5           # $v0 = read_int system call code
         syscall               # read an integer - n
         move $a1, $v0         # $a1 = size of matrix
         beq  $v0, $zero, done # exit program

         li   $a0, 0x10000000  # $a0 = base address of matrix = 10000000 (hex)
         jal  reada            # read numbers into array - no prompts
         jal  process          # find number of matches and errors
         move $s0, $v0         # save return value

# Print the the results
         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, answer1     # $a0 = address of first answer
         syscall               # print "The number of matches is: "

         li   $v0, 1           # $v0 = print_int system call code
         move $a0, $s0         # $a0 = number of matches
         syscall               # print number of matches

         li   $v0, 4           # $v0 = print_string system call code
         la   $a0, answer2     # $a0 = address of second answer
         syscall               # print "The number of errors is: "

         li   $v0, 1           # $v0 = print_int system call code
         move $a0, $v1         # $a0 = number of errors
         syscall               # print number of errors

         b    mloop            # go back up and get another matrix

# Call system exit
done:    li   $v0, 10          # $v0 = exit system call code
         syscall               # halt program execution
# end of Main program ------------------------------------------------------

# Algorithm for reading numbers into a "matrix" (actually a one dim-array)
reada:   move $t0, $a0         # $t0 = base address of matrix
         mul  $t1, $a1, $a1    # $t2 = total number of elements in matrix (n*n)
         sll  $t1, $t1, 2      # $t1 = 4*n*n
         add  $t1, $t1, $t0    # $t1 = address at end matrix (or array)
loop:    beq  $t1, $t0, out    # if all numbers have been read exit routine
         li   $v0, 5           # $v0 = read_int system call code
         syscall               # read an integer
         sw   $v0, 0($t0)      # store number just read into array
         addi $t0, $t0, 4      # increment address by 4
         b    loop             # branch back and test before reading next number
out:     jr   $ra              # return to main routine
# end of read routine ------------------------------------------------------

# Algorithm for finding the row sums

# match = error = 0
# for i = 0 .. n-1
#   for i = 1 .. n-1
#     if (i == j)
#       match = match + a[i,j]
#     else
#       error = error + a[i,j]
#     endif
#   end for j
# end for i
# return match, error

# Register usage
# $a0 = base address of array (matrix), a
# $a1 = n, size of matrix (number of rows and columns)
# $v0 = match
# $v1 = error
# $t0 = i
# $t1 = j
# $t2 = a[i,j]
# $t3 = address of a[i,j]
# $t4 = temp1
# $t5 = temp2

process:  and $v0,$v0,$0 	#match = match == 0
          and $v1,$v1,$0	#error = error == 0
          and $t0,$t0,$0	#i = i == 0
          and $t1,$t1,$0	#j = j == 0
          

row:	  beq $t0,$a1,endn	#goto endn if i = n
          and $t1,$t1,$0	#j = j == 0

column:	  beq $t1,$a1,endk	#goto endk if j = n
          sll $t4,$t0,2		#temp1 = i^2
          sll $t5,$t1,2		#temp2 = j^2
          mul $t4,$t4,$a1	#temp1 = temp * n
          add $t3,$t4,$t5	#address of a[i,j] = temp1+temp2
          add $t3,$t3,$a0	#address a[i,j] = a[i,j] + basee address of array
          lw  $t2,($t3)		#a[i,j] = address a[i,j]
          bne $t0,$t1,else	#goto else if i != j
          add $v0,$v0,$t2	#match = match + a[i, j]
          addi $t1,$t1,1	#j++
          b endk		#goto endk

else:	  add $v1,$v1,$t2	#error = error + a[i,j]
          addi $t1,$t1,1	#j++

endk:	  bne $t1,$a1,column	#goto column if j != n
          addi $t0,$t0,1	#i++

endn:	  bne $t0,$a1,row	#goto row if i != n
          jr $ra		#return
