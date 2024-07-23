#CHUONG TRINH XAP XI SO PI
#########################################
.include "macro.mac"
.data
hoanh_do: .space 200000 #mang luu 50000 hoanh do cua 50000 diem 
tung_do: .space 200000  #mang luu 50000 tung do cua 50000 diem
prompt: .asciiz "---"
endl: .asciiz "\n"
half: .float 0.5
filename: .asciiz "PI.txt" 
str: .space 20
cauxuat1: .asciiz "So diem nam trong hinh tron la: "
cauxuat2: .asciiz "/50000"
cauxuat3: .asciiz "So PI tinh duoc: "
result:  .space 12  # Khai báo vùng nhớ để lưu trữ chuỗi kết quả
temp:   .space 12          # Vùng nhớ tạm thời để lưu các ký tự
dot:        .asciiz "."       # Dấu chấm thập phân
buffer: .space 32 
phannguyen: .space 12		#vung nho luu phan nguyen cua so PI
phanthapphan: .space 12		#vung nho luu phan thap phan cua so PI 
int: .word 0
int1: .word 0
int2: .word 0
#########################################
.text
.globl main 
#Hình ảnh minh họa 
#Hình vuông nằm ở góc phần tư thứ I có cạnh là 1, và đường tròn nội tiếp hình vuông có tâm là I(0.5;0.5)
#        Oy	|
#	|
#	|
#         1| _ _ _ _ _ _ _ _ _ _ _
#	|		|
#	|		|
#	|		|
#	|		|
#	|	.I(0.5;0.5)	|
#	|		|
#	|		|
#	|		|
#	|  		|
#	|_ _ _ _ _ _ _ _ _ _ _|________________Ox
#         O(0;0)		1       		     	
main:
#tao 2 vong lap de tao gia tri ngau nhien cho hoanh do va tung do
	li $t0 , 0		#bien dem cho vong lap
	la $a1  , hoanh_do	#luu dia chi cua hoanh_do
	la $a2 , tung_do	#luu dia chi cua tung do
	li $t4, 4		#1 so can 4 byte de luu tru, ta dung bien nay de tang gia tri o nho

#vong lap tao gia tri hoanh do	
loop_toado:
	#tinh toan gia tri nhay de luu vao mang
	mul $t3 , $t4 , $t0
	add $t5 , $a1 , $t3 
	add $t6 , $a2 , $t3 
	#thuc hien syscall 43 de tao random so thuc trong [0;1)
	li $v0 , 43	
	syscall		#gia tri random duoc luu trong $f0
	swc1 $f0 , 0($t5)	#luu gia tri ramdom duoc vao mang hoanh do 
	
	li $v0 , 43	
	syscall		#gia tri random duoc luu trong $f0
	swc1 $f0 , 0($t6)	#luu gia tri ramdom duoc vao mang tung do
	
	addi $t0 , $t0 , 1  	#tang gia tri bien dem len 1 don vi
	bne $t0 , 50000 , loop_toado	#kiem tra dieu kien lap
	j end_loop_toado		#thoat khoi vong lap neu ramdom xong 50000 so
end_loop_toado:	

######################################################	
#tinh toan de xac dinh diem co nam trong duong tron hay khong
#tinh khoang cach tu diem do den tam I, neu khoang cach > R=0.5 thi diem nam ngoai duong tron
	li $t0 , 0		#dua gia tri bien dem ve 0 
	li $t7 , 0		#thanh ghi dung de luu so phan tu co gia tri < 0.5
loop:
	mul $t3 , $t4 , $t0
	add $t5 , $a1 , $t3		#lay dia chi cua mang hoanh do
	add $t6 , $a2 , $t3 		#lay dia chi cua mang tung do 
	
	lwc1 $f5 , 0($t5)		#lay gia tri hoanh do
	
	lwc1 $f6 , 0($t6) 		#lay gia tri tung do	
		
	lwc1 $f10 , half		#luu gia tri 0.5 vao $f10
	sub.s $f5 , $f5 , $f10		# hoanh do - 0.5 = $f5 = $f5 - 0.5
	sub.s $f6 , $f6 , $f10 	# tung do - 0.5 = $f6 = $f6 - 0.5 
	mul.s $f5 , $f5 , $f5 	           	#(hoanh do-0.5)^2
	mul.s $f6 , $f6 , $f6		#(tung do-0.5)^2  
	add.s $f7 , $f5 , $f6		# $f7 =(hoanh do-0.5)^2 + (tung do-0.5)^2	
	sqrt.s $f7 , $f7		#lay can bac 2 
	
# so sanh gia tri can bac 2 vua tinh duoc voi ban kinh R=0.5
				
	c.lt.s $f7 , $f10 		#so sanh $f7 voi 0.5 
	bc1t next			#neu f7 < 0.5 nhay toi next 
	
continue_loop:		
	addi $t0 , $t0 , 1
	bne $t0 , 50000 , loop
	j end_loop	
	
end_loop:	
#in "So diem nam trong hinh tron la:" ra man hinh 
print_str cauxuat1
#in so diem nam trong hinh tron ra man hinh
li $v0 , 1 
add $a0 , $zero, $t7 
syscall
#in "/50000" ra man hinh
print_str cauxuat2
 # Lưu hằng số 50000 vào thanh ghi dấu chấm động $f6
li $t5 , 50000
mtc1 $t5 , $f5
cvt.s.w $f5 , $f5 
# Chuyển số nguyên từ thanh ghi $t7 sang thanh ghi dấu chấm động $f7
mtc1 $t7 , $f7 
cvt.s.w $f7 , $f7 
# Thực hiện phép chia số thực trong $f7 cho số thực trong $f6 và lưu kết quả vào $f7
div.s $f7 , $f7 , $f5 
 
# Nhan ket qua tim duoc cho 4 de tim ra gia tri cua so pi 
#chuyen 4 thanh so thuc de thuc hien phep nhan 
li $t6 , 4		
mtc1 $t6 , $f6
cvt.s.w $f6 , $f6 
mul.s $f7 , $f7 , $f6  	#thuc hien phep nhan 4 


######################
#xu ly $f7 va $t7 de co the ghi ra file 
#tach phan nguyen va chuyen phan nguyen thanh kieu chuoi 
#in cau xuat 1 ra file 
#mo file de ghi
li $v0, 13        # Mã hệ thống cho mở file
la $a0, filename  # Đường dẫn file (ví dụ: filename: .asciiz "output.txt")
li $a1, 1         # Chỉ định chế độ mở file (0: đọc, 1: ghi, 9: thêm)
li $a2, 0         # Mode (0: mặc định)
syscall           # Gọi hệ thống mở file
move $s0, $v0     # Lưu file descriptor vào $s0
#ghi cau xuat vao file 
li $v0 , 15
move $a0 , $s0
la $a1 , cauxuat1
li $a2 , 32
syscall
#chuyen doi so diem trong hinh tron ve dang asciiz 
# Chuyển số nguyên thành chuỗi
    add $a0 , $zero, $t7  # Số nguyên cần chuyển đổi

    la $a1, result         # Tải địa chỉ của vùng nhớ result vào $a1
    jal convert            # Gọi hàm chuyển đổi
    
    li $v0 , 15		#in so nguyen da chuyen doi ra file 
    move $a0, $s0 
    la $a1 , result
    li $a2 , 5
    syscall
    
#in chuoi /50000 ra file
    li $v0 , 15
    move $a0 , $s0
    la $a1 , cauxuat2
    li $a2 , 6
    syscall
    
#in ki tu "\n" de xuong dong 
li $v0 , 15
    move $a0 , $s0
    la $a1 , endl
    li $a2 , 2
    syscall
##################################     
#in "So PI tinh duoc: " ra file 
    	li $v0 , 15
    	move $a0 , $s0
   	la $a1 , cauxuat3
   	li $a2 , 17
    	syscall
# chuyen doi gia tri so PI tim duoc ve dang chuoi de in ra file   
	#tach phan nguyen cua so PI
	li $t5 , 1000000
	mtc1 $t5 , $f5
	cvt.s.w $f5 , $f5
	
	trunc.w.s $f4 , $f7   		#luu phan nguyen vao $f4
	mfc1 $t4 , $f4 		#chuyen phan nguyen vao $t4 (kieu nguyen)
	cvt.s.w $f4 , $f4 
	sub.s $f7 , $f7 , $f4 		# tru phan nguyen de $f7 ve dang 0.ffffff
	mul.s $f7 , $f7 , $f5		# *10^6 
	trunc.w.s $f5 , $f7		#tach 6 chu so phan thap phan luu vao $f5
   	#chuyen phan nguyen da tach thanh so nguyen
   	 mfc1 $t5 , $f5 
   	 
	#chuyen phan nguyen thanh chuoi
      	add $a0 , $zero, $t4	  # Số nguyên cần chuyển đổi
   	la $a1, phannguyen         # Tải địa chỉ của vùng nhớ phannguyen vào $a1
    	jal convert            # Gọi hàm chuyển đổi
    	#in phan nguyen 
    	li $v0 , 15
    	move $a0 , $s0
   	la $a1 , phannguyen 
   	li $a2 , 1
   	syscall
    	#chuyen phan thap phan thanh chuoi
    	add $a0 , $zero, $t5  # Số nguyên cần chuyển đổi
   	la $a1, phanthapphan         # Tải địa chỉ của vùng nhớ phanthapphan vào $a1
    	jal convert           	 # Gọi hàm chuyển đổi
    	   	
    	#in dau cham 
   	li $v0 , 15
    	move $a0 , $s0
   	la $a1 , dot
   	li $a2 , 1
   	syscall
    	#in phan thap phan 
    	li $v0 , 15
    	move $a0 , $s0
   	la $a1 , phanthapphan
   	li $a2 , 7
    	syscall
  	
          
#dong file 
li $v0 , 16
move $a0 , $s0
syscall 

#in ra man hinh 
#in "So PI tinh duoc la: " ra man hinh de kiem tra
print_str endl
print_str cauxuat3
print_str phannguyen
print_str dot
print_str phanthapphan

##################################
li $v0 , 10
syscall 

##################################
#cac ham chuyen doi 
next:	
	addi $t7 , $t7 , 1	#so diem trong hinh trong +1 
	j continue_loop
##################################
#ham chuyen so nguyen thanh chuoi 
convert:
    li $t0, 0              # Khởi tạo biến đếm vị trí ký tự
    li $t1, 10             # Lưu trữ giá trị 10 (hệ cơ số 10)
    la $t3, temp           # Tải địa chỉ của vùng nhớ tạm thời vào $t3

int2str:
    beq $a0, $zero, reverse # Nếu $a0 (số nguyên) bằng 0, chuyển đến reverse
    div $a0, $t1           # Chia $a0 cho 10
    mfhi $t2               # Lấy phần dư và lưu vào $t2
    addi $t2, $t2, 48      # Chuyển đổi dư thành ký tự ASCII
    sb $t2, ($t3)          # Lưu ký tự vào vùng nhớ tạm thời
    addi $t3, $t3, 1       # Tăng con trỏ $t3 để lưu ký tự tiếp theo
    addi $t0, $t0, 1       # Tăng biến đếm vị trí ký tự
    mflo $a0               # Lấy phần thương và lưu vào $a0
    j    int2str             # Tiếp tục vòng lặp

reverse:
    sub $t3, $t3, 1        # Điều chỉnh con trỏ tạm thời trỏ đến ký tự cuối cùng
    sub $t0, $t0, 1        # Giảm biến đếm vị trí ký tự để phù hợp với chỉ số

copy_back:
    blt $t0, $zero, end    # Nếu t0 < 0, chuyển đến end
    lb $t2, ($t3)          # Lấy ký tự từ vùng nhớ tạm thời
    sb $t2, ($a1)          # Lưu ký tự vào vùng nhớ result
    addi $a1, $a1, 1       # Tăng con trỏ $a1
    sub $t3, $t3, 1        # Giảm con trỏ tạm thời
    sub $t0, $t0, 1        # Giảm biến đếm
    j copy_back            # Tiếp tục sao chép ngược

end:
    sb $zero, ($a1)        # Thêm ký tự null ('\0') vào cuối chuỗi
    jr $ra                 # Trả về địa chỉ gọi hàm

