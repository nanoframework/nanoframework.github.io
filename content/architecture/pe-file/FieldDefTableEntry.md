# FieldRefTableEntry (CLR_RECORD_FIELDDEF)

The FieldDef Table consists of the following columns:

| Name      | Type                 | Description  |
|-----------|----------------------|------------  |
| Name      | StringTableIndex     | Index into [string table](StringTable.md) for the name of the type|
| Sig       | SigTableIndex        | Index into [signature table](SignatureTable.md) describing the type of this field|
| DefaultValue | SigTableIndex        | Index into [signature table](SignatureTable.md) describing the initial value of this field|
| Flags | uint16_t | Flags defining intrinsic attributes and access modifiers for the field|
