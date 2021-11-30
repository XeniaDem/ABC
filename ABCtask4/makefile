# makefile for task.asm
task: main.o input.o inrnd.o output.o perimeter.o sort.o outrnd.o
	gcc -g -o task main.o input.o inrnd.o output.o perimeter.o sort.o outrnd.o -no-pie
main.o: main.asm macros.mac
	nasm -f elf64 -g -F dwarf main.asm -l main.lst
input.o: input.asm
	nasm -f elf64 -g -F dwarf input.asm -l input.lst
inrnd.o: inrnd.asm
	nasm -f elf64 -g -F dwarf inrnd.asm -l inrnd.lst
output.o: output.asm
	nasm -f elf64 -g -F dwarf output.asm -l output.lst
perimeter.o: perimeter.asm
	nasm -f elf64 -g -F dwarf perimeter.asm -l perimeter.lst
sort.o: sort.asm
	nasm -f elf64 -g -F dwarf sort.asm -l sort.lst
outrnd.o: outrnd.asm
	nasm -f elf64 -g -F dwarf outrnd.asm -l outrnd.lst
