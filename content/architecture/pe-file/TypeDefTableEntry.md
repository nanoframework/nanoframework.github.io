# TypeDefTableEntry (CLR_RECORD_TYPEDEF)

The MethodRef table contains entries with the following structure:

| Name | Type | Description  |
|---------------------|---------------------|------------  |
| Name                | StringTableIndex | Index into string table with the name of the type|
| NameSpace           | StringTableIndex | Index into string table with the name of the namespace containing the type|
| Extends             | TypeDefOrRef | Index into the [TypeDef table](TypeDefTableEntry.md), [TypeRef table](TypeRefTableEntry.md), or [TypeSpec table](TypeSpecTableEntry.md) tables, more precisely, a TypeDefOrRef|
| EnclosingType       | TypeDefOrRef | Index into the [TypeDef table](TypeDefTableEntry.md), more precisely, a TypeDefOrRef if this is a nested type.|
| Interfaces          | SignatureTableIndex | Index into signature blob table for the set of interfaces implemented by this type|
| FirstMethod         | MethodDefTableIndex | Index into [MethodDef table](MethodDefTableEntry.md) for the first method of the type|
| VirtualMethodCount  | uint8_t | Count of virtual methods in the type|
| InstanceMethodCount | uint8_t | Count of instance methods in the type|
| StaticMethodCount   | uint8_t | Count of static methods in the type|
| DataType            | DataType | Data type identity for the type|
| FirstStaticField    | FieldDefTableIndex | Index into [FieldDef](FieldDefTableEntry.md) for the first static field of the type|
| FirstInstanceField  | FieldDefTableIndex | Index into [FieldDef](FieldDefTableEntry.md) for the first instance field of the type|
| StaticFieldsCount   | uint8_t | Count of static fields in the type|
| InstanceFieldsCount | uint8_t | Count of instance fields for the type|
| FirstGenericParam   | GenericParamTableIndex | Index into [GenericParam table](GenericParamTableEntry.md) for the first generic parameter for the type|
| GenericParamCount   | uint8_t | Count of generic parameters for the type|
| Flags               | [TypeDefFlags](#typedefflags) | Flags defining intrinsic attributes and access modifiers for the type|

## TypeDefFlags

The TypeDefFlags enumeration provides a set of flag values for various intrinsic attributes and accessibility traits of a type definition.

| Name               | Value  | Description  |
|--------------------|--------|------------|
|               None | 0      | No special attributes or semantics|
|          ScopeMask | 0x0007 | Mask to extract the accessibility scope values|
|          NotPublic | 0x0000 | Class is not public scope.|
|             Public | 0x0001 | Class is public scope.|
|       NestedPublic | 0x0002 | Class is nested with public visibility.|
|      NestedPrivate | 0x0003 | Class is nested with private visibility.|
|       NestedFamily | 0x0004 | Class is nested with family visibility.|
|     NestedAssembly | 0x0005 | Class is nested with assembly visibility.|
|  NestedFamANDAssem | 0x0006 | Class is nested with family and assembly visibility.|
|   NestedFamORAssem | 0x0007 | Class is nested with family or assembly visibility.|
|       Serializable | 0x0008 | Type is serializable|
|      SemanticsMask | 0x0030 | Mask to extract the bits pertaining to type semantics|
|              Class | 0x0000 | Class Semantics (in particular the value of this field is that bits 4 and 5 are 0)|
|          ValueType | 0x0010 | Value type semantics|
|          Interface | 0x0020 | Interface semantics|
|               Enum | 0x0030 | Enum semantics|
|           Abstract | 0x0040 | Type is abstract|
|             Sealed | 0x0080 | Type is sealed|
|        SpecialName | 0x0100 | Type is a well known special name|
|           Delegate | 0x0200 | Type is a delegate|
|  MulticastDelegate | 0x0400 | Type is a multicast delegate|
|            Patched | 0x0800 | (TODO)|
|    BeforeFieldInit | 0x1000 | (TODO)|
|        HasSecurity | 0x2000 | (TODO)|
|       HasFinalizer | 0x4000 | (TODO)|
|      HasAttributes | 0x8000 | (TODO)|
