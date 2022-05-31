# C# Coding Style

For non code files (xml etc) our current best guidance is consistency. When editing files, keep new code and changes consistent with the style in the files. For new files, it should conform to the style for that component. Last, if there's a completely new component, anything that is reasonably broadly accepted is fine.

The general rule we follow is "use Visual Studio defaults". For details check the [Naming Guidelines](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/naming-guidelines) of .NET guide.

1. We use [Allman style](http://en.wikipedia.org/wiki/Indent_style#Allman_style) braces, where each brace begins on a new line. Even a single line statement block should go with braces and nested in other statement blocks that use braces.
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
