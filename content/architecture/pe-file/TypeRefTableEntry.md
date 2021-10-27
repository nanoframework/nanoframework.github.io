# TypeRefTableEntry (CLR_RECORD_TYPEREF)

The TypeRef Table consists of the following columns:

| Name      | Type                 | Description  |
|-----------|----------------------|------------  |
| Name      | StringTableIndex     | Index into [string table](StringTable.md) for the name of the type|
| Namespace | StringTableIndex     | Index into [string table](StringTable.md) for the namespace|
| Scope     | TypeRefOrAssemblyRef | Binary token for either the [TypeRef table](TypeRefTableEntry.md) or the  [AssemblyRef table](AssemblyRefTableEntry.md)|
