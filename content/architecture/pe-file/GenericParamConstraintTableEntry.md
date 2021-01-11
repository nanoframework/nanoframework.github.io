# GenericParamConstraint (CLR_RECORD_GENERICPARAMCONSTRAINT)

The GenericParamConstraint Table (new in v2.0) consists of the following columns:

| Name       | Type            | Description  
|------------|-----------------|------------  
| Owner      | TypeOrMethodDef | Index into the [GenericParam table](GenericParamTableEntry.md) specifying to which generic parameter this row refers.
| Constraint | TypeDefOrRef    | Index into the [TypeDef table](TypeDefTableEntry.md), [TypeRef table](TypeRefTableEntry.md), or [TypeSpec table](TypeSpecTableEntry.md) tables, specifying from which class this generic parameter is constrained to derive; or which interface this generic parameter is constrained to implement; more precisely, a TypeDefOrRef.
