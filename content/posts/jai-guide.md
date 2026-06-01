---
title: "A guide to the Jai language"
date: "2026-06-01"
description: A general Jai guide for somewhat experienced programmers.
summary: "A general Jai guide for somewhat experienced programmers."
ShowToc: true
TocOpen: true
ShowBreadCrumbs: true
---

## Types

This is a table that hold a comparison of all fundamental types you should know about:

| Type:                      | Jai             |
|----------------------------|-----------------|
| 32 bit floating            | `float32`       |
| 64 bit floating            | `float64`       |
| 128 bit floating           | `f128`          |
| 8 bit integer signed       | `s8`            |
| 8 bit integer unsigned     | `u8`            |
| 16 bit integer signed      | `s16`           |
| 16 bit integer unsigned    | `u16`           |
| 32 bit integer signed      | `s32`           |
| 32 bit integer unsigned    | `u32`           |
| 64 bit integer signed      | `s64`           |
| 64 bit integer unsigned    | `u64`           |
| boolean                    | `bool`          |
| character                  | `todo`          |
| string                     | `string`        |
| null                       | `todo`          |

Jai strings are array views over `u8` and are not null-terminated.

## References

Jai does not have C++ references. It has value semantics by default and uses pointers when you need an address.

A regular parameter doesnt mutate the original:
```jai
foo :: (x: int) {
    x = 2; // only local copy changes
}
```

A pointer parameter mutates the caller:
```jai
foo :: (x: *int) {
    x.* = 2; // non local changes
}
```

## Memory

Jai variables are stack-allocated by default. Heap allocation is explicit and usually handled through allocator helpers.

stack:
```jai
x := 10;
```

heap via the `Basic` module:
```jai
#import "Basic";

ptr: *int = New(int);
ptr.* = 10;
```

## Pointers

pointers have the same semantics as in c, but not the same syntax. The address-of operator is `*x`, and dereference is the `p.*` operator.

```c
// c

int x = 1;
int* p = &x;
*p = 2;
```

```jai
// jai

x := 1;
p: *int = *x;
p.* = 2;
```

Pointer arithmetic works like C:
```jai
arr: [4]int;
p: *int = arr.data; // data is the adress of the array
p += 1; // advance by size_of(int)
```

dereference chaining in C is like this:

```c
// c
*p = 2; // single
(*(*(*p))) = 2; // chain
```

dereference chaining in jai is like this:

```jai
// jai
p.* = 2; // single
p.*.*.* = 2; // chain
```

## Headers

Jai has no header files. Code organization is handled by `#import` and `#load` instead.
There is no need for `#include` or header guards in Jai, because multiple `#load` calls dont cause duplicate symbols inclusion.
The modules are searched for in the `jai/modules/` directory next to the jai compiler, you can add your own modules here if you want.

Import a module:
```jai
#import "Basic";
```

Load exported members of a file:
```jai
#load "my_file.jai";
```

Named imports create a namespace:
```jai
Math :: #import "Math";
value := Math.sqrt(2.0);
```

## Standard Library

Most projects start with `Basic`, it includes the tools for heap allocation and io streams.

## Initialization

Jai distinguishes declaration, initialization, and constants.

- `::` declares a constant
- `:=` declares a variable with an initial value
- `:` declares a variable with an explicit type
- `=` assignes but doesnt declare a variable

Examples:
```jai
PI :: 3.141592; // compile time constant
a := 3; // mutable
b: int = 5; // explicit type
c: string; // default value (zero initialized)
d: int = ---; // uninitialized
```

Jai supports unique struct and array initialization syntax:

Structs:
```jai
// explicit type
point: Point = Point.{ 1, 2 }; // T.{}

// inferred type
point: Point = .{ 1, 2 }; // .{}
```

Arrays:
```jai
// explicit type
arr: [4]int = int.[ 1, 2, 3, 4 ]; // T.[]

// inferred type
arr: [4]int = .[ 1, 2, 3, 4 ]; // .[]
```

## Public / Private

Jai does not use `public`/`private` member access labels.
Visibility is controlled by module scope and directives such as `#scope_file` and `#scope_export`.

## Structs

Jai structs are defined directly. There is no `typedef` requirement. The name `Point` is the type.

Example:
```jai
Point :: struct {
    x: int;
    y: int;
};
```

## Lambda Expressions

Jai does not have lambda syntax like C++ or C#, instead functions are already first class types in jai;

Example using a function pointer like a lambda:
```jai
add :: (a: int, b: int) -> int {
    return a + b;
}

action: (int,int)->int = add; // (int,int)->int is the function pointer type
result := action(1, 2);
```

## Casting

The jai syntax is similar to c in this regard, in c it would be `(T)value` while in jai its `cast(T) value`, it only adds the cast word and an extra space.
Jai is strict about casts. Implicit widening is allowed, but narrowing requires an explicit cast.

Example:
```jai
a: u32 = 50000;
b: u16 = cast(u16) a;
```

For truncation or unchecked casts, use the `trunc` or `no_check` flags. 
Also Jai uses comma-separated “attributes” like this: `operation,modifier1,modifier2(type) value`:
```jai
b = cast,trunc(u16) a;
b = cast,no_check(u16) a;
```

Use `xx` when you want the compiler to infer the target type:
```jai
b = xx a;
```

## Operator Overloading

Jai supports operator overloading for many operators: `+`, `-`, `*`, `/`, `%`, `==`, `!=`, `<<`, `>>`, `[]`, and more.

Jai syntax follows this rule: `operator + :: implementation`, where `+` can be any other operator. Unlike C, Jai needs spaces around the operator symbol.

Example:
```jai
Vector3 :: struct {
    x: float;
    y: float;
    z: float;
};

operator + :: (a: Vector3, b: Vector3) -> Vector3 {
    c: Vector3;
    c.x = a.x + b.x;
    c.y = a.y + b.y;
    c.z = a.z + b.z;
    return c;
}
```

`#symmetric` makes it so order doesnt matter:
```jai
operator * :: (a: Vector3, b: float) -> Vector3 #symmetric {
    c : Vector3;
    c.x = a.x * b;
    c.y = a.y * b;
    c.z = a.z * b;
    return c;
}
```

## Arrays / Lists

Static arrays:
```jai
arr : [4]int;
arr[0] = 1;
```

Dynamic arrays:
```jai
arr : [..]int;
array_add(*arr, 1);
```

Static arrays expose `.count`:
```jai
print("count = %\n", arr.count);
```

Multi-dimensional arrays are nested:
```jai
matrix : [4][4]float;
```

Dynamic arrays are similar to `std::vector` but use Jai’s allocator and context system.

## Array Pointer Decay

Jai static arrays do not decay to pointers the way C/C++ arrays do.
Instead, an array has a `.data` field for its backing pointer.

Example:
```jai
arr : [5]int;
ptr : *int = arr.data;
```

If you need a view, use a separate array view or dynamic array type.

## Generics / Templates

Jai uses compile-time polymorphism with `$T` and `Type`.

Generic function:
```jai
foo :: (x: $T) {
    print("%\n", x);
}
```

Polymorphic struct:
```jai
Box :: struct(T: Type) {
    value: T;
};

b : Box(int);
b.value = 5;
```

You can constrain polymorphic types with `/` and `interface` syntax.

## Strings

Jai strings are views over `u8`.

Examples:
```jai
s := "hello";
print("%\n", s);
```

Common helpers include `join`, `split`, `equal`, `compare`, `contains`, `begins_with`, and `ends_with`.

`to_c_string` allocates a C-style string on the heap, and `c_style_strlen` computes its length.

## Immutables And Statics

Jai constants are created with `::`.

Example:
```jai
PI :: 3.141592;
```

There is no `readonly` or `constexpr` keyword in the same way as C++.

File-local scope is expressed with `#scope_file`, while exported symbols use `#scope_export`.

## Header Guards

Not applicable in Jai: there are no header files, so there is no need for header guards.

## Optional Header Only Libraries

Not applicable in Jai either.
Jai libraries are modules and source files, not header-only libraries.

## Preprocessor

Jai has compile-time directives rather than a traditional C preprocessor.

Common directives:
- `#import`
- `#load`
- `#if`, `#else`, `#elif`, `#endif`
- `#exists`
- `#run`
- `#type`
- `#add_context`

Example:
```jai
#if DEBUG {
    print("debug build\n");
}
```

`#exists` lets you ask whether a symbol is available at compile time.

## Function Pointers

Function pointers are declared much like function types.

Example:
```jai
type_fn : (int, int) -> int;
add :: (a: int, b: int) -> int { return a + b; }
fn : type_fn = add;
result := fn(1, 2);
```

## Member Definition Outside The Class

Jai does not have separate class declarations and definitions.
There is no equivalent to `ClassName::MethodName()` because Jai does not use C++-style classes.

## Member Initializer List

Jai has no constructor member initializer list.
Structs are initialized directly, and fields are assigned via aggregate initialization or explicit assignment.

## L-values And R-values

Jai mostly treats named variables as addressable values and expressions as temporaries.

A variable like `x` is addressable, while `x + 1` is a temporary expression.

## Move Semantics

Jai does not have C++ move constructors or rvalue references.
Ownership is explicit: either copy values, or use pointers and allocators.

Example:
```jai
value := big_data;
copy := value; // copies the value if needed
```

For large buffers, prefer pointers or custom allocator-based containers.

## Notes

This guide matches the structure of the C++ reference guide, while explaining Jai’s equivalent concepts and the places where Jai intentionally diverges.
Multi-dimensional arrays work too:
```jai
matrix : [4][4]float;
```

## Polymorphism

Jai’s generics are compile-time polymorphism using `$T` and `Type` parameters.

A simple polymorphic function:
```jai
foo :: (x: $T) {
    print("%\n", x);
}

foo(1);
foo("hello");
```

A polymorphic struct:
```jai
Box :: struct(T: Type) {
    value: T;
};

b : Box(int);
b.value = 5;
```

Jai also supports type constraints such as `$T/SomeStruct` and `$T/interface SomeStruct`, which are similar to traits or interface-based matching.

## Modules and External Libraries

Jai uses modules instead of headers. You can import bundled modules with `#import` and local code with `#load`.

For external libraries, Jai can map foreign functions and dynamic libraries using `#library` and `#foreign` declarations.

Example:
```jai
lz4 :: #library "liblz4";
LZ4_compressBound :: (inputSize: s32) -> s32 #foreign lz4;
```

Callback types use `#type` and `#c_call` for ABI compatibility.

## Summary

- Jai has explicit fixed-width types, plus `int` = `s64` and `float` = `float32`.
- Jai has no C++ references; use pointers and `.*` dereference.
- Heap allocation is explicit and usually performed by library helpers.
- Jai does not use header files; it uses `#import` and `#load`.
- Polymorphism is compile-time and uses `$T` and `Type`.
- Jai’s initialization and constant syntax is different from C# / C++ but keeps the same concept of stack vs heap and value semantics.
