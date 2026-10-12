# AssemblyRefTableEntry (CLR_RECORD_ASSEMBLYREF)

The assembly Reference table contains references to other assemblies. The runtime will lookup the assembly by name and version when resolving the reference to an assembly header. A reference is satisfied by the assembly with the same name and the same major and minor version numbers (build and revision numbers are not compared).

The format of the AssemblyRefTableEntry is as follows:

| Name    | Type             | Description                                                                                   |
| ------- | ---------------- | --------------------------------------------------------------------------------------------- |
| Name    | StringTableIndex | index into the string table blob for the name of the referenced assembly                      |
| Version | VersionInfo      | VersionInfo structure for the version of the assembly (Checked at runtime for a match of the major and minor numbers) |
