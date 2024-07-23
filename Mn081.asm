#CHUONG TRINH GIAI BAI TOAN THAP HA NOI
.data
prompt: .asciiz "Enter a number: "
part1: 	.asciiz "Buoc "
part2: 	.asciiz ": "
part3: 	.asciiz "==>"
Newln: 	.asciiz "\n"
temp: 	.byte
file: 	.asciiz "THAP_HN.TXT"
itoa:	.asciiz "ITOAITOA"
itoa_end:
.text
.globl main
####################################################################
#Open (for writing) file
	li	$v0,13		#system call for open file
	la	$a0,file		#luu duong dan file vao a0
	li	$a1,1		#thanh ghi a1 = 1 (allow for write on file)
	li	$a2,0		
	syscall
	move	$s6,$v0


#####################################################################
main:
    	li 	$v0,  4         # print string
    	la 	$a0,  prompt
    	syscall
    	li 	$v0,  5         # read integer
    	syscall
#So dia duoc luu trong thanh ghi v0
    # parameters for the routine
     #Khoi tao a0= so dia = v0, a1=A, a2=C, a3=B, Buoc t0 = 1
    	add 	$a0, $v0, $zero	# move to $a0
    	li 	$a1, 'A'        # source rod
    	li 	$a2, 'C'        # destination rod
    	li 	$a3, 'B'        # auxiliary rod

    	li 	$t0, 1          # step counter initialized to 1

    	jal 	hanoi           # call hanoi routine
##############################################################################
#Close file
	li	$v0,16
	move	$a0,$s6
	syscall
	
###############################################################################
    	li 	$v0, 10          # exit
    	syscall

hanoi:

    # save registers in stack
    #Tao ra vung nho stack de luu cac thanh ghi ra,s0, s1, s2, s3
    	addi 	$sp, $sp, -20 	#tao ra vung nho chua 5 phan tu
    	sw   	$ra, 0($sp)		#save return add
    	sw   	$s0, 4($sp)		#save s0
    	sw   	$s1, 8($sp)		#save s1
    	sw   	$s2, 12($sp)	#save s2
    	sw   	$s3, 16($sp)	#save s3
    #Cho s1 = a1, s2 = a2, s3 = a3, s0 = a0
    	add 	$s0, $a0, $zero
    	add 	$s1, $a1, $zero
    	add 	$s2, $a2, $zero
    	add 	$s3, $a3, $zero
    #su dung thanh ghi t1 = 1, khi so dia hien tai = 1 thi nhay toi output 
    	addi 	$t1, $zero, 1
    	beq 	$s0, $t1, output
    #Su dung de quy de thay doi n-1 dia qua cot B va dia cuoi cung qua cot C
recur1:
        addi 	$a0, $s0, -1	#giam so luong dia voi 1
        add 	$a1, $s1, $zero	
        add 	$a2, $s3, $zero
        add 	$a3, $s2, $zero
        jal 	hanoi

        j 	output		#Jump to output after returning from recursion

recur2:
        addi 	$a0, $s0, -1
        add 	$a1, $s3, $zero
        add 	$a2, $s2, $zero
        add 	$a3, $s1, $zero
        jal 	hanoi		#Tro ve hanoi

exithanoi:
        lw   	$ra, 0($sp)  	# restore registers from stack
        lw   	$s0, 4($sp)		# restore s0
        lw   	$s1, 8($sp)		# restore s1
        lw   	$s2, 12($sp)	# restore s2
        lw   	$s3, 16($sp)	# restore s3

        addi 	$sp, $sp, 20 	# restore stack pointer, tra lai vung nho

        jr 	$ra			#nhay ve thanh ghi ra khi duoc lay ra trong stack

output:
        li 	$v0,  4   	# print string "Buoc "
        la 	$a0,  part1
        syscall
    #Writefile: "Buoc " 
        li	$v0,15
        move	$a0,$s6		#a0=s6 la file descriptor
        la	$a1,part1			#luu dia chi cua "Buoc " toi a1
        li	$a2,5			#chieu dai cua "Buoc " la 5 
        syscall
        #
        li 	$v0,  1  		   	# print step number
        add $a0, $t0, $zero
        syscall
    #Writefile: print step number
     #convert int to ASCII
     #itoa:
     	la 	$a1, itoa_end	#End of buffer
    	addiu 	$a1, $a1, -1	#Move to last character of buffer
    	li 	$t6, 10		#Chuyen doi so chia
    	li 	$a2, 0		#Khoi tao ban dau do dai cua chuoi = 0
    	move 	$t5, $t0		#Luu buoc x vao t5
  itoa_loop:    
    	addiu 	$a1, $a1, -1	#di chuyen a1 trong buffer giam di 1
    	addiu 	$a2, $a2, 1		#Tang do dai cua chuoi
    	divu 	$t5, $t6        	#Chia buoc x cho 10
    	mfhi 	$t5		#Lay phan du
    	addiu 	$t5, $t5, '0'	#Chuyen phan du thanh ki tu ASCII
    	sb 	$t5, 0($a1)		#Luu vao buffer
    	mflo 	$t5		#Lay phan thuong
    	bnez 	$t5, itoa_loop	#Neu phan thuong !=0 thi continue loop
 #Sau do dia chi cua ma ASCII duoc tao tu int se duoc luu vao a1
    	li 	$v0, 15
    	move 	$a0, $s6	
    	syscall			#write len file step number
        #
        li 	$v0,  4  		            # print string ": "
        la 	$a0,  part2
        syscall
   #Writefile: print string ": "
   	li	$v0, 15
   	move	$a0,$s6
   	la	$a1,part2
   	li	$a2,2
   	syscall
   	#
        li 	$v0,  11  		           # print source rod character
        add 	$a0, $s1, $zero
        sb	$a0,temp
        syscall
   #Writefile: print source rod character
   	li	$v0,15
   	move	$a0,$s6
   	la	$a1,temp
   	li	$a2,1
   	syscall
   	#
        li 	$v0,  4  		            # print string "==>"
        la 	$a0,  part3
        syscall
   #Writefile: print string "==>"
   	li	$v0,15
   	move	$a0,$s6
   	la	$a1,part3
   	li	$a2,3
   	syscall
   	#
        li 	$v0,  11  		           # print destination rod character
        add 	$a0, $s2, $zero
        sb	$a0,temp
        syscall
   #Writefile: print destination rod character
   	li	$v0,15
   	move	$a0,$s6
   	la	$a1,temp
   	li	$a2,1
   	syscall
   	#
	li 	$v0,4
        la 	$a0,Newln
        syscall
   #Writefile: Newln
   	li	$v0,15
   	move	$a0,$s6
   	la	$a1,Newln
   	li	$a2,1
   	syscall
        addi 	$t0, $t0, 1        	# increment step counter

        beq 	$s0, $t1, exithanoi	#Neu so dia hien tai = 1 thi toi label exithanoi de lay ra cac phan tu trong stack
        j 	recur2			#Khong thi tiep tuc thuc hien de quy
