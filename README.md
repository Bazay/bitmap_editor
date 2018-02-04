# Bitmap Editor

## Usage

The program can be executed from the CLI by running the following command from the project root directory.
```bash
bin/bitmap_editor examples/show.txt
```
where `examples/show.txt` is the relative path to a file with valid instructions.


## Commands

There are 6 supported commands:
* I N M - Create a new M x N image with all pixels coloured white (O).
* C - Clears the table, setting all pixels to white (O).
* L X Y C - Colours the pixel (X,Y) with colour C.
* V X Y1 Y2 C - Draw a vertical segment of colour C in column X between rows Y1 and Y2 (inclusive).
* H X1 X2 Y C - Draw a horizontal segment of colour C in row Y between columns X1 and X2 (inclusive).
* S - Show the contents of the current image

#### Example
Here's what a sample input file could look like:
```
I 5 6
L 1 3 A
V 2 3 6 W
H 3 5 2 Z
S
```

And here is the expected output:
```
OOOOO
OOZZZ
AWOOO
OWOOO
OWOOO
OWOOO
```


## Classes

**`BitmapEditor`**

This class is the entry point into the program. It is responsible for all logic relating to running the program.

**`InputParser`**

This class is responsible for reading from the input file and ensuring the commands within the file can be interpreted by the program.
