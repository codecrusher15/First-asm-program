#CA assignment 2
#Name : Pushkar Sandip Pawar
#Roll no: IMT2020015

.data
	next_line: .asciiz "\n"	
.text
#input: N= how many numbers to sort should be entered from terminal. 
#It is stored in $t1	
jal input_int 
move $t1,$t4			

#input: X=The Starting address of input numbers (each 32bits) should be entered from
# terminal in decimal format. It is stored in $t2
jal input_int
move $t2,$t4

#input:Y= The Starting address of output numbers(each 32bits) should be entered
# from terminal in decimal. It is stored in $t3
jal input_int
move $t3,$t4 

#input: The numbers to be sorted are now entered from terminal.
# They are stored in memory array whose starting address is given by $t2
move $t8,$t2
move $s7,$zero	#i = 0
loop1:  beq $s7,$t1,loop1end #loop to take input
	jal input_int
	sw $t4,0($t2)
	addi $t2,$t2,4
      	addi $s7,$s7,1
        j loop1      
loop1end: move $t2,$t8       


#let N be number of numbers$
move $s0,$t3	#assigning s0 to base address of destination array
move $s1,$t2	#assigning s1 to base address of  source array
move $s3,$zero #s3=0
jal copy_to_dest
copy_to_dest:	#loop to copy all elements from source arrau
		beq $s3,$t1,ctd_end #s3 is acting as count.
		lw $t9,0($t2)	#loading from source array
		sw $t9,0,($t3)  #storing dest array 
		addi $t2,$t2,4
		addi $t3,$t3,4
		addi $s3,$s3,1
		j copy_to_dest
ctd_end:	move $t2,$s1
		move $t3,$s0		
		move $s1,$t1 #storing total number of elements in s1
		move $s6,$zero
		addi $s6,$zero,1 #setting value of 1 at s6
		j max_at_end
			
bubble_sort:	beq $s1,$s6,sort_end #procedure to put max value at end and secong max value at last second pos and so on.
		addi $s1,$s1,-1
		j max_at_end
		
				
max_at_end:	move $s0,$t3	#this procedure puts maximum mnber at end
		move $s7,$zero #s7 is used as counter in this inner loop
		addi $s7,$zero,1
		loop2:
		beq $s7,$s1,bubble_sort #condition to exit loop
		lw $t4,0($s0)	#loading elements from array
		lw $t5,4($s0)
		slt $t6,$t4,$t5 #checking less than condition
		move $a0,$s0	#loading paramaters for swap procedure
		addi $s0,$s0,4
		move $a1,$s0
		beq $t6,$zero,swap #swa if previous element is greter than next element
		continue: 
		addi $s7,$s7,1	#increasing counter
		j loop2
		
swap: 	lw $t9,0($a0) #procedure to swap elements at memory location $a0 and $a1
	lw $t8,0($a1)
	sw $t9,0($a1)
	sw $t8,0($a0)
	j continue


sort_end:
#endfunction
#print sorted numbers
move $s7,$zero	#i = 0
loop: beq $s7,$t1,end
      lw $t4,0($t3)
      jal print_int
      jal print_line
      addi $t3,$t3,4
      addi $s7,$s7,1
      j loop 
#end
end:  li $v0,10
      syscall
#input from command line(takes input and stores it in $t6)
input_int: li $v0,5
	   syscall
	   move $t4,$v0
	   jr $ra
#print integer(prints the value of $t6 )
print_int: li $v0,1		#1 implie
	   move $a0,$t4
	   syscall
	   jr $ra
#print nextline
print_line:li $v0,4
	   la $a0,next_line
	   syscall
	   jr $ra

