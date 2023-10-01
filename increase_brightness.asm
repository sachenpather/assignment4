#Sachen Pather PTHSAC002
.data
    oldAvg:     .asciiz "Average pixel value of the original image:\n"
    newAvg:   .asciiz "\nAverage pixel value of new image:\n"
    inputFile: .asciiz "C:\Users\sache\MIPS_EXAMPLES\Assignment3\house_64_in_ascii_crlf.ppm"  
    outputFile: .asciiz "C:\Users\sache\MIPS_EXAMPLES\Assignment3\output1.ppm"
   readingBuffer: .space  80000
   writingBuffer: .space 80000
.text
.globl main

main:
     # Open input file
        li $v0, 13          
        la $a0, inputFile
        li $a1, 0
        li $a2,0         
        syscall
        move $s0, $v0       

    #read in the file
    li $v0, 14
    move $a0, $s0
    la $a1, readingBuffer
    li $a2, 80000
    syscall

     # open output file
    li $v0, 13
    la $a0, outputFile
    li $a1, 1 
    li $a2, 0
    syscall
    move $s1, $v0 

    #Initializing buffers
    la $s7, readingBuffer
    la $s6, writingBuffer
    li $t1, 1 # Counter

#add the header into the write buffer
addTheHeader:
    lb $t2,($s7)
    sb $t2,($s6)
    addi $s6,$s6,1
    addi $s7,$s7,1
    beq $t2,10,incLine
    j addTheHeader

#increment line
incLine:
    addi $t1,$t1,1 # count the number of lines
    beq $t1,5,readValues #reading the values on each line

 j addTheHeader

 # Code for reading and processing values on each line.
 readValues:
    li $t4, 0 # line value
    li $t1, 0 # number of digits
    li.d $f8, 0.0
    li.d $f4, 0.0 
    li $t7, 0 # Line count

#Convert string to integer
StringToInt:
    lb $t2,($s7)
    beq $t2,10,LineManipulation
    beq $t2,0,WriteToFile

    sub $t2,$t2,48
    mul $t4,$t4,10
    add $t4,$t4,$t2

    addi $s7,$s7,1
    addi $s6,$s6,1
    addi $t1,$t1,1 

    j StringToInt

#traverse through each line in file and add
LineManipulation:
    addi $t7,$t7,1
    beq $t7,12289,WriteToFile

    mtc1 $t4, $f0
    cvt.d.w $f0, $f0
    add.d $f8, $f8, $f0 

    addi $s7,$s7,1

    #for different number lengths and values the logic changes
    bge $t4,245,goTo255
    bgt $t4,89,oldAdd
    blt $t4,10,oldAdd

    addi $t4,$t4,10
    mtc1 $t4, $f0
    cvt.d.w $f0, $f0
    add.d $f4, $f4, $f0 

    li $t8,10
    sb $t8,($s6)

    j IntStringConversion


oldAdd: #addition of non incremented set of values
    bgt $t4,99,newAdd
    addi $t4,$t4,10
    mtc1 $t4, $f0
    cvt.d.w $f0, $f0
    add.d $f4, $f4, $f0 

    addi $t1, $t1, 1
    addi $s6, $s6, 1


    li $t8,10
    sb $t8,($s6)

    j IntStringConversion

newAdd: #addition of incremented set of values
    addi $t4,$t4,10
    mtc1 $t4, $f0
    cvt.d.w $f0, $f0
    add.d $f4, $f4, $f0 # Sum for NEW pixels

    li $t8,10
    sb $t8,($s6)
    j IntStringConversion

goTo255: #if num greater than equal 245 go to 255
    li $t4,255
    mtc1 $t4, $f0
    cvt.d.w $f0, $f0
    add.d $f4, $f4, $f0 

    li $t8,10
    sb $t8,($s6)

    j IntStringConversion

IntStringConversion:    #convert back to print
    beq $t4, $zero, endConversion 
    divu $t4, $t4, 10     
    mfhi $t9             
    addi $t9, $t9, 48     
    sb $t9, -1($s6)       
    addi $s6, $s6, -1         

    j IntStringConversion


endConversion:
    add $s6,$s6,$t1
    addi $s6,$s6,1
    li $t1,0

    j StringToInt


WriteToFile:    #now write to file
    # Code for writing to the output file.
    la $s4, writingBuffer
    sb $t2,($s6)
    sub $s4,$s6,$s4
    sub $s4,$s4,2

    li $v0, 15
    move $a0, $s1
    la $a1, writingBuffer
    move $a2, $s4
    syscall

closeFile:  #close the file
    li $v0, 16          
    move $a0, $s0       
    syscall

    li $v0, 16          
    move $a0, $s1       
    syscall


calcAverages:
# Code for calculating and displaying averages.
    li.d $f0, 1044480.0  
    div.d $f4, $f4, $f0 
    div.d $f8, $f8, $f0  

    li $v0, 4
    la $a0, oldAvg
    syscall
    li $v0, 3
    mov.d $f12, $f8
    syscall

    li $v0, 4
    la $a0, newAvg
    syscall
    li $v0, 3
    mov.d $f12, $f4
    syscall

    j Exit

    Exit:
    li $v0, 10         
    syscall