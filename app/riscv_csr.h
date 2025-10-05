#ifndef RISCV_CSR_H
#define RISCV_CSR_H

#define CSR_FCSR		0x003
#define CSR_CYCLE		0xc00
#define CSR_TIME		0xc01
#define CSR_INSTRET		0xc02
#define CSR_SSTATUS		0x100
#define CSR_SIE			0x104
#define CSR_STVEC		0x105
#define CSR_SCOUNTEREN	0x106
#define CSR_SSCRATCH	0x140
#define CSR_SEPC		0x141
#define CSR_SCAUSE		0x142
#define CSR_STVAL		0x143
#define CSR_SIP			0x144
#define CSR_SATP		0x180
#define CSR_MSTATUS		0x300
#define CSR_MISA		0x301
#define CSR_MIE			0x304
#define CSR_MTVEC		0x305
#define CSR_MCOUNTEREN  0x306
#define CSR_MSCRATCH	0x340
#define CSR_MEPC		0x341
#define CSR_MCAUSE		0x342
#define CSR_MTVAL		0x343
#define CSR_MIP			0x344
#define CSR_CYCLEH		0xc80
#define CSR_TIMEH		0xc81
#define CSR_INSTRETH    0xc82
#define CSR_MHARTID		0xf14

#define __RISCV_STR(str) #str

#define iowr(addr, data) (*((volatile uint32_t *)(addr)) = (data))
#define iord(addr) (*((volatile uint32_t *)(addr)))

#define csr_swap(csr, val) \
({ \
    unsigned long __v = (unsigned long)(val); \
    __asm__ __volatile__ ("csrrw %0, " __RISCV_STR(csr) ", %1" : "=r" (__v) : "rK" (__v)); \
    __v; \
})

#define csr_read(csr) \
({ \
    register unsigned long __v; \
    __asm__ __volatile__ ("csrr %0, " __RISCV_STR(csr) : "=r" (__v)); \
    __v; \
})

#define csr_write(csr, val) \
({ \
    unsigned long __v = (unsigned long)(val); \
    __asm__ __volatile__ ("csrw " __RISCV_STR(csr) ", %0" : : "rK" (__v)); \
})

#define csr_set(csr, val) \
({ \
    unsigned long __v = (unsigned long)(val); \
    __asm__ __volatile__ ("csrs " __RISCV_STR(csr) ", %0" : : "rK" (__v)); \
})

#define csr_clear(csr, val) \
({ \
    unsigned long __v = (unsigned long)(val); \
    __asm__ __volatile__ ("csrc " __RISCV_STR(csr) ", %0" : : "rK" (__v)); \
})

#define csr_read_set(csr, val) \
({ \
    unsigned long __v = (unsigned long)(val); \
    __asm__ __volatile__ ("csrrs %0, " __RISCV_STR(csr) ", %1" : "=r" (__v) : "rK" (__v)); \
    __v; \
})

#define csr_read_clear(csr, val) \
({ \
    unsigned long __v = (unsigned long)(val); \
    __asm__ __volatile__ ("csrrc %0, " __RISCV_STR(csr) ", %1" : "=r" (__v) : "rK" (__v)); \
	__v; \
})

#endif /* RISCV_CSR_H */

