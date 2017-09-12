all: ass3

ass3:cell.o source.o coroutines.o printer.o scheduler.o cellRunner.o
	gcc -nostdlib -m32 -g -Wall -o ass3 cell.o source.o coroutines.o printer.o scheduler.o cellRunner.o


cell.o: cell.c 
	gcc -g -Wall -m32 -ansi -c -o cell.o cell.c 
 
source.o: ass3.s
	nasm -g -f elf -w+all -o source.o ass3.s

coroutines.o: coroutines.s
	nasm -g -f elf -w+all -o coroutines.o coroutines.s
 
printer.o: printer.s
	nasm -g -f elf -w+all -o printer.o printer.s
 
scheduler.o: scheduler.s
	nasm -g -f elf -w+all -o scheduler.o scheduler.s
 
cellRunner.o: cellRunner.s
	nasm -g -f elf -w+all -o cellRunner.o cellRunner.s

.PHONY: clean

clean: 
	rm -f *.o ass3