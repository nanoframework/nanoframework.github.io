# MethodDefTableEntry (CLR_RECORD_METHODDEF)

The MethodRef table contains entries with the following structure

| Name | Type | Description  |
|-------------------|------------------|------------  |
| Name | StringTableIndex | Index into [String table](StringTable.md) for the name of the method|
| RVA | MetadataOffset | Offset into the IL byte code blob table for the opcodes of the method|
| Flags | MethodDefFlags | Flags to indicate intrinsic attributes and semantics of the method|
| RetVal | DataType | DataType of the return value for the method|
| ArgumentsCount | uint8_t | Count of arguments to the method|
| LocalsCount | uint8_t | Count of local variables for the method|
| LengthEvalStack | uint8_t | Length of the evaluation stack for the method|
| Locals | SigTableIndex | Index into [Signature table](SignatureTable.md) to describe the locals for the method|
| FirstGenericParam | GenericParamTableIndex | Index into [GenericParam table](GenericParamTableEntry.md) for the first generic parameter of the method|
| GenericParamCount | uint8_t | Count of generic parameters for the method|
| Signature | SigTableIndex | Index into [Signature table](SignatureTable.md) that describes the method itself|

## Signature Table Usage

The method Def has multiple references to the signature table each describes some aspect of the method in distinct ways. This section describes the sequence of entries in the signature and their meanings for a method definition.

### Locals Signature Table

(TODO: Define allowed sequence chains for local signatures. ECMA uses diagrams for this - consider using SVG here)

### Method Signature

(TODO: Define allowed sequence chains for the method's signature. ECMA uses diagrams for this - consider using SVG here)
