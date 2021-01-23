# MethodRefTableEntry (CLR_RECORD_METHODREF)

The MethodRef table contains entries with the following structure

| Name      | Type                 | Description  
|-----------|----------------------|------------  
| name      | StringTableIndex     | Index into [string table](StringTable.md) for the name of the method
| container | MemberRefParent      | Index into  [MethodDef table](MethodDefTableEntry.md), ModuleRef (not supported), [TypeDef table](TypeDefTableEntry.md), [TypeRef table](TypeRefTableEntry.md), or [TypeSpec table](TypeSpecTableEntry.md) tables; more precisely, a MemberRefParent for the type containing the method
| sig       | SignatureTableIndex  | Index into [signature table](SignatureTable.md) for signature of the method
