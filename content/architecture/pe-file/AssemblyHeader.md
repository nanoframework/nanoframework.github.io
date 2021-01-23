# AssemblyHeader (CLR_RECORD_ASSEMBLY)

The AssemblyHeader structure contains a number of verification markers and CRCs to validate the legitimacy of the assembly at runtime. Additionally, the Assembly header contains the location information for the MetadataTables and BLOB storage areas. 

The Structure of the AssemblyHeader is as follows:

| Name                                            | Type                  | Description  
|-------------------------------------------------|-----------------------|------------  
| [Marker](#marker)                               | `uint8_t[8]`          | Id marker for an assembly  
| [HeaderCRC](#headercrc)                         | `uint32_t`            | CRC32 of the AssemblyHeader structure itself
| [AssemblyCRC](#assemblycrc)                     | `uint32_t`            | CRC32 of the complete assembly
| [Flags](#flags)                                 | [AssemblyHeaderFlags](#flags) | Flags for the assembly
| [NativeMethodsChecksum](#nativemethodschecksum) | `uint32_t`            | Native Method Checksum
| [Version](#version)                             | `VersionInfo`         | Version information data structure for this assembly
| [AssemblyName](#assemblyname)                   | `uint16_t`            | String table index for the Assembly's name
| [StartOfTables](#startoftables)                 | `uint32_t[16]`        | Array of offsets into the PE file for the metadata tables
| [PaddingOfTables](#paddingoftables)             | `uint8_t[16]`         | amount of alignment padding for each metadata table

## Field Details

The following sections describe the individual fields of the AssemblyHeader structure.

### Marker

The assembly marker is an eight character marker consisting of a string non zero terminated ASCII encoded characters.
This is used to clearly identify a .NET **nanoFramework** PE file on disk and in memory at runtime. It also indicates the version of this data structure, thus any modifications to this structure in future releases **MUST** use a new marker string. 

| Version  | Marker   | Description
|----------|----------|------------  
| 1.0      | 'NFMRK1' | Marker for version 1.0
| 2.0      | 'NFMRK2' | Marker for version 2.0 (after adding support for generics)

### Header CRC

ANSI X3.66 32 bit CRC for the AssemblyHeader. This is computed assuming the HeaderCRC and AssemblyCRC fields are 0.

### Assembly CRC

ANSI X3.66 32 bit CRC for the entire contents of the Assembly PE data. This is computed assuming the HeaderCRC and AssemblyCRC fields
are 0.

### Flags

The flags property are meant to contain a bit flags value. They are not used in .NET **nanoFramework** and were kept for historical reasons and structure compatibility.

### NativeMethodsChecksum

The ***NativeMethodsChecksum*** is a unique value that is matched against the native methods table stored in the CLR firmware to ensure the methods match. The actual algorithm used for computing this checksum are documented in the [NativeMethodsChecksum Algorithm] document. Though, it worth noting that the actual algorithm doesn't matter. Nothing in the runtime will compute this value. The runtime only compares the assembly's value with the one for the native code registered for a given assembly to ensure they match. As long as the tool generating the assembly and the native method stubs header and code files use the same value then the actual algorithm is mostly irrelevant. The most important aspect of the algorithm chosen is that any change to any type or method signature
of any type with native methods **MUST** generate a distinct checksum value. The current MetadataProcessor algorithm constructs a mangled string name for the native methods (used to generate the stubs), sorts them all and runs a CRC32 across them to get a distinct value. Since the CRC is based on the fully qualified method name and the types of all parameters any change of the signatures will generate a new value - denoting a mismatch.

### Version

The ***Version*** field holds the assembly's version number. (as opposed to the version of the AssemblyHeaderStructure itself). This is used by the debugger for version checks at deployment time. The runtime itself doesn't use versions to resolve references, as only one version of an assembly can be loaded at a time. Thus assembly references in the PE format don't include a version.

### AssemblyName

[String Table](StringTable.md) index for the name of the assembly

### StartOfTables

Fixed array of offsets to the table data for each of the different tables. The entries in this array are offsets from the start of the assembly header itself (e.g. the file seek offset if the PE image is from a file)

| Name                                                         | .NET **nanoFramework** Source Element Name | Description
|--------------------------------------------------------------|-----------------------------------|-----------
| [AssemblyRef](AssemblyRefTableEntry.md)                      | CLR_RECORD_ASSEMBLYREF            | Table of Assembly references
| [TypeRef](TypeRefTableEntry.md)                              | CLR_RECORD_TYPEREF                | Reference to a type in another assembly
| [FieldRef](FieldRefTableEntry.md)                            | CLR_RECORD_FIELDREF               | Reference to a field of a type in another assembly
| [MethodRef](MethodRefTableEntry.md)                          | CLR_RECORD_METHODREF              | Reference to a method of a type in another assembly
| [TypeDef](TypeDefTableEntry.md)                              | CLR_RECORD_TYPEDEF                | Type definition for a type in this assembly
| [FieldDef](FieldDefTableEntry.md)                            | CLR_RECORD_FIELDDEF               | Field definition for a type in this assembly
| [MethodDef](MethodDefTableEntry.md)                          | CLR_RECORD_METHODDEF              | Method definition for a type in this assembly
| [GenericParam](GenericParamTableEntry.md)                    | CLR_RECORD_GENERICPARAM           | Generic parameter definition (new in v2.0)
| [MethodSpec](MethodSpecTableEntry.md)                        | CLR_RECORD_METHODSPEC             | Method specification (new in v2.0)
| [Attributes](AttributesTableEntry.md)                        | CLR_RECORD_ATTRIBUTE              | Attribute types defined in this assembly
| [TypeSpec](TypeSpecTableEntry.md)                            | CLR_RECORD_TYPESPEC               | TypeSpecifications (signatures) used in this assembly
| [Resources](ResourcesTableEntry.md)                          | CLR_RECORD_RESOURCE               | Resource items in a resource file bound to this assembly
| [ResourcesData](ResourcesDataBlob.md)                        | \<blob>                           | Blob table data for the resources
| [Strings](StringsBlob.md)                                    | \<blob>                           | Blob table data for the strings
| [Signatures](SignaturesBlob.md)                              | \<blob>                           | Blob table data for the metadata signatures
| [ByteCode](ByteCodeBlob.md)                                  | \<blob>                           | Blob table data for the IL byte code instructions
| [ResourcesFiles](ResourcesFilesTableEntry.md)                | CLR_RECORD_RESOURCE_FILE          | Resource files descriptors for resource files bound to this assembly
| [EndOfAssembly](EndOfAssembly.md)                            | \<N/A>                            | Technically, this is not a table. Instead this entry contains the offset to the end of the assembly, which is useful for finding the next assembly in a DAT region

### PaddingOfTables

For every table, a number of bytes that were padded to the end of the table to align the next table to a 32bit boundary. The start of each table is aligned to a 32bit boundary, and ends at a 32bit boundary.
Some of these tables will, therefore, have no padding, and all will have values in the range [0-3]. This isn't the most compact form to hold this information, but it only costs 16 bytes/assembly. Trying to only align some of the tables is just much more hassle than it's worth. This field itself must also be aligned on a 32 bit boundary. This padding is used to compute the size of a given table (including the blob data) using the following formula:

`TableSize = StartOfTables[ tableindex + 1 ] - StartOfTables[ tableindex ] - PaddingOfTables[ tableindex ]`
