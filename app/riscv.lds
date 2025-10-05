OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 8K
}

STACK_SIZE = 2K;
HEAP_SIZE  = 1K;

SECTIONS
{
    .text : ALIGN(4)
    {
        __start_addr = .;
        KEEP(*(.text.entry))
        . = ALIGN(4);
        *(.text*)
        . = ALIGN(4);
       __text_end = .;
    } > RAM

    .data : ALIGN(4)
    {
        __data_start = .;
        *(.rodata*)
        *(.srodata*)
        *(.data*)
        *(.sdata*)
        . = ALIGN(4);
        __data_end = .;
        __gp = . + 0x100;
    } > RAM

    .bss : ALIGN(4)
    {
        __bss_begin = .;
        *(.sbss*)
        *(.scommon)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > RAM
    _end = .;

    .stack : ALIGN(4)
    {
        __stack_bottom = .;
        . += STACK_SIZE;
        __stack_top = .;
    } > RAM

    .heap : ALIGN(4)
    {
        __heap_begin = .;
        . += HEAP_SIZE;
        __heap_end = .;
    } > RAM
}

/*
SECTIONS
{
    .text : ALIGN(4)
    {
        __start_addr = .;
        KEEP(*(.text.entry))
        . = ALIGN(4);
        *(.text*)
        . = ALIGN(4);
       __text_end = .;
    } > RAM

    .rodata : ALIGN(4)
    {
        __rodata_start = .;
        *(.rodata*)
        *(.srodata*)
        . = ALIGN(4);
        __rodata_end = .;
        __load_start = .;
    } > RAM

    .data : AT(ADDR(.text)+SIZEOF(.text)+SIZEOF(.rodata))
    {
        __data_start = .;
        *(.data*)
        *(.sdata*)
        . = ALIGN(4);
        __data_end = .;
        __gp = . + 0x100;
    } > RAM

    .bss : ALIGN(4)
    {
        __bss_begin = .;
        *(.sbss*)
        *(.scommon)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > RAM
    _end = .;

    .stack : ALIGN(4)
    {
        __stack_bottom = .;
        . += STACK_SIZE;
        __stack_top = .;
    } > RAM

    .heap : ALIGN(4)
    {
        __heap_begin = .;
        . += HEAP_SIZE;
        __heap_end = .;
    } > RAM
} */

