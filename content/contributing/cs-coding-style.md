# C# Coding Style

For non code files (xml etc) our current best guidance is consistency. When editing files, keep new code and changes consistent with the style in the files. For new files, it should conform to the style for that component. Last, if there's a completely new component, anything that is reasonably broadly accepted is fine.

The general rule we follow is "use Visual Studio defaults". For details check the [Naming Guidelines](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/naming-guidelines) of .NET guide.

1. We use [Allman style](https://en.wikipedia.org/wiki/Indent_style#Allman_style) braces, where each brace begins on a new line. Even a single line statement block should go with braces and nested in other statement blocks that use braces.
2. We use four spaces of indentation (no tabs).
3. We use `_camelCase` for internal and private fields and use `readonly` where possible. Prefix static fields can be used with `s_` and thread static fields with `t_`. When used on static fields, `readonly` should come after `static` (i.e. `static readonly` not `readonly static`).
4. We avoid `this.` unless absolutely necessary.
5. We always specify the visibility, even if it's the default (i.e.
   `private string _foo` not `string _foo`). Visibility should be the first modifier (i.e.
   `public abstract` not `abstract public`).
6. Namespace imports should be specified at the top of the file, *outside* of
   `namespace` declarations and should be sorted alphabetically.
7. Avoid more than one empty line at any time. For example, do not have two
   blank lines between members of a type.
8. Add an extra empty line after a closing bracket `}` except if another closing bracket follows or another instruction like `else` follows.
9. Avoid spurious free spaces.
   For example avoid `if (someVar == 0)...`, where the dots mark the spurious free spaces.
   Consider enabling "View White Space (Ctrl+E, S)" if using Visual Studio, to aid detection.
   Tip: use `clrl+k+d` in Visual Studio to clean the indentations, extra spaces
10. If a file happens to differ in style from these guidelines (e.g. private members are named `m_member`
   rather than `_member`), the existing style in that file takes precedence.
11. We only use `var` when it's obvious what the variable type is (i.e. `var stream = new FileStream(...)` not `var stream = OpenStandardInput()`).
12. We use language keywords instead of BCL types (i.e. `int, string, float` instead of `Int32, String, Single`, etc) for both type references as well as method calls (i.e. `int.Parse` instead of `Int32.Parse`).
13. We use PascalCasing to name all our constant local variables and fields. The only exception is for interop code where the constant value should exactly match the name and value of the code you are calling via interop.
14. We use ```nameof(...)``` instead of ```"..."``` whenever possible and relevant.
15. Fields should be specified at the top within type declarations.
16. Always add intellisense (the /// comments) on all the public elements, including the return type, the params.
17. Use the *exception* to describe exceptions in the intellisense comment and **avoid** adding text to the exception you raise. This will save space on the PE code. But **do** use them is contributing to the one of the tool like nanoff.
18. Don't forget the header, the 2 lines simplified version can be used.
19. Try to avoid abbreviation, always use longer names when possible and where it does make sense. It is acceptable for very known ones to use them like HTTP for example. Also, if using abbreviations, the names should follow the the pattern. For example, if you are using `HTTP` in a name of a function called `Something`, it will then be `HttpSomething`. This goes as well for namespaces, classes, properties, variable names.

We have provided a Visual Studio 2013 vssettings file `nnnnn.vssettings` at the root of each repository, enabling C# auto-formatting conforming to the above guidelines. Note that rules 7 and 8 are not covered by the vssettings, since these are not rules currently supported by VS formatting.

A more modern way to enforce the coding style is via an `.editorconfig` file at the top of the repository:
```
# This is a top-most .editorconfig file
root = true

#=====================================================
#
# Settings for all file types
#
#=====================================================
[*]

# Generic EditorConfig settings
indent_style = space
indent_size = 4
end_of_line = crlf
charset = utf-8-bom
trim_trailing_whitespace = true
insert_final_newline = true

# Visual Studio spell checker
spelling_languages = en-us
spelling_checkable_types = strings,identifiers,comments
spelling_error_severity = hint
spelling_exclusion_path = spelling_exclusion.dic

#=====================================================
#
# Formatting rules for C#
#
#=====================================================
[*.cs]
dotnet_sort_system_directives_first = false
dotnet_separate_import_directive_groups = false

# Formatting rules
csharp_new_line_before_open_brace = all
csharp_new_line_before_else = true
csharp_new_line_before_catch = true
csharp_new_line_before_finally = true
csharp_new_line_before_members_in_object_initializers = true
csharp_new_line_before_members_in_anonymous_types = true
csharp_new_line_between_query_expression_clauses = true

csharp_indent_case_contents = true
csharp_indent_switch_labels = true
csharp_indent_labels = one_less_than_current
csharp_indent_block_contents = true
csharp_indent_braces = false
csharp_indent_case_contents_when_block = true

csharp_space_after_cast = false
csharp_space_after_keywords_in_control_flow_statements = true
csharp_space_between_parentheses = false
csharp_space_before_colon_in_inheritance_clause = true
csharp_space_after_colon_in_inheritance_clause = true
csharp_space_around_binary_operators = before_and_after
csharp_space_between_method_declaration_parameter_list_parentheses = false
csharp_space_between_method_declaration_empty_parameter_list_parentheses = false
csharp_space_between_method_declaration_name_and_open_parenthesis = false
csharp_space_between_method_call_parameter_list_parentheses = false
csharp_space_between_method_call_empty_parameter_list_parentheses = false
csharp_space_between_method_call_name_and_opening_parenthesis = false
csharp_space_after_comma = true
csharp_space_before_comma = false
csharp_space_after_dot = false
csharp_space_before_dot = false
csharp_space_after_semicolon_in_for_statement = true
csharp_space_before_semicolon_in_for_statement = false
csharp_space_around_declaration_statements = false
csharp_space_before_open_square_brackets = false
csharp_space_between_empty_square_brackets = false
csharp_space_between_square_brackets = false

csharp_preserve_single_line_statements = true
csharp_preserve_single_line_blocks = true

# Naming rules

# nF_InternalPrivateFields: all private or internal fields
dotnet_naming_symbols.nF_InternalPrivateFields.applicable_kinds = field
dotnet_naming_symbols.nF_InternalPrivateFields.applicable_accessibilities = internal, private

# nF_CamelCaseAndUnderscore: camel casing rule
dotnet_naming_style.nF_CamelCase.capitalization = camel_case
dotnet_naming_style.nF_CamelCase.required_prefix = _

# nF naming rule for private or internal fields
dotnet_naming_rule.nF_InternalPrivateFields_Rule.symbols = nF_InternalPrivateFields
dotnet_naming_rule.nF_InternalPrivateFields_Rule.style = nF_CamelCaseAndUnderscore
dotnet_naming_rule.nF_InternalPrivateFields_Rule.severity = warning
```

## Example File

``ObservableLinkedList`1.cs:``

```C#
// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Diagnostics;
using Microsoft.Win32;

namespace System.Collections.Generic
{
    /// <summary>
    /// A clear description of whatthis is.
    /// </summary>
    /// <typeparam name="T">A description as well of this generic parameter.</typeparam>
    public partial class ObservableLinkedList<T> : INotifyCollectionChanged, INotifyPropertyChanged
    {
        // All constants, public or private goes first
        private const int CountDefualt = 42;
        // All variable declarations goes on top
        // Starting with anything static
        private ObservableLinkedListNode<T> _head;
        private int _count;

        /// <summary>
        /// Instanciate an ObservableLinkedList class. 
        /// </summary>
        /// <param name="items">An enumerable of items.</param>
        /// <exception cref="ArgumentNullException">The items parameter can't be null.</exception>
        public ObservableLinkedList(IEnumerable<T> items)
        {
            if (items == null)
            {
                throw new ArgumentNullException(nameof(items));
            }

            foreach (T item in items)
            {
                AddLast(item);
            }
        }

        /// <summary>
        /// A collection change event
        /// </summary>
        public event NotifyCollectionChangedEventHandler CollectionChanged;

        /// <summary>
        /// Gets the counts.
        /// </summary>
        public int Count => _count;        

        /// <summary>
        /// Another good description here. All sentences should finish with a dot.
        /// </summary>
        /// <param name="value">A good description of the variable here as well.</param>
        /// <returns>And of course the return type as well!</returns>
        public ObservableLinkedListNode AddLast(T value)
        {
            var newNode = new LinkedListNode<T>(this, value);

            InsertNodeBefore(_head, node);
        }

        protected virtual void OnCollectionChanged(NotifyCollectionChangedEventArgs e)
        {
            NotifyCollectionChangedEventHandler handler = CollectionChanged;
            if (handler != null)
            {
                handler(this, e);
            }
        }

        private void InsertNodeBefore(LinkedListNode<T> node, LinkedListNode<T> newNode)
        {
            ...
        }

        ...
    }
}
```
