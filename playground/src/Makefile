CC = gcc
CFLAGS = -c -m32 -march=i486 -nostdlib

default:
	make run

convHankakuTxt : convHankakuTxt.c
	$(CC) $< -o $@

hankaku.c : hankaku.txt convHankakuTxt
	./convHankakuTxt

ipl.bin : ipl.asm Makefile
	nasm ipl.asm -o ipl.bin -l ipl.lst

asmhead.bin : asmhead.asm
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

nasmfunc.o : nasmfunc.asm Makefile
	nasm -f elf nasmfunc.asm -o nasmfunc.o -l nasmfunc.lst

hankaku.o : hankaku.c
	$(CC) -fno-pie $(CFLAGS) hankaku.c -o hankaku.o

mysprintf.o : mysprintf.c
	$(CC) -fno-pie $(CFLAGS) -nostdlib $^ -o $@

bootpack.hrb : bootpack.c hankaku.o nasmfunc.o mysprintf.o shin.ld
	$(CC) -fno-pie -m32 -march=i486 -nostdlib -nostdinc -T shin.ld bootpack.c hankaku.o nasmfunc.o mysprintf.o -o bootpack.hrb

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
	rm hankaku.c
	rm convHankakuTxt

src_only :
	make clean
	rm shinos.img
