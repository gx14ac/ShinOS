extern void io_hlt(void);
extern void io_cli(void);
extern void io_out8(int port, int data);
extern int  io_load_eflags(void);
extern void io_store_eflags(int eflags);

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);

void HariMain(void)
{

    // 0xa0000 ~ 0xaffff(VRAM ADDR)
    for (int i = 0xa0000; i <= 0xaffff; i++) {
        *((char *) i) = i & 0x0f;
    }

    for(;;) {
        io_hlt();
    }
}

void init_palette(void)
{
    static unsigned char table_rgb[16 * 3] = {
        0x00, 0x00, 0x00,   // 000000 : 0 : black
        0xff, 0x00, 0x00,   // ff0000 : 1 : light red
        0x00, 0xff, 0x00,   // 00ff00 : 2 : light green
        0xff, 0xff, 0x00,   // ffff00 : 3 : yellow
        0x00, 0x00, 0xff,   // 0000ff : 4 : light blue
        0xff, 0x00, 0xff,   // ff00ff : 5 : light purple
        0x00, 0xff, 0xff,   // 00ffff : 6 : light blue
        0xff, 0xff, 0xff,   // ffffff : 7 : white
        0xc6, 0xc6, 0xc6,   // c6c6c6 : 8 : light gray
        0x84, 0x00, 0x00,   // 840000 : 9 : dark red
        0x00, 0x84, 0x00,   // 008400 : 10: dark green
        0x84, 0x84, 0x00,   // 848400 : 11: dark yellow
        0x00, 0x00, 0x84,   // 000084 : 12: dark blue
        0x84, 0x00, 0x84,   // 840084 : 13: dark purple
        0x00, 0x84, 0x84,   // 008484 : 14: dark light blue
        0x84, 0x84, 0x84,   // 848484 : 15: dark gray
    };

    set_palette(0, 15, table_rgb);

    return;
}

void set_palette(int start, int end, unsigned char *rgb)
{
    int i, eflags;
    eflags = io_load_eflags(); // saving enable interrupt flag
    io_cli();                  // set 0 to interrupt flag, disable interrupt
    io_out8(0x03c8, start);
    for (i = start; i <= end; i++) {
        io_out8(0x03c9, rgb[0] / 4);
        io_out8(0x03c9, rgb[1] / 4);
        io_out8(0x03c9, rgb[2] / 4);
        rgb += 3;
    }
    io_store_eflags(eflags); // undo interrupt flag
    return;
}
