// int.c
#include "bootpack.h"

// Master & Slave PIC
void init_pic(void)
{
    // interrupt mask register;
    io_out8(PIC0_IMR, 0xff); // Don't Accept All interrupts
    io_out8(PIC1_IMR, 0xff); // Don't Accept All interrupts

    // initial control word
    io_out8(PIC0_ICW1, 0x11); // fixed : edge trigger mode
    io_out8(PIC0_ICW2, 0x20); // IRQ0-7 receive at INT20-27
    io_out8(PIC0_ICW3, 1 << 2); // PIC1 connects to PIC2
    io_out8(PIC0_ICW4, 0x01); // fixed : nonbuffer addresse

    io_out8(PIC1_ICW1, 0x11); // fixed : edge trigger mode
    io_out8(PIC1_ICW2, 0x28); // IRQ0-7 receive at INT20-27
    io_out8(PIC1_ICW3, 2);    // PIC1 connects to PIC2
    io_out8(PIC1_ICW4, 0x01); // fixed : nonbuffer mode

    io_out8(PIC0_IMR, 0xfb); // 11111011 All except PIC1 are prohibited
    io_out8(PIC1_IMR, 0xff); // 11111111 Not accepting all interrupts

    return;
}

/*
  - interrupt Keyboard
 */
void int_handler21(int *esp)
{
    struct BootInfo *binfo = (struct BootInfo *) BOOTINFO_ADDR;
    boxfill_8(binfo->vram, binfo->scrnx, COL8_000000, 0, 0, 32 * 8 - 1, 15);
    putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, "INT 21(IRQ-1) : PS/2 keyboard");
    for (;;) {
        io_hlt();
    }
}


/*
  - interrupt mouse
 */
void int_handler2c(int *esp)
{
    struct BootInfo *binfo = (struct BootInfo *) BOOTINFO_ADDR;
    boxfill_8(binfo->vram, binfo->scrnx, COL8_000000, 0, 0, 32 * 8 - 1, 15);
    putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, "INT 2C (IRQ-12) : PS/2 mouse");
    for (;;) {
        io_hlt();
    }
}

/*
  - Measures against incomplete interrupt from PIC0
 */
void int_handler27(int *esp)
{
    io_out8(PIC0_OCW2, 0x67);
    return;
}
