# Philosophy

The PE File format is expressed in terms of a number of common types. In code these are generally realized as an enumeration, typedef or type alias of some sort o help ensure both clarity of code and correctness of use. This additional clarity and type safety is preferred over use of raw primitive types directly as they onvey no real meaning beyond their basic ranges making correct use of the code less obvious and more error prone.

## Table Index

Many PE data structures store an index into a particular table index as a field. This table defines the type names used to store the index and which table it is an index into.

Name                             | underlying type         | Description
---------------------------------|-------------------------|------------
StringTableIndex                 | unsigned 16 bit integer | Index into the string table (see: [StringTables](StringTables.md)) for more details)
TypeDefTableIndex                | unsigned 16 bit integer | Index into the type definition table
TypeRefTableIndex                | unsigned 16 bit integer | Index into the type reference table
FieldDefTableIndex               | unsigned 16 bit integer | Index into the field definition table
MethodDefTableIndex              | unsigned 16 bit integer | Index into the method definition table
SigTableIndex                    | unsigned 16 bit integer | Index into the signature table (see: [SignatureBlobs](SignatureBlobs.md) for more details)
GenericParamTableIndex           | unsigned 16 bit integer | Index into the generic params table
GenericParamConstraintTableIndex | unsigned 16 bit integer | Index into the generic params constraint table
MethodSpecTableIndex             | unsigned 16 bit integer | Index into the method specification table

## EmptyIndex Constant

Since an index values are used to access members of a table and since (in C, C++, and many other languages) tables are indexed with the first element as index == 0 the value 0 is not useable as a constant to indicate "none" or "null". Thus a dedicated value is used for .NET **nanoFramework** metadata tables. Any index with the value 0xFFFF is considered the EmptyIndex and this is normally defined as a manifest constant for the entire code base to test against. 

## TableKind

The TableKind enumeration identifies a specific table in the assembly metadata.

Name                   | Value  | Description
-----------------------|--------|--------------
AssemblyRef            | 0x0000 | Assembly reference table
TypeRef                | 0x0001 | Type Reference Table
FieldRef               | 0x0002 | Field Reference table
MethodRef              | 0x0003 | Method Reference Table
TypeDef                | 0x0004 | Type Definition Table
FieldDef               | 0x0005 | Field Definition Table
MethodDef              | 0x0006 | Method Definition Table
Attributes             | 0x0007 | Attribute Table
TypeSpec               | 0x0008 | Type Specification Table
GenericParam           | 0x0009 | Generic Parameters Table
GenericParamConstraint | 0x000A | Generic Parameters Constraint Table
MethodSpec             | 0x000B | Method Specification Table
Resources              | 0x000C | Resources Table
ResourcesData          | 0x000D | Resource Data Blob Table
Strings                | 0x000E | String Blob table
Signatures             | 0x000F | Signature Blob table
ByteCode               | 0x0010 | IL Byte Code Stream Blob Table
ResourcesFiles         | 0x0011 | Resource Files Table
EndOfAssembly          | 0x0012 | End of Assembly Table (Used to quickly find the end of the assembly when scanning assemblies)
Max                    | 0x0013 | End of enumeration valid enumeration values must be **_less_** than this value

## Miscellaneous Types

Name                | underlying type         | Description
--------------------|-------------------------|------------
MetadataOffset      | unsigned 16 bit integer | Offset from the start of the IL instruction stream blob data
MetadataPtr         | pointer to a const byte | Pointer to the interior of the IL instruction stream blob data

## Tokens

Many instructions in IL and fields of data structures contain a token. Tokens in IL Metadata reference some other piece of metadata in the assembly. Tokens contain the table the token refers to along with an index into the table into a single primitive integral value. In .NET **nanoFramework** PE files there are two kinds of tokens MetadataToken and a more compact BinaryToken.

### Metadata Token

A metadata token is an unsigned 32 bit value where the Most significant byte is the table kind and the least significant 16 bits are the table index (In .NET **nanoFramework** PE format a table index is 16bits only thus there are 8 bits of unused data in a MetadataToken)

### Binary Token

A Binary Token is a compact form of representing an index to one or more tables. .NET **nanoFramework** follows the convention specified by ECMA-335 (I I.24.2.66) for _coded index_. Because of it's small size only the 2 bytes version is used where the most significant bits are used to determine which of the possible tables, and the remaining bits provide the index of the table entry. The following table provides the type name aliases for the various combinations of tables used in .NET **nanoFramework** PE metadata.

TypeRefOrAssemblyRef: (1 bit to encode tag) | Tag
--------------------------------------------|-----
AssemblyRef | 0
TypeRef     | 1

TypeDefOrRef: (2 bits to encode tag) | Tag
-------------------------------------|-----
TypeDef  | 0
TypeRef  | 1
TypeSpec | 2

MethodDefOrRef: (1 bit to encode tag) | Tag
--------------------------------------|-----
MethodDef | 0
MemberRef | 1

TypeOrMethodDef: (1 bit to encode tag) | Tag
---------------------------------------|-----
TypeDef   | 0
MethodDef | 1

FieldRefOrFieldDef: (1 bit to encode tag) | Tag
------------------------------------------|-----
FieldDef | 0
FieldRef | 1

## VersionInfo

Many .NET **nanoFramework** PE data structures include a version. The versions, when presented for readability are typically represented as a quad of 4 integer values separated by a '.' (i.e. 1.2.3.4) the following table defines the Version info structure used in the PE file to represent a version.

Name     | Type                    | Description
---------|-------------------------|------------
Major    | unsigned 16 bit integer | Major component of the common version quad
Minor    | unsigned 16 bit integer | Minor component of the common version quad
Build    | unsigned 16 bit integer | Build component of the common version quad
Revision | unsigned 16 bit integer | Revision component of the common version quad

## DataType

The `DataType` enumeration corresponds to the ECMA-335 ELEMENT_TYPE_xxxx, however the
actual numeric values are not the same as the interpreter uses only a reduced
sub-set of the standard values.

Name        | Description
------------|------------
Void        | 0 byte void value
Boolean     | 1 byte boolean value
I1          | 8 bit signed integer
U1          | 8 bit unsigned integer
CHAR        | 16 bit UTF-16 character
I2          | 16 bit signed integer
U2          | 16 bit unsigned integer
I4          | 32 bit signed integer
U4          | 32 bit unsigned integer
R4          | 32 bit IEEE-754 floating point value
I8          | 64 bit signed integer
U8          | 64 bit unsigned integer
R8          | 64 bit IEEE-754 floating point value
DateTime    | 8 bytes - Shortcut for System.DateTime
TimeSpan    | 8 bytes - Shortcut for System.TimeSpan
String      | 4 bytes - short cut for reference to System.String
Object      | 4 bytes - Shortcut for reference to System.Object
Class       | CLASS `<class Token>`
ValueType   | VALUETYPE `<class Token>`
SZArray     | Shortcut for single dimension zero lower bound array SZARRAY `<type>`
ByRef       | BYREF `<type>`
Var         | VAR Generic parameter in a generic type definition, represented as number (new in v2.0)
GenericInst | GENERICINST Generic type instantiation (new in v2.0)
MVar        | MVAR Generic parameter in a generic method definition, represented as number (new in v2.0)
