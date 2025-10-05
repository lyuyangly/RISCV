#include <stdint.h>
#include "riscv_csr.h"

#define RISCV_CLOCK_MHZ 100UL

static uint64_t riscv_timer_get_count(void)
{
    uint32_t hi, lo;

    do {
        hi = csr_read(CSR_TIMEH);
        lo = csr_read(CSR_TIME);
    } while (hi != csr_read(CSR_TIMEH));

    return ((uint64_t)hi << 32) | lo;
}

void udelay(uint32_t delay)
{
    uint64_t current, target;

    current = riscv_timer_get_count();
    target = current + RISCV_CLOCK_MHZ * delay;

    do {
        current = riscv_timer_get_count();
    } while (current < target);
}

void mdelay(uint32_t delay)
{
    udelay(delay * 1000UL);
}

