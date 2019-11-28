#! /bin/sh

KERNEL_FILE="kernel.asm"

if [ -e $KERNEL_FILE ]; then
    nasm boot.asm -o boot.bin -l boot.lst
    nasm kernel.asm -o kernel.bin -l kernel.lst
    cat boot.bin kernel.bin > boot.img
fi
    nasm boot.asm -o boot.img -l boot.lst
