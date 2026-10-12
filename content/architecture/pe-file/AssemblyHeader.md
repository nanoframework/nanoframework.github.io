# AssemblyHeader (CLR_RECORD_ASSEMBLY)

The AssemblyHeader structure contains a number of verification markers and CRCs to validate the legitimacy of the assembly at runtime. Additionally, the Assembly header contains the location information for the MetadataTables and BLOB storage areas.

The Structure of the AssemblyHeader is as follows:

| Name                                            | Type                          | Description                                               |
| ----------------------------------------------- | ----------------------------- | --------------------------------------------------------- |
| [Marker](#marker)                               | `uint8_t[8]`                  | Id marker for an assembly                                 |
| [HeaderCRC](#headercrc)                         | `uint32_t`                    | CRC32 of the AssemblyHeader structure itself              |
| [AssemblyCRC](#assemblycrc)                     | `uint32_t`                    | CRC32 of the complete assembly                            |
| [Flags](#flags)                                 | [AssemblyHeaderFlags](#flags) | Flags for the assembly                                    |
| [NativeContractHash](#nativecontracthash)       | `uint32_t`                    | Native contract hash (native methods checksum in v1)      |
| [NativeMethodsOffset](#nativemethodsoffset)     | `uint32_t`                    | Native Methods Offset                                     |
| [Version](#version)                             | `VersionInfo`                 | Version information data structure for this assembly      |
| [AssemblyName](#assemblyname)                   | `uint16_t`                    | String table index for the Assembly's name                |
| [StringTableVersion](#stringtableversion)       | `uint16_t`                    | String table version                                      |
| [StartOfTables](#startoftables)                 | `uint32_t[16]`                | Array of offsets into the PE file for the metadata tables |
| NumberOfPatchedMethods                          | `uint32_t`                    | Number of patched methods                                 |
| [PaddingOfTables](#paddingoftables)             | `uint8_t[16]`                 | amount of alignment padding for each metadata table       |

## Field Details

The following sections describe the individual fields of the AssemblyHeader structure.

### Marker

The assembly marker is an eight character marker consisting of a string non zero terminated ASCII encoded characters.
This is used to clearly identify a .NET **nanoFramework** PE file on disk and in memory at runtime. It also indicates the version of this data structure, thus any modifications to this structure in future releases **MUST** use a new marker string.

| Version | Marker   | Description                                                |
| ------- | -------- | ---------------------------------------------------------- |
| 1.0     | 'NFMRK1' | Marker for version 1.0                                     |
| 2.0     | 'NFMRK2' | Marker for version 2.0 (after adding support for generics) |

### HeaderCRC

ANSI X3.66 32 bit CRC for the AssemblyHeader. This is computed assuming the HeaderCRC is 0.

### AssemblyCRC

ANSI X3.66 32 bit CRC for the entire contents of the Assembly PE data starting from [PaddingOfTables](#paddingoftables)

### Flags

The flags property are meant to contain a bit flags value. They are not used in .NET **nanoFramework** and were kept for historical reasons and structure compatibility.

### NativeContractHash

The **_NativeContractHash_** is a value used to validate that the managed assembly and the native implementation registered in the CLR firmware agree on everything that the native code depends on: the native methods and the layout of the fields of the classes and structs. The CLR does **not** recompute this value; it only compares the value stored in the assembly header with the value associated with the native code for that assembly. If they don't match, the assembly isn't loaded.

It's `0` for assemblies without native methods. Those don't require a native counterpart in the firmware.

The algorithm used to compute this value is documented in [Native Contract Hash](NativeContractHash.md). The most important requirements are that any change on the native interface of an assembly (adding, removing or changing a native method, or changing the field layout of any class or struct) **must** yield a different value, and that changes that have no impact on the native side (e.g. adding a managed method) **must not**.

> In the v1 format (`NFMRK1`) this field is the _NativeMethodsChecksum_, computed with a different algorithm that hashed all the methods of all the types. The field is at the same offset in both formats, but a v2 runtime only loads v2 PE files.

### NativeMethodsOffset

(TBD)

### Version

The **_Version_** field holds the assembly's version number. (as opposed to the version of the AssemblyHeaderStructure itself). This is used by the runtime and by the tools to check the [assembly references](AssemblyRefTableEntry.md): a reference to an assembly is resolved to the assembly with the same name and the same major and minor version numbers. Only one version of an assembly can be loaded at a time. The version is _not_ used to check the native side of an assembly; that's what the [NativeContractHash](#nativecontracthash) is for.

### AssemblyName

[String Table](StringTable.md) index for the name of the assembly

### StringTableVersion

Should be equal to 1

### StartOfTables

Fixed array of offsets to the table data for each of the different tables. The entries in this array are offsets from the start of the assembly header itself (e.g. the file seek offset if the PE image is from a file)

| Name                                                 | .NET **nanoFramework** Source Element Name | Description                                                                                                                                                        |
| ---------------------------------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [AssemblyRef](AssemblyRefTableEntry.md)              | CLR_RECORD_ASSEMBLYREF                     | Table of Assembly references                                                                                                                                       |
| [TypeRef](TypeRefTableEntry.md)                      | CLR_RECORD_TYPEREF                         | Reference to a type in another assembly                                                                                                                            |
| [FieldRef](FieldRefTableEntry.md)                    | CLR_RECORD_FIELDREF                        | Reference to a field of a type in another assembly                                                                                                                 |
| [MethodRef](MethodRefTableEntry.md)                  | CLR_RECORD_METHODREF                       | Reference to a method of a type in another assembly                                                                                                                |
| [TypeDef](TypeDefTableEntry.md)                      | CLR_RECORD_TYPEDEF                         | Type definition for a type in this assembly                                                                                                                        |
| [FieldDef](FieldDefTableEntry.md)                    | CLR_RECORD_FIELDDEF                        | Field definition for a type in this assembly                                                                                                                       |
| [MethodDef](MethodDefTableEntry.md)                  | CLR_RECORD_METHODDEF                       | Method definition for a type in this assembly                                                                                                                      |
| [GenericParam](GenericParamTableEntry.md)            | CLR_RECORD_GENERICPARAM                    | Generic parameter definition (new in v2.0)                                                                                                                         |
| [MethodSpec](MethodSpecTableEntry.md)                | CLR_RECORD_METHODSPEC                      | Method specification (new in v2.0)                                                                                                                                 |
| [Attributes](AttributeTableEntry.md)                 | CLR_RECORD_ATTRIBUTE                       | Attribute types defined in this assembly                                                                                                                           |
| [TypeSpec](TypeSpecTableEntry.md)                    | CLR_RECORD_TYPESPEC                        | TypeSpecifications (signatures) used in this assembly                                                                                                              |
| [Resources](ResourcesTableEntry.md)                  | CLR_RECORD_RESOURCE                        | Resource items in a resource file bound to this assembly                                                                                                           |
| [ResourcesData](ResourcesTableEntry.md)              | \<blob>                                    | Blob table data for the resources                                                                                                                                  |
| [Strings](StringTable.md)                            | \<blob>                                    | Blob table data for the strings                                                                                                                                    |
| [Signatures](SignatureTable.md)                      | \<blob>                                    | Blob table data for the metadata signatures                                                                                                                        |
| [ByteCode](Common-PE-Types-and-Enumerations.md)      | \<blob>                                    | Blob table data for the IL byte code instructions                                                                                                                  |
| [ResourcesFiles](ResourcesTableEntry.md)             | CLR_RECORD_RESOURCE_FILE                   | Resource files descriptors for resource files bound to this assembly                                                                                               |
| [EndOfAssembly](Common-PE-Types-and-Enumerations.md) | \<N/A>                                     | Technically, this is not a table. Instead this entry contains the offset to the end of the assembly, which is useful for finding the next assembly in a DAT region |

### NumberOfPatchedMethods

Should be equal to 0. Not supported in .NET nanoFramework

### PaddingOfTables

For every table, a number of bytes that were padded to the end of the table to align the next table to a 32bit boundary. The start of each table is aligned to a 32bit boundary, and ends at a 32bit boundary.
Some of these tables will, therefore, have no padding, and all will have values in the range [0-3]. This isn't the most compact form to hold this information, but it only costs 16 bytes/assembly. Trying to only align some of the tables is just much more hassle than it's worth. This field itself must also be aligned on a 32 bit boundary. This padding is used to compute the size of a given table (including the blob data) using the following formula:

`TableSize = StartOfTables[ tableindex + 1 ] - StartOfTables[ tableindex ] - PaddingOfTables[ tableindex ]`
