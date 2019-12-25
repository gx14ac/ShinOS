OUTPUT_FORMAT("binary");

SECTIONS
{
    .head 0x0 : {
         LONG(64 * 1024)        /* 0  : stack + data + heap size */
         LONG(0x69726148)       /* 4  : signature "Shin"  */
         LONG(0)                /* 8  : mmarea size */
         LONG(0x310000)         /* 12 : stack initialize value & destination data */
         LONG(SIZEOF(.data))    /* 16 : data size */
         LONG(LOADADDR(.data))  /* 20 : data initialize position */
         LONG(0xE9000000)       /* 0xE9000000 */
         LONG(HariMain - 0x20)  /* entry address - 0x20 */
         LONG(0)                /* heap size. start addr */
    }

    .text : { *(.text) }

    .data 0x310000 : AT ( ADDR(.text) + SIZEOF(.text) ) {
          *(.data)
          *(.rodata*)
          *(.bss)
    }

    /DISCARD/ : { *(.eh_frame) }
}
