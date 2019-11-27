@echo off
if exits kernel.asm {
   @nasm boot.asm -o boot.bin -l boot.lst
   @nasm kernel.asm -o kernel.bin -l kernel.lst
   @copy /B boot.bin+kernel.bit bomm.img
} else {
   @nasm boot.asm -o boot.img -l boot.lst
}
