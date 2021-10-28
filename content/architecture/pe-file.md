# .NET **nanoFramework** PE File Format

The .NET **nanoFramework** PE data format is based on the ECMA-335 specification. Specifically sections II.22 - II.24.
Due to the constraints of the systems .NET **nanoFramework** targets the PE file format is not an exact match/implementation of the ECMA-335 specification. .NET **nanoFramework** PE file format is essentially an extended subset of the format defined in ECMA-335.

## Major differences from ECMA-335

- The number and size of the metadata tables is limited in .NET **nanoFramework** to keep the overall memory footprint as low as possible.
- The Windows PE32/COFF header, tables and information is stripped out.
- Switch instruction branch table index is limited to 8 bits.
- Table indexes are limited to 12 bits.
- This also means that the metadata tokens are 16 bits and not 32 so the actual IL instruction stream is different for .NET **nanoFramework**.
- Resources are handled in a very different manner with their own special table in the assembly header.

## File Data Structure

The PE file starts with an [Assembly header](pe-file/AssemblyHeader.md) which is the top level structure of every .NET **nanoFramework** PE file. On disk the AssemblyHeader structure is at offset 0 of the .PE file. On the device the AssemblyHeader is aligned at a 32 bit boundary within a well known ROM/FLASH region (the Deployment region) with the first assembly at offset 0 of the region. Immediately following the assembly header is the metadata table data. Since there are no fixed requirements that an assembly requires all possible tables or what the number of entries in each table will be, the exact size and location of the start of each table's data is entirely described within the header including the end of the assembly, which is used to compute the start location of any subsequent assemblies in memory.

```text
+-----------------+ <--- Aligned to 32 bit boundary in memory
| AssemblyHeader  |
+-----------------+
| Metadata        |
+-----------------+
| { padding }     |
+-----------------+ <--- Aligned to 32 bit boundary in memory
| AssemblyHeader  |
+-----------------+
| Metadata        |
+-----------------+
| { padding }     |
+-----------------+ <--- Aligned to 32 bit boundary in memory
|  ...            |
```

## Structures for the other table entries

- [AssemblyRef Table](pe-file/AssemblyRefTableEntry.md)
- [Attribute Table](pe-file/AttributeTableEntry.md)
- [ExceptionHandler Table](pe-file/ExceptionHandlerTableEntry.md)
- [FieldRef Table](pe-file/FieldRefTableEntry.md)
- [MethodDef Table](pe-file/MethodDefTableEntry.md)
- [MethodRef Table](pe-file/MethodRefTableEntry.md)
- [Resources Table](pe-file/ResourcesTableEntry.md)
- [TypeDef Table](pe-file/TypeDefTableEntry.md)
- [TypeRef Table](pe-file/TypeRefTableEntry.md)
- [TypeSpec Table](pe-file/TypeSpecTableEntry.md)
- [GenericParam Table](pe-file/GenericParamTableEntry.md) (new in v2.0)
- [MethodSpec Table](pe-file/MethodSpecTableEntry.md) (new in v2.0)
- [Common PE Types and Enumerations](pe-file/Common-PE-Types-and-Enumerations.md)

    > Note 1: The structures above are packed with 1 byte boundary.
    > Note 2: the documentation for the PE file format was taken from the original one at .NET Micro Framework.
