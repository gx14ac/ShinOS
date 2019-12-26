#include <stdarg.h>

// Transfer Decimal to ASCII
int transfer_decimal_2_asc (char *str, int dec)
{
    int len = 0, len_buf;
    int buf[10];

    while(1) {
        buf[len++] = dec % 10;
        if (dec < 10) break;
        dec /= 10;
    }
    len_buf = len;

    while(len) {
        *(str++) = buf[--len] + 0x30;
    }

    return len_buf;
}

// Transfer Hex to ASCII
int transfer_hex_2_asc(char *str, int dec)
{
    int len = 0, len_buf;
    int buf[10];
    while (1) {
        buf[len++] = dec % 16;
        if (dec < 16) break;
        dec /= 16;
    }
    len_buf = len;

    while(len) {
        len--;
        *(str++) = (buf[len]<10) ? (buf[len] + 0x30) : (buf[len] - 9 + 0x60);
    }

    return len_buf;
}

// sprintf
void sprintf(char *str, char *fmt, ...)
{
    va_list list;
    int i, len;
    va_start(list, 2);

    while (*fmt) {
        if(*fmt == '%') {
            fmt++;
            switch(*fmt) {
            case 'd':
                len = transfer_decimal_2_asc(str, va_arg(list, int));
                break;
            case 'x':
                len = transfer_hex_2_asc(str, va_arg(list, int));
                break;
            }
            str += len; fmt++;
        } else {
            *(str++) = *(fmt++);
        }
    }

    *str = 0x00;
    va_end(list);
}
