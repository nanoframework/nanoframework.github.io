# FieldRefTableEntry (CLR_RECORD_FIELDREF)

The FieldRef Table consists of the following columns:

| Name      | Type                 | Description  |
|-----------|----------------------|------------  |
| Name      | StringTableIndex     | Index into [string table](StringTable.md) for the name of the type|
| Owner | TypeRefTableIndex    | Index into [TypeRef table](TypeRefTableEntry.md) for the type containing this field|
| Sig       | SigTableIndex        | Index into [signature table](SignatureTable.md) describing the type of this field|
