# MethodDefTableEntry (CLR_RECORD_METHODDEF)

The MethodRef table contains entries with the following structure

| Name              | Type                   | Description                                                                                              |
| ----------------- | ---------------------- | -------------------------------------------------------------------------------------------------------- |
| Name              | StringTableIndex       | Index into [String table](StringTable.md) for the name of the method                                     |
| RVA               | MetadataOffset         | Offset into the IL byte code blob table for the opcodes of the method (the [native slot](#native-methods) for a native method) |
| Flags             | MethodDefFlags         | Flags to indicate intrinsic attributes and semantics of the method                                       |
| RetVal            | DataType               | DataType of the return value for the method                                                              |
| ArgumentsCount    | uint8_t                | Count of arguments to the method                                                                         |
| LocalsCount       | uint8_t                | Count of local variables for the method                                                                  |
| LengthEvalStack   | uint8_t                | Length of the evaluation stack for the method                                                            |
| Locals            | SigTableIndex          | Index into [Signature table](SignatureTable.md) to describe the locals for the method                    |
| FirstGenericParam | GenericParamTableIndex | Index into [GenericParam table](GenericParamTableEntry.md) for the first generic parameter of the method |
| GenericParamCount | uint8_t                | Count of generic parameters for the method                                                               |
| Signature         | SigTableIndex          | Index into [Signature table](SignatureTable.md) that describes the method itself                         |

## Native methods

A method implemented in native code (e.g. declared `extern` with `MethodImplOptions.InternalCall`) has the `MD_Native` flag (`0x00008000`) set in its `Flags`. It has no IL byte code, so its `RVA` is **not** an offset into the byte code table: it holds the **native slot** of the method, which is the index of the handler in the methods lookup table of the native assembly declaration.

Native slots are dense (0 to N-1, being N the number of native methods in the assembly) and are assigned by the metadata processor independently of the order of the methods in the PE file. See [Native Contract Hash](NativeContractHash.md#native-slots).

Readers of the PE file must check the `MD_Native` flag before using the `RVA` of a method. In particular, the length of the IL byte code of a method can't be computed from the `RVA` of the next method definition if that one is a native method.

## Signature Table Usage

The method Def has multiple references to the signature table each describes some aspect of the method in distinct ways. This section describes the sequence of entries in the signature and their meanings for a method definition.

### Locals Signature Table

(TODO: Define allowed sequence chains for local signatures. ECMA uses diagrams for this - consider using SVG here)

### Method Signature

(TODO: Define allowed sequence chains for the method's signature. ECMA uses diagrams for this - consider using SVG here)
