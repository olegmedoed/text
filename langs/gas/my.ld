OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS {
/*  . is location counter, def val = 0 */
/*  * means file with any name, (.text) means section .text from those files */
    . = SEGMENT_START("text-segment", 0x08048000) + SIZEOF_HEADERS;
    .text : { *(.text) }
    .data : { *(.data) }
/*  .bss : { *(.bss) }  */    
}
