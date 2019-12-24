OSNAME  := ChooseYourLife
IMGNAME := ChooseYourSelf

run :
	nasm src/ipl.asm -o ipl.img -l ipl.lst
	qemu-system-i386 ipl.img

clean:
	rm -rf *.lst
	rm -rf *.img
