default :
	make img

ipl.bin : ipl.asm Makefile
	nasm ipl.asm -o ipl.bin -l ipl.lst

shinos.sys : shinos.asm Makefile
	nasm shinos.asm -o shinos.sys -l shinos.lst

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

clean :
	rm -rf *.lst \
		*.bin \
		*.sys
