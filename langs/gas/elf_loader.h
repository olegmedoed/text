#ifndef ELF_LOADER_H
#define ELF_LOADER_H

#include "runtime/types.h"
#include "process.h"

// +-------------------------+-----------------------+
// | elf header              | elf header            |
// |-------------------------------------------------|
// | Programm header table   | Programm header table |
// |    (optional)           |                       |
// |-------------------------+-----------------------|
// | Section 1               | Segment 1             |
// |-------------------------+                       |
// | Section 2               |                       |
// |-------------------------+-----------------------|
// |   ............          |   .......             |
// |-------------------------+-----------------------|
// | Section header table    | Section header table  |
// |                         |   (optional)          |
// +-------------------------+-----------------------+
//
// Although the figure shows the program header table immediately after the ELF
// header, and the section header table following the sections, actual files may
// differ. Moreover, sections and segments have no specified order. Only the ELF
// header has a fixed position in the file.

// Main processors ELF supports is 8-bit bytes and 32-bit arch, but it is
// intended to be extensible to (larger|smaller) archs. Therefore obj.file
// represent some control data with a machine-independent format, making it
// possible to identify obj.files and interpret their contents in a common way.
// Remaining data in an obj.file use the encod of the target processor,
// regardless of the machine on which the file was created.
// Data also have suitable alignment from the beginning of the file.[exmp] a
// structure containing an Elf32_Addr member will be aligned on a 4-byte
// boundary within the file.
// For portability reasons, ELF uses no bit-fields.
#ifdef PROC32
typedef Elf_Addr    u32; // Unsigned programm address (alignment should be 4)
typedef Elf_Half    u16; // Unsigned medium integer   (alignment should be 2)
typedef Elf_Off     u32; // Unsigned file offset      (alignment should be 4)
typedef Elf_Sword   s32; // Signed large integer      (alignment should be 4)
typedef Elf_Word    u32; // Unsigned large integer    (alignment should be 4)
#else
#error "you should specify correct architecture"
#endif

///            =======  ELF Header  =======

// Some obj.file control.structs can grow, because the ELF header contains their
// actual sizes. If the obj.file format changes, a program may encounter control 
// structs that are larger or smaller than expected

#define EI_NIDENT 16

typedef struct {
    // mark the file as an obj.file and provide machine-indep data with which to
    // decode and interpret the file’s contents.
    unsigned char e_ident[EI_NIDENT];  // equal to EI_*
    Elf_Half e_type;                   // equal to ET_*
    Elf_Half e_machine;                // equal to EM_*
    Elf_Word e_version;                // equal to EV_*
    // virt.addr to which the system first transfers control, thus starting the
    // process. If the file has no associated entry point, this member holds 0.
    Elf_Addr e_entry;
    Elf_Off  e_phoff;   // pro.header file offset in bytes | null
    Elf_Off  e_shoff;   // sec.header file offset in bytes | null
    Elf_Word e_flags;   // processor-specific flags associated with the file,
                        // flag names take the form EF_machine_flag.
    Elf_Half e_ehsize;  // Elf header size in bytes
    Elf_Half e_phentsize; // size in bytes of one entry in the file’s program
                          // header table; all entries are the same size
    Elf_Half e_phnum;     // number of entries in the prog.header table, thus
                // the e_phentsize * e_phnum gives the table’s size in bytes.
                // file has no pro.header table => e_phnum == 0
    Elf_Half e_shentsize; // sec.header’s size in bytes. A sec.header is one
            // entry in the section header table; all entries are the same size
    Elf_Half e_shnum;
    Elf_Half eshstrndx; // section header table index of the entry associated 
                // with the section name string table
                // the file has no section name string table => SHN_UNDEF
} Elf_Ehdr;

// e_ident[] identification indexes
//
#define EI_MAG0     0 // file identation e_ident[EI_MAG0] = ELFMAG0 = 0x7f
#define EI_MAG1     1 // file identation e_ident[EI_MAG1] = ELFMAG1 = 'E'
#define EI_MAG2     2 // file identation e_ident[EI_MAG2] = ELFMAG2 = 'L
#define EI_MAG3     3 // file identation e_ident[EI_MAG3] = ELFMAG3 = 'F
#define EI_CLASS    4 // file class or capacity
#define EI_DATA     5 // data encoding (lsb on my netbook)
#define EI_VERSION  6 // file version (0 in my netbook)
// in specification 7.. bytes are padding, in wiki(and my netbook) we have
#define EI_OSABI    7
// Its interpretation depends on the target ABI. Linux kernel (> 2.6) has no
// definition of it. In that case, offset and size of EI_PAD are 8
#define EI_ABIVERSION 8
#define EI_PAD      8  // 7(off.doc) start of padding bytes(reserved, eq to 0) 
#define EI_NIDENT   16 // size of e_ident[]

// Magic
#define ELFMAG0 0x7f
#define ELFMAG1 'E'
#define ELFMAG1 'L'
#define ELFMAG1 'F'
// EI_CLASS - file class or capacity
#define ELFCLASSNONE  0
#define ELFCLASS32    1
#define ELFCLASS64    2
// EI_DATA - the data encoding of the processor-specific data in the obj.file
#define ELFDATANONE   0 // invalid data encoding
#define ELFDATA2LSB   1 // 0x01020304 [04|03|02|01]
#define ELFDATA2MSB   2 // 0x01020304 [01|02|03|04]
// OSABI version
#define ELFOSABISYSV 0    // in my netbook
#define ELFOSABILINUX 3


// e_type
// 
// Core file contents are unspecified, but type ET_CORE is reserved to mark the
// file. Vals from ET_LOPROC through ET_HIPROC (inclusive) are reserved for pro-
// cessor-specific semantics. Other vals are reserved and will be used if need.
#define ET_NONE   0       // No file type
#define ET_REL    1       // Relocatable file
#define ET_EXEC   2       // Executable file
#define ET_DYN    3       // Shared object file
#define ET_CORE   4       // Core file
#define ET_LOPROC 0xff00  // Processor-specific
#define ET_HIPROC 0xffff  // Processor-specific

// Processor-specific ELF names use the machine name to distinguish them.
// [exmp] the flags mentioned below use the prefix EF_; a flag named WIDGET for
// the EM_XYZ machine would be called EF_XYZ_WIDGET.
#define EM_NONE 0     // No machine
#define EM_386  0x3   // intel 80386  (my netbook)
#define EM_ARM  0x28
#define EM_x64  0x3E
#define EM_ia64 0x32
// if e_machine == EM_386   =>    e_ident[EI_CLASS] == ELFCLASS32
//                          &&    e_ident[EI_DATA]  == ELFDATA2LSB
// .. for others see ELF:p9

// Elf version (in elf header)
#define EV_NONE     0
#define EV_CURRENT  1

///         =======  SECTION HEADERs  ========
//
// The section header table is an array of Elf32_Shdr structures
// The ELF header’s:
// -  e_shoff   member gives the byte offset from the beginning of the file to
//    the section header table;
// -  e_shnum   tells how many entries the section header table contains;
// -  e_shentsize   gives the size in bytes of each entry.

// Some section header table indexes are reserved; an obj.file will not have 
// sections for these special indexes.
#define SHN_UNDEFF      0      // val of this section header is irrelevant
#define SHN_LORESERVE   0xff00
#define SHN_LOPROC      0xff00 // LOPROC..HIPROC reserved for processor-specific
#define SHN_HIPROC      0xffff // semantics 
#define SHN_ABS         0xfff1 // abs val for corresponding reference. [exmp]
                    // symbols defined relative to section number SHN_ABS have
                    // absolute values and are not affected by relocation
#define SHN_COMMON      0xfff2 // Symbols defined relative to this section are
                    // common symbols, such as unallocated C external vars
#define SHN_HIRESERVE   0xffff // the section header table does not contain
                    // entries for the reserved indexes.

// Although index 0 is reserved as the undef.val, the section header table 
// contains an entry for index 0. if the e_shnum member of the ELF header says
// a file has 6 entries in the section header table, they have the indexes 0..5.

// Obj.files' sections satisfy several conditions: (@ - every | each)
// - @section in an obj.file has 1 section header describing it. Section
//   headers may exist that do not have a section.
// - @section occupies one contiguous(possibly empty) seq of bytes within a file
// - sections in a file may not overlap. No byte in a file resides in more than
//   one section [eng: may not - categorically "should not"]
// - An obj.file may have inactive space. The various headers and the sections
//   might not "cover" every byte in an obj.file. The contents of the inactive
//   data are UNSPECIFIED

typedef struct {  /* Section header structure */
    // The obj.file uses strings in .shstrtab(string table section) to represent
    // symbol and section names. sh_name is index in .shstratab, giving the ...
    Elf_Word sh_name;   // ... location of \0-terminated string
    Elf_Word sh_type;   // categorizes section content and semantic
    Elf_Word sh_flags;
    Elf_Addr sh_addr;   // if the section will appear in the memory image of a
    // process it gives the address at which the section's first byte should
    // reside. Otherwise 0
    Elf_Off  sh_offset; // byte offset from the beginning of the file to the
                        // first byte in the section
    Elf_Word sh_size;   // size in bytes unless the section type is SHT_NOBITS
    // section of type SHT_NOBITS may have size!=0, but it occupies no space in
    // the file
    Elf_Word sh_link;   // section header table index link
    Elf_Word sh_info;
    Elf_Word sh_addralign; // [exmp] if a section holds a doubleword, the system
    // must ensure doubleword alignment for the entire section. That is, the
    // val of sh_addr must be congruent to 0, modulo the val of sh_addralign.
    // Currently, only 0 and positive integral powers of two are allowed. Vals 0
    // and 1 mean the section has no alignment constraints.
    // [exmp from me: when I write ".align 4" in .data section sh_addralign
    // become 4 instead of 1 (see lang/gas/start.s), also CLANG set sh_addalign
    // in .text on 0x10 since it max size of x86 instruction]
    Elf_Word sh_entsize;// if sections hold a table of fixed-size entries, such
    // as a symbol table(so, sh_entsize == size in bytes of each entry)   || 0
} Elf_Shdr;

// Elf_Shdr.sh_type (Elf_Word)     (sh - section header)
typedef enum {
//  sh is inactive(have no associated sec, other members of sh have undef vals
    SHT_NULL,       //  0
//  sec.info format and meaning are determined solely by the program.
    SHT_PROGBITS,   //  1
//  (v- and SHT_DYNSYM)
//  SHT_SYMTAB provides syms for link editing, though it may also be used for
//  dynamic linking. As a complete sym table, it may contain many syms unneces-
//  sary for dyn.linking. So, an obj.file may also contain a SHT_DYNSYM sec,
//  which holds a minimal set of dynamic linking symbols, to save space.
//  [AFAIU: stings what represents the sym is placed in .strtab section elf:p21]
    SHT_SYMTAB,     //  2       (only 1 now!)
//  object file may have multiple string table sections.
    SHT_STRTAB,     //  3       (multiple)
//  relocation entries with explicit addends, such as type Elf32_Rela for the
//  32-bit class of obj.files.
    SHT_RELA,       //  4       (multiple)
//  sym hash table. All objs participating in dynamic linking must contain a sym
//  hash table. Currently, an obj file may have only one hash table(now!)
    SHT_HASH,       //  5       (only 1 now!)
//  info for dyn.linking. Currently, an obj.file may have only one dyn.sec
    SHT_DYNAMIC,    //  6       (only 1 now!)
//  info that marks the file in some way (see Note Section)
    SHT_NOTE,       //  7
//  sec occupies no space in the file but otherwise resembles SHT_PROGBITS
//  Although sec contains no bytes, the sh_offset member contains the conceptual
//  file offset
    SHT_NOBITS,     //  8
//  relocation entries without explicit addends, such as type Elf32_Rel for the
//  32-bit class of obj.files. An obj.file may have multiple relocation sections
    SHT_REL,        //  9       (multiple)
//  reserved, but has unspecified semantics
//  programs that contain a section of this type do not conform to the ABI.
    SHT_SHLIB,      //  10    
    SHT_DYNSYM,     //  11
    SHT_LOPROC = 0x70000000, // vals in this inclusive range are reserved for
    SHT_HIPROC = 0x7fffffff, // processor-specific semantics.
    SHT_LOUSER = 0x80000000, // section types between SHT_LOUSER and SHT_HIUSER
    sht_HIUSER = 0xffffffff, // may be used by the application, without
            // conflicting with current or future system-defined section types.
} ElfSectionType;
// Other section type vals are reserved

// Elf_Shdr.sh_flags  (Elf_Word)
#define SHF_WRITE     0x1
// ^-- sec contains data that should be writable during process execution
#define SHF_ALLOC     0x2
// ^-- sec occupies memory during process execution. Some control secs do not
// reside in the memory image of an obj.file; this attr is off for those secs
#define SHF_EXECINSTR 0x4
// ^-- sec contains executable machine instructions
#define SHF_MS        0x30  // (48)
// ^-- .comment has such flags (Merge String) 0x10(16) | 0x20(32)
#define SHF_MERGE     // 0x20 | 0x10
#define SHF_STRING    // 0x20 | 0x10
#define SHF_MASKPROC  0xf0000000
// ^-- all bits included in this mask are reserved for pro-sor-specific semantics

//            (sh -section header)
//    sh_type  |           sh_link               |       sh_info
// ------------+---------------------------------+----------------------------
// SHT_DYNAMIC | The sh index of the string table| 0
//             |  used by entries in the section.|
// ------------+---------------------------------+----------------------------
// SHT_HASH    | The sh index of the sym table   | 0
//             | to which the hash table applies |
// ------------+---------------------------------+-----------------------------
// SHT_REL     | The sh index of the associated  | The sh index of the section
// SHT_RELA    | symbol table                    | to which the relocation 
//             |                                 | applies.
// ------------+---------------------------------+-----------------------------
// SHT_SYMTAB  | The sh index of the associated  | One greater than the sym
// SHT_DYNSYM  | string table                    | table index of the last local
//             |                                 | sym(binding STB_LOCAL).
// ------------+---------------------------------+-----------------------------
// other       | SHN_UNDEF                       | 0
// ------------+---------------------------------+-----------------------------

// SEE ALSO elf:p19 types and flag.attributes for commong sections

//  Section names with a '.' prefix are reserved for the system, although apps 
//  may use these secs if their existing meanings are satisfactory. An obj.file


// symbol table holds information needed to locate and relocate a program’s
// symbolic definitions and references. index 0 both designates the first entry
// in the table and serves as the undefined symbol index.
typedef struct {
//  holds an index into the obj.file’s symb.str.table(.strtab elf:p21),
//  if 0 => the symbol table entry has no name.
//  NOTE: External C syms have the same names in C and obj.files’ sym.tables.
    Elf_Word  st_name;
//  This member gives the val of the associated sym. Depending on the context,
//  this may be an absolute val, an address, etc..
    Elf_Addr  st_value;
//  [exmp] a data obj’s size is the num of bytes contained in the obj.
//  0 if the symbol has no size or an unknown size.
    Elf_Word  st_size;
//  symbol’s type and binding attributes.
    unsigned char st_info;
//  has no defined meaning(currently 0)
    unsigned char st_other;
//  @sym.table.entry is "defined" in relation to some sec; this member holds the
//  relevant sec.header.table index. Some sec.indexes indicate special meanings.
    Elf_Half  st_stndx;
} Elf_Sym;

// manipulate Elf_Sym.st_info       (unsigned char)
#ifdef PROC32
#   define ELF_ST_BIND(i)    ((i) >> 4)
#   define ELF_ST_TYPE(i)    ((i)&0xf)
#   define ELF_ST_INFO(b,t)  (((b)<<4) + ((t)&0xf))
#else
#   error "You should specify correct architecture"
#endif
//
//  Symbol bind value (weak vs global elf:p24)
//      name        value
#define STB_LOCAL   0
// ^- local.sym are not visible outside the obj.file containing their def-tion.
#define STB_GLOBAL  1
// ^- One file’s definition of a global symbol will satisfy another file's
// undefined reference to the same global symbol.
#define STB_WEAK    2
// ^- Weak sym resemble glob.syms, but their definitions have lower precedence
#define STB_LOPROC  13  // << Val in range 13..15 reserved for 
#define STB_HIPROC  15  // processor-specific semantics.
// 
#define STT_NOTYPE    0
// the symb is associated with a data object, such as a variable, an array, etc.
#define STT_OBJECT    1
// the symb is associated with a function or other executable code.
#define STT_FUNCTION  2
// The symb is associated with a sec. Sym table entries of this type exist
// primarily for relocation and normally have STB_LOCAL binding.
#define STT_SECTION   3
#define STT_FILE      4
#define STT_LOPROC    13  // 13..15 reserved for processor-specific semantic
#define STT_HIPROC    15

typedef struct {
    Elf_Addr    r_offset;
    Elf_Word    r_info;
} Elf_Rel;

typedef struct {
    Elf_Addr    r_offset; // the location at which to apply the relocat action.
//  -relocatable file: the val is the byte offset from the beginning of
//  the section to the storage unit affected by the relocation.
//  -executable file or a shared object: the val is the virt address of the
//  storage unit affected by the relocation.
    Elf_Word    r_info; // the symbol table index with respect to which the
//  relocation must be made, and the type of relocation to apply.   [exmp]
//  a call instruction's relocation entry would hold the sym.table index of
//  the fun being called. If the index is STN_UNDEF , the undef.symb index, the
//  relocation uses 0 as the "sym value". Relocation types are pro-sor-specific
    Elf_Sword   r_addend;
} Elf_Rela;



///         =======  PROGRAM HEADERs  ========
//

// program header table is an arr of structs, each describing a seg or other
// info the system needs to prepare the program for exec
typedef struct {
    Elf_Word  p_type;
//  offset in file at which the first byte of the seg resides.
    Elf_Off   p_offset;
    Elf_Addr  p_vaddr;
//  SysV ignores p_addressing for app programs, this member has unspecified
//  contents for exec files and shared objs
    Elf_Addr  p_paddr;
//  the numb of bytes in the file image of the segment      |   zero
    Elf_Word  p_filesz;
//  the numb of bytes in the memory image of the segment    |   zero
    Elf_Word  p_memsz;
    Elf_Word  p_flags;
//  loadable process segs must have congruent vals for p_vaddr and p_offset,
//  modulo the page size. p_align gives the val to which the segs are aligned in
//  memory and in the file. (should be >1, ^2)
    Elf_Word  p_align;
} Elf_Phdr;

// Elf_Phdr.p_type
#define PT_NULL    0  // members’ values are undefined.
#define PT_LOAD    1  // loadable seg, described by p_filesz and p_memsz.
//  The bytes from the file are mapped to the beginning of the memory segment.
//  If the p_memsz is larger than the p_filesz, the "extra" bytes are defined to
//  hold the 0 and to follow the seg's initialized area. The file size may not
//  be larger than the memory size. Loadable seg entries in the program header
//  table appear in ascending order, sorted on the p_vaddr member
#define PT_DYNAMIC 2  // dynamic linking information
#define PT_INTERP  3  // the location and size of a null-terminated path name to
//  invoke as an interpreter. This seg.type is meaningful only for exec files
//  (though it may occur for shared objs); it may not occur more than once
#define PT_NOTE    4  // the location and size of auxiliary information
#define PT_SHLIB   5  // reserved but has unspecified semantics. Programs that
//  contain an arr el of this type do not conform to the ABI.
#define PT_PHDR    6  // the location and size of the program header table
//  itself, both in the file and in the memory image of the program. This seg
//  type may not occur more than once. Moreover, it may occur only if the
//  program header table is part of the memory image of the program. If it is
//  present, it must precede any loadable segment entry
#define PT_LOPROC  0x70000000 // reserved for processor-specific semantics
#define PT_HIPROC  0x7fffffff
//
//  Unless specifically required elsewhere, all program header segment types are
// optional. i.e, a file’s program header table may contain only those els
// relevant to its contents.

// Elf_Phdr.p_flags                   Allowed
#define PF_X         0x1          // read, exec
#define PF_W         0x2          // read, write, exec
#define PF_WX        0x3          // read, write, exec
#define PF_R         0x4          // read, exec
#define PF_RX        0x5          // read, exec
#define PF_RW        0x6          // read, write, exec
#define PF_RWX       0x7          // read, write, exec
#define PF_MASKOS    0x0ff00000 
#define PF_MASKPROC  0xf0000000
// All bits included in the MASKOS|MASKPROC mask are reserved for OS-specific
// semantics.

#endif // ELF_LOADER_H
