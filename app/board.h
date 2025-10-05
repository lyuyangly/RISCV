#ifndef BOARD_H
#define BOARD_H

#include <stdint.h>
#include <stdlib.h>
#include "riscv_csr.h"

#define AXI_DDR_BASE    0x00000000
#define AXI_RAM_BASE    0x20000000
#define AXI_UART_BASE   0x21000000
#define AXI_PIO_BASE    0x22000000

typedef void (*p_func)(void);

extern void udelay(uint32_t);
extern void mdelay(uint32_t);
extern void uart_tx_byte(uint8_t);
extern int32_t uart_rx_byte(uint32_t);
extern void uart_puts(const char *);
extern int xmodemReceive(unsigned char*, int);

#endif

