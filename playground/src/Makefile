default :
	make run

convHankakuTxt : convHankakuTxt.c
		$(CC) $< -o $@

hankaku.c : hankaku.txt convHankakuTxt
		./convHankakuTxt

ipl.bin : ipl.asm Makefile
	nasm ipl.asm -o ipl.bin -l ipl.lst

asmhead.bin : asmhead.asm Makefile
	nasm asmhead.asm -o asmhead.bin -l asmhead.lst

nasmfunc.o : nasmfunc.asm Makefile
	nasm -g -f elf nasmfunc.asm -o nasmfunc.o

bootpack.hrb : bootpack.c shin.ld hankaku.c nasmfunc.o Makefile
	gcc -fno-pie -march=i486 -m32 -nostdlib -T shin.ld bootpack.c hankaku.c nasmfunc.o -o bootpack.hrb

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
	qemu-system-i386 -fda shinos.img

debug :
	make img
	qemu-system-i386 -fda shinos.img -gdb tcp::10000 -S

clean :
	rm -rf *.lst \
		*.bin \
		*.sys \
		*.img \
		*.hrb \
		*.o \
		hankaku.c \
		convHankakuTxt

src_only:
	make clean
	rm	 shinos.img
