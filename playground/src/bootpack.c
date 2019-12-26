extern void io_hlt(void);
extern void io_cli(void);
extern void io_out8(int port, int data);
extern int  io_load_eflags(void);
extern void io_store_eflags(int eflags);

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);
void boxfill_8(unsigned char *vram,
              int xsize,
              unsigned char c,
              int x0,
              int y0,
              int x1,
              int y1);

void init_screen(char *vram, int x, int y);
void put_font8(char *vram, int xsize, int x, int y, char c, char *font);
void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s);

extern void sprintf(char *str, char *fmt, ...);

#define COL8_000000     0
#define COL8_FF0000     1
#define COL8_00FF00     2
#define COL8_FFFF00     3
#define COL8_0000FF     4
#define COL8_FF00FF     5
#define COL8_00FFFF     6
#define COL8_FFFFFF     7
#define COL8_C6C6C6     8
#define COL8_840000     9
#define COL8_008400     10
#define COL8_848400     11
#define COL8_000084     12
#define COL8_840084     13
#define COL8_008484     14
#define COL8_848484     15

struct BootInfo {
    char cyls, leds, vmode, reserve;  // 1 byte
    short scrnx, scrny;               // 2 byte
    char *vram;                       // 4 byte
};

void HariMain(void)
{
    struct BootInfo *binfo = (struct BootInfo *) 0x0ff0;
//    extern char hankaku[4096];
    char s[40];

    init_palette();
    init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
    putfonts8_asc(binfo->vram, binfo->scrnx,  8,  8, COL8_FFFFFF, "ABC 123");
    putfonts8_asc(binfo->vram, binfo->scrnx, 31, 31, COL8_000000, "Haribote OS");   // ‰e
    putfonts8_asc(binfo->vram, binfo->scrnx, 30, 30, COL8_FFFFFF, "Haribote OS");   // ”’‚¢•¶Žš

    sprintf(s, "scrnx = %d", binfo->scrnx);
    putfonts8_asc(binfo->vram, binfo->scrnx, 16, 64, COL8_FFFFFF, s);
    for (;;) {
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

void boxfill_8(unsigned char *vram,
              int xsize,
              unsigned char c,
              int x0,
              int y0,
              int x1,
              int y1)
{
    for (int y = y0; y <= y1; y++) {
        for (int x = x0; x <= x1; x++) {
            vram[y * xsize + x] = c;
        }
    }

    return;
}

void init_screen(char *vram, int x, int y)
{
    boxfill_8(vram, x, COL8_008484,  0,     0,      x -  1, y - 29);
    boxfill_8(vram, x, COL8_C6C6C6,  0,     y - 28, x -  1, y - 28);
    boxfill_8(vram, x, COL8_FFFFFF,  0,     y - 27, x -  1, y - 27);
    boxfill_8(vram, x, COL8_C6C6C6,  0,     y - 26, x -  1, y -  1);

    boxfill_8(vram, x, COL8_FFFFFF,  3,     y - 24, 59,     y - 24);
    boxfill_8(vram, x, COL8_FFFFFF,  2,     y - 24,  2,     y -  4);
    boxfill_8(vram, x, COL8_848484,  3,     y -  4, 59,     y -  4);
    boxfill_8(vram, x, COL8_848484, 59,     y - 23, 59,     y -  5);
    boxfill_8(vram, x, COL8_000000,  2,     y -  3, 59,     y -  3);
    boxfill_8(vram, x, COL8_000000, 60,     y - 24, 60,     y -  3);

    boxfill_8(vram, x, COL8_848484, x - 47, y - 24, x -  4, y - 24);
    boxfill_8(vram, x, COL8_848484, x - 47, y - 23, x - 47, y -  4);
    boxfill_8(vram, x, COL8_FFFFFF, x - 47, y -  3, x -  4, y -  3);
    boxfill_8(vram, x, COL8_FFFFFF, x -  3, y - 24, x -  3, y -  3);

    return;
}

void putfont_8(char *vram, int xsize, int x, int y, char c, char *font)
{
    char d;
    char *p;

    for (int i = 0; i < 16; i++) {
        p = vram + (y + i) * xsize + x;
        d = font[i];

        if ((d & 0x80) != 0) { p[0] = c; }
        if ((d & 0x40) != 0) { p[1] = c; }
        if ((d & 0x20) != 0) { p[2] = c; }
        if ((d & 0x10) != 0) { p[3] = c; }
        if ((d & 0x08) != 0) { p[4] = c; }
        if ((d & 0x04) != 0) { p[5] = c; }
        if ((d & 0x02) != 0) { p[6] = c; }
        if ((d & 0x01) != 0) { p[7] = c; }
    }

    return;
}

void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s)
{
    extern char hankaku[4096];
    for (; *s != 0x00; s++) {
        putfont_8(vram, xsize, x, y, c, hankaku + *s * 16);
        x += 8;
    }

    return;
}
