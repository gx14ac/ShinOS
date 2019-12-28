CC = gcc
CFLAGS = -c -m32 -march=i486 -nostdlib

default:
	make run

ipl.bin : ipl.asm Makefile
	nasm ipl.asm -o ipl.bin -l ipl.lst

asmhead.bin : asmhead.asm
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

bootpack.o : bootpack.c
	$(CC) -fno-pie $(CFLAGS) $< -o $@

nasmfunc.o : nasmfunc.asm Makefile
	nasm -f elf nasmfunc.asm -o nasmfunc.o -l nasmfunc.lst

hankaku.o : hankaku.c
	$(CC) -fno-pie $(CFLAGS) $< -o $@

mysprintf.o : mysprintf.c
	$(CC) -fno-pie $(CFLAGS) -nostdlib $^ -o $@

graphic.o : graphic.c
	$(CC) -fno-pie $(CFLAGS) $< -o $@

dsctbl.o : dsctbl.c
	$(CC) -fno-pie $(CFLAGS) $< -o $@

BOOTPACK_OBJ = bootpack.o nasmfunc.o hankaku.o mysprintf.o graphic.o dsctbl.o

bootpack.hrb : $(BOOTPACK_OBJ) shin.ld
	ld -m elf_i386 -T shin.ld $(BOOTPACK_OBJ) -o $@

shinos.sys : asmhead.bin bootpack.hrb Makefile
	cat asmhead.bin bootpack.hrb > shinos.sys

shinos.img : ipl.bin shinos.sys Makefile
	mformat -f 1440 -C -B ipl.bin -i shinos.img ::
	mcopy shinos.sys -i shinos.img ::

asm :
	make -r ipl.bin

img :
	make -r shinos.img

run :
	make img
	qemu-system-i386 -fda shinos.img	# "-fda" for floppy disk

debug:
	make img
	qemu-system-i386 -fda shinos.img -gdb tcp::10000 -S

clean :
	rm *.lst
	rm *.o
	rm *.bin
	rm *.hrb
	rm *.sys

hyper_clean :
	rm shinos.img
	make clean
