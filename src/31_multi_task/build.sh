#! /bin/sh

KERNEL_FILE="kernel.asm"

if [ -e $KERNEL_FILE ]; then
    rm -rf boot.bin boot.lst kernel.bin kernel.lst
    nasm boot.asm -o boot.bin -l boot.lst
    nasm kernel.asm -o kernel.bin -l kernel.lst

    cat boot.bin kernel.bin > boot.img
fi
    nasm boot.asm -o boot.img -l boot.lst
