default:
	    make img

ipl.bin : src/ipl.asm Makefile
	    nasm src/ipl.asm -o src/ipl.bin -l src/ipl.lst

shinos.sys : src/shinos.asm Makefile
	    nasm src/shinos.asm -o src/shinos.sys -l src/shinos.lst

shinos.img : src/ipl.bin src/shinos.sys Makefile
	    mformat -f 1440 -C -B src/ipl.bin -i src/shinos.img ::
		    mcopy src/shinos.sys -i src/shinos.img ::

asm :
	    make -r src/ipl.bin

img :
	    make -r src/shinos.img

run :
	    make img
		    qemu-system-i386 -fda src/shinos.img
