#include <stdint.h>
#include <stdlib.h>
#include <stdarg.h>
#include "riscv_csr.h"
#include "board.h"

//extern int vsscanf(const char *, const char *, va_list);
//extern int vsprintf(const char *, const char *, va_list);

void uart_tx_byte(uint8_t ch)
{
    uint8_t tmp;

    do {
        tmp = iord(AXI_UART_BASE + 0x8);
    } while((tmp & 0x04) == 0x00);

    iowr(AXI_UART_BASE + 0x4, ch);
}

int32_t uart_rx_byte(uint32_t timeout)
{
    uint32_t tmp;

    do {
        tmp = iord(AXI_UART_BASE + 0x8);
        if ((tmp & 0x01) == 0x01) {
            return iord(AXI_UART_BASE + 0x0) & 0x0FF;
        } else {
            mdelay(1);
        }
    } while(timeout--);

    return -1;
}

void uart_puts(const char *str)
{
    while(*str) {
        uart_tx_byte(*str++);
    }
}

/*
int scanf(const char *fmt, ...)
{
    int i = 0;
    unsigned char ch;
    char buf[80];
    va_list args;

    while(1) {
        ch = uart_rx_byte(1);
        if (ch >= 0) {
            uart_tx_byte(ch);
            if(ch == '\n' || ch == '\r') {
                buf[i] = '\0';
                break;
            } else {
                buf[i++] = ch;
            }
        }
    }

    va_start(args, fmt);
    i = vsscanf(buf, fmt, args);
    va_end(args);
    uart_tx_byte('\r');
    uart_tx_byte('\n');
    return i;
}

int printf(const char *fmt, ...)
{
    int i = 0;
    unsigned int n = 0;
    char buf[80];
    va_list args;

    va_start(args, fmt);
    n = vsprintf(buf, fmt, args);
    va_end(args);

    for(i = 0; i < n; ++i) {
        uart_tx_byte(buf[i]);
    }
    return n;
}
*/

