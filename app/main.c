#include "board.h"

int main(void)
{
    int st = 0;

    p_func boot_main=(p_func)(AXI_DDR_BASE);

    iowr(AXI_PIO_BASE, 0x1);

    // UART 115200 8N1
    uart_puts("RISC-V CPU Boot\r\n");
    uart_puts("Receive File Via Xmodem\r\n");

    st = xmodemReceive((unsigned char *)(AXI_DDR_BASE), 256*1024*1024);

    if(st < 0) {
        uart_puts("Xmodem Receive FAIL.\r\n");
        while(1) {
            iowr(AXI_PIO_BASE, 0x1);
            mdelay(500);
            iowr(AXI_PIO_BASE, 0x2);
            mdelay(500);
        }
    } else {
        uart_puts("\rBooting @ AXI_DDR_BASE\r\n");
        boot_main();
    }

    return 0;
}

