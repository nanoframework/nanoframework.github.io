# MethodRefTableEntry (CLR_RECORD_METHODREF)

The MethodRef table contains entries with the following structure

| Name      | Type                 | Description  |
|-----------|----------------------|------------  |
| Name      | StringTableIndex     | Index into [string table](StringTable.md) for the name of the method|
| Container | TypeRefTableIndex    | Index into [TypeRef table](TypeRefTableEntry.md) for the type containing the method|
| Sig       | SignatureTableIndex  | Index into [signature table](SignatureTable.md) for signature of the method|
