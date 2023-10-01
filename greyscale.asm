#Sachen Pather PTHSAC002
.data
inputFile:   .asciiz "C:\Users\sache\MIPS_EXAMPLES\Assignment3\house_64_in_ascii_lf.ppm"  # Path to the input file
outputFile:  .asciiz "C:\Users\sache\MIPS_EXAMPLES\Assignment3\output2.ppm"  # Path to the output file
readingBuffer: .space 80000  # input buffer
writingBuffer: .space 80000  # output buffer
reversed: .space 4  # Buffer for reversed values

.text
    .globl main

main:
    # Open the input file for reading
    li $v0, 13 
    la $a0, inputFile  
    li $a1, 0  
    li $a2, 0  
    syscall  
    move $s6, $v0   

    # Read the content of the input file into the reading buffer
    li $v0, 14  
    move $a0, $s6  
    la $a1, readingBuffer  
    li $a2, 80000  
    syscall  
    move $s7, $v0   

    # Close the input file
    li $v0, 16  
    move $a0, $s6  
    syscall  

    # Initialize registers, set up the variables
    li $t0, 0   # Position in reversed value buffer
    li $t7, 3   # Position in the reading buffer
    li $t1, 0   # Newline character counter
    li $t4, 0   # Position in the writing buffer
    li $t3, 2   # value to start string reversal  
    li $s1, 0   # Sum of RGB values
    
    
    # write "P2" to the output buffer to change file type to grayscale, put words in the buffer
    li $t2, 80  # ASCII value for 'P'
    sb $t2, writingBuffer($t4)  
    addi $t4, 1  

    li $t2, 50  # ASCII value for '2'
    sb $t2, writingBuffer($t4)  
    addi $t4, 1  

    li $t2, 10  # ASCII value for newline character
    sb $t2, writingBuffer($t4)  
    addi $t4, 1  

# Loop through file info until the line values are reached
fileLoop:
    beq $t1, 3, Valuesloop  # Skip to line pixel values after 3 new lines, ignore the first lines
    lb $t2, readingBuffer($t7)  
    sb $t2, writingBuffer($t4)  
    addi $t7, 1  
    addi $t4, 1  
    beq $t2, 10, incLine

    j fileLoop  

# Increment newline counter and continue loop to count the lines
incLine:
    addi $t1, 1  

    j fileLoop  

# Begin processing pixel values for grayscale conversion
Valuesloop:
    li $s0, 0   # Reset current value holder

# Convert ASCII characters to integer pixel value, turn text into numbers
stringToInt:
    lb $t2, readingBuffer($t7)  
    addi $t7, $t7, 1  

    beqz $t2, WriteToFile  # If null terminator, begin writing file, when done, it saves
    beq $t2, 10, addition  
    
    # Compute integer value from ASCII characters
    sub $t2, $t2, 48  
    mul $s0, $s0, 10  
    add $s0, $s0, $t2  

    j stringToInt  

# manipulate RGB values to convert to greyscale
addition:
    add $s1, $s1, $s0  
    addi $t5, 1  
    beq $t5, 3, ave  

    j Valuesloop  

# Calculate the average of the 3 RGB values for grayscale
ave:
    li $s6, 3  
    div $s1, $s6  
    mflo $s0  
    li $s1, 0  
    li $t0, 0  
    li $t5, 10  

# Convert integer grayscale value to ASCII string to turn the number into text
intToString:
    div $s0, $t5  
    mflo $s0  
    mfhi $t6  
    addi $t6, 48  
    sb $t6, reversed($t0)  
    addi $t0, 1

    beqz $s0, startReversal

    j intToString  

# Reverse the ASCII string to get the correct order,must flip it around 

startReversal:
    li $t3, 2  # Set position in reversed_value buffer

reverseString:
    lb $t2, reversed($t3)  
    sb $t2, writingBuffer($t4)  
    addi $t4, 1
      
    beqz $t3, newLine  
    sub $t3, 1  

    j reverseString  

# Add newline character to output buffer and continue loop with some line breaks
newLine:
    li $t5, 10  
    sb $t5, writingBuffer($t4)  
    addi $t4, 1  
    li $t5, 0  

    j Valuesloop 

# Write the grayscale data to save the final creation
WriteToFile:
    li $v0, 4  
    la $a0, outputFile  
    syscall  

    li $v0, 13  
    la $a0, outputFile  
    li $a1, 1  
    li $a2, 0  
    syscall  
    move $s8, $v0  

    li $v0, 15  
    move $a0, $s8  
    la $a1, writingBuffer  
    li $a2, 16403
    syscall  

    li $v0, 16  
    move $a0, $s8  
    syscall  

    j exit

# Exit the program
exit:
    li $v0, 10  
    syscall  

