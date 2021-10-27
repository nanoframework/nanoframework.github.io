# GenericParamTableEntry (CLR_RECORD_GENERICPARAM)

The GenericParam Table (new in v2.0) consists of the following columns:

| Name   | Type             | Description  |
|--------|------------------|------------  |
| Number | uint16_t         | 2-byte index of the generic parameter, numbered left -to-right, from zero.|
| Flags  | uint16_t         | 2-byte bitmask of type GenericParamAttributes|
| Owner  | TypeOrMethodDef  | Index into the TypeDef or MethodDef table, specifying the Type or Method to which this generic parameter applies; more precisely, a TypeOrMethodDef.|
| Name   | StringTableIndex | Index into [string table](StringTable.md) giving the name for the generic parameter.|
