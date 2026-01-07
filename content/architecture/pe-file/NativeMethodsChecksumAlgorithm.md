# NativeMethodsChecksum Algorithm

This document describes the algorithm used by the **nanoFramework MetadataProcessor** to compute the `NativeMethodsChecksum` field stored in the PE AssemblyHeader.

## Purpose

The checksum exists to ensure that:

- The managed assembly being loaded is paired with the correct native implementation registered in the CLR firmware.
- Any structural or signature change that affects the native interop surface produces a different checksum value.

The CLR runtime does **not** compute this checksum; it only compares the value in the assembly header with the value stored alongside the native methods table.

## High-level algorithm

The implementation is in the MetadataProcessor class `NativeMethodsCrc`.

1. Start with CRC32 value `0`.
2. Walk all types that participate in stub generation (i.e., types for which `IncludeInStub()` is true), excluding types listed in the *class names to exclude* set.
3. For each visited type, walk its methods in the deterministic “metadata processor order” (the same ordering used by the metadata tables).
4. For each visited method:

   - If the method is considered to have a native implementation (currently: `method.RVA == 0` and the method is not abstract), then update the CRC32 with the ASCII bytes of:

     1) the **assembly name**,

     2) the **safe class name**,

     3) the **safe method name** (which includes the signature).

   - Regardless of whether the method has a native implementation, always update the CRC32 with the ASCII bytes of the literal string:

     - `"nullptr"`

5. If no methods were found that meet the “native implementation” criteria, the checksum value returned is `0`.

## Why the algorithm includes `nullptr` for every entry

The unconditional `nullptr` marker makes the checksum **position-dependent**.

That means that changes such as:

- adding a method,
- removing a method,
- changing method order as emitted by the compiler/tooling,
- moving methods between types (affecting iteration order),

will change the checksum even if none of the existing native method signatures themselves changed.

This is intentional: the native methods table is an ordered list, so layout-affecting structural changes must be detected.

## Why the algorithm uses mangled names

The checksum uses a canonical string representation so that the checksum is based on *what matters for native interop*:

- the declaring type identity,
- the method identity,
- the method signature (return and parameter types),
- and the position in the native-methods table.

This is also aligned with how stub declarations are generated: the “safe” names are designed to be stable and C/C++-friendly.

### Safe class name

A safe class name is built from:

- the declaring type chain (for nested types),
- the namespace,
- the type name,

joined with underscores, and then normalized:

- `.` becomes `_`
- leading `_` is trimmed
- generic notation is removed/normalized:
  - backticks (e.g. ``Type`1``) are replaced with `_`
  - any `<...>` generic parameter list text is removed

### Safe method name

A safe method name is built from:

- the method name,
- a static/instance marker:
  - static methods add `___STATIC__`
  - instance methods add `___`
- the signature tokens, joined with `__`:
  - return type first
  - then each parameter type in order

The signature tokens are derived from a nanoCLR type encoding (e.g., primitive `DATATYPE_*` names with the `DATATYPE_` prefix removed), with special handling for:

- single-dimension arrays (`SZARRAY_<elementType>`)
- byref parameters (`BYREF_<elementType>`)
- generic parameters (`GENERICTYPE`)
- pointers to primitive element types (encoded as `<primitive>ptr`)

Finally, `.` is replaced with `_` and `/` is removed, and generic notation is cleaned as described above.

## Exclusions

Types may be excluded from the checksum if they are present in the processor’s exclusion list (including exclusions inherited from a declaring type). Excluded types are not iterated for checksum purposes.

## Notes

- This algorithm is an implementation detail shared between:
  - the tool that emits the PE file (writing `NativeMethodsChecksum`), and
  - the tool that generates native stub declarations and the native methods table.

As long as both sides use the same algorithm, the CLR only needs to compare values.
