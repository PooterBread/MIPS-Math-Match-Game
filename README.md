# Math Match Game - MIPS Assembly Project

## Overview
This project is a memory-based matching game implemented in MIPS assembly. The goal is to find all matching pairs in the shortest amount of time.

## Files Included
```
|-- Main.asm
|-- Check.asm
|-- Display.asm
|-- GameLogic.asm
|-- RGeneratedGrid.asm
```

## How to Open the Program
1. Open **MARS 4.5** (MIPS Assembler and Runtime Simulator).
2. Go to the **File** option and click **Open**.
3. Navigate to the folder where the zip file was extracted.
4. Open each `.asm` file one by one.

## How to Run the Program
1. In MARS, after opening all `.asm` files, navigate to `Main.asm`.
2. Click on **Assemble**; if there are no errors, proceed.
3. Click the **Run** button (big green arrow next to Assemble).
4. The **Run I/O** section at the bottom of the screen will display the Math Match game.

## How to Play the Game
1. When the grid appears, enter the number of the **first card** (1-16).
2. Enter the number of the **second card** (1-16).
3. If they do not match, a message will display: _“No match! Try again in 3 seconds (Time Penalty).”_ Then, you will be prompted for another pair.
4. If the cards match, they will remain revealed.
5. Continue selecting pairs until all matches are found.
6. Once all matches are found, the total elapsed time will be displayed.
7. Try to finish the game as fast as possible. **Good luck!**

## Grid Number Format
```
 |+-----++-----++-----++-----+|
 ||  1  ||  2  ||  3  ||  4  ||
 |+-----++-----++-----++-----+|
 ||  5  ||  6  ||  7  ||  8  ||
 |+-----++-----++-----++-----+|
 ||  9  || 10  || 11  || 12  ||
 |+-----++-----++-----++-----+|
 || 13  || 14  || 15  || 16  ||
 |+-----++-----++-----++-----+|
```

## Requirements
- MARS 4.5 (MIPS Assembler and Runtime Simulator)
- Basic understanding of MIPS assembly

## Author
This project was developed for the **UTD CS 2340 Term Project** by Peter Siba.

## License
This project is open-source and free to use for educational purposes.

