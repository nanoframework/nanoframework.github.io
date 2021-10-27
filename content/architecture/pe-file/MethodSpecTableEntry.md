# MethodSpecTableEntry (CLR_RECORD_METHODSPEC)

The MethodSpec Table (new in v2.0) consists of the following columns:

| Name          | Type                | Description  |
|---------------|---------------------|------------  |
| Method        | MethodDefOrRef      | Index into the [MethodDef table](MethodDefTableEntry.md) or [MemberRef table](MethodRefTableEntry.md), specifying to which generic method this row refers; that is, which generic method this row is an instantiation of; more precisely, a MethodDefOrRef.|
| Instantiation | SignatureTableIndex | Index into [signature table](SignatureTable.md) holding the signature of this instantiation|
