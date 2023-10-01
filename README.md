# assignment4
csc2002s assignment
## Author:
Sachen Pather
Student Number: PTHSAC002

---

## Description
The contents of this repository includes 2 mips assembly language programs for processing images by manipulating their respective ppm files. 
These programs are designed to read an input image file, manipulate the pixel values, and then save the modified image as an output file.

---

## Program 1: Brighten Image

### Description:
- File: increase_brightness.asm
- This program reads an input PPM image file, brightens the pixel values, and saves the modified image as an output file.

### How to Use:
1. Ensure you have the MARS MIPS simulator installed (http://courses.missouristate.edu/KenVollmar/mars/).
2. Open the MARS simulator.
3. In the code, specify the input and output filenames:
   - Input Filename: Edit the `filename` variable to specify the absolute path to your input image file.
   - Output Filename: Edit the `writefile` variable to specify the absolute path for the output image file.
4. Run the program.


### Functionality:
- The program reads the input image file and processes each pixel value.
- It brightens the pixel values by adding 10 to each value (clipping at 255).
- The modified image is then saved as an output file.

---

## Program 2: greyscale Image

### Description:
- File: greyscale.asm
- This program reads an input PPM image file, greyscales the pixel values, and saves the modified image as an output file.

### How to Use:
1. Ensure you have the MARS MIPS simulator installed (http://courses.missouristate.edu/KenVollmar/mars/).
2. Open the MARS simulator.
3. In the code, specify the input and output filenames:
   - Input Filename: Edit the `filename` variable to specify the path to your input image file.
   - Output Filename: Edit the `writefile` variable to specify the path for the output image file.
4. Run the program.

### Functionality:
- The program reads the input image file and processes each pixel value.
- It greyscalesthe pixel values to be in the range of 0 to 255.
- The modified image is then saved as an output file.
