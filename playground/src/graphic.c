// graphic.c

#include "bootpack.h"

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

void boxfill8(unsigned char *vram,
              int xsize,
              unsigned char c,
              int x0,
              int y0,
              int x1,
              int y1)
{
	int x,y;
	for (y = y0; y <= y1; y++) {
		for(x = x0; x <= x1; x++) {
			vram[y * xsize + x] = c;
		}
	}

    return;
}

void init_screen8(char *vram, int x, int y)
{
    boxfill8(vram, x, COL8_008484,  0,     0,      x -  1, y - 29);
    boxfill8(vram, x, COL8_C6C6C6,  0,     y - 28, x -  1, y - 28);
    boxfill8(vram, x, COL8_FFFFFF,  0,     y - 27, x -  1, y - 27);
    boxfill8(vram, x, COL8_C6C6C6,  0,     y - 26, x -  1, y -  1);

    boxfill8(vram, x, COL8_FFFFFF,  3,     y - 24, 59,     y - 24);
    boxfill8(vram, x, COL8_FFFFFF,  2,     y - 24,  2,     y -  4);
    boxfill8(vram, x, COL8_848484,  3,     y -  4, 59,     y -  4);
    boxfill8(vram, x, COL8_848484, 59,     y - 23, 59,     y -  5);
    boxfill8(vram, x, COL8_000000,  2,     y -  3, 59,     y -  3);
    boxfill8(vram, x, COL8_000000, 60,     y - 24, 60,     y -  3);

    boxfill8(vram, x, COL8_848484, x - 47, y - 24, x -  4, y - 24);
    boxfill8(vram, x, COL8_848484, x - 47, y - 23, x - 47, y -  4);
    boxfill8(vram, x, COL8_FFFFFF, x - 47, y -  3, x -  4, y -  3);
    boxfill8(vram, x, COL8_FFFFFF, x -  3, y - 24, x -  3, y -  3);

    return;
}


void putfont_8(char *vram, int xsize, int x, int y, char c, char *font)
{
	int i;
	char *p, d; // data
	for(i = 0; i < 16; i++) {
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

void init_mouse_cursor8(char *mouse, char background_color)
{
    static char cursor[16][16] = {
        "**************..",   // 1
        "*ooooooooooo*...",   // 2
        "*oooooooooo*....",   // 3
        "*ooooooooo*.....",   // 4
        "*oooooooo*......",   // 5
        "*ooooooo*.......",   // 6
        "*ooooooo*.......",   // 7
        "*oooooooo*......",   // 8
        "*oooo**ooo*.....",   // 9
        "*ooo*..*ooo*....",   // 10
        "*oo*....*ooo*...",   // 11
        "*o*......*ooo*..",   // 12
        "**........*ooo*.",   // 13
        "*..........*ooo*",   // 14
        ".. .........*oo*",   // 15
        ".............***",   // 12
    };

    int x, y;

    for(y=0; y < 16; y++) {
        for(x=0; x < 16; x++) {
            if(cursor[y][x] == '*') {
                mouse[y * 16 + x] = COL8_000000;
            }
            if(cursor[y][x] == 'o') {
                mouse[y * 16 + x] = COL8_FFFFFF;
            }
            if(cursor[y][x] == '.') {
                mouse[y * 16 + x] = background_color;
            }
        }
    }

    return;
}

void putblock8_8(char *vram, // 0xa0000
    int vxsize, // 320
    int pxsize,
    int pysize,
    int px0,
    int py0,
    char *buf,
    int bxsize)
{
    int x, y;

    for(y = 0; y < pysize; y++) {
        for(x = 0; x < pxsize; x++) {
            vram[(py0+y) * vxsize + (px0+x)] = buf[y * bxsize + x];
        }
    }

    return;
}
