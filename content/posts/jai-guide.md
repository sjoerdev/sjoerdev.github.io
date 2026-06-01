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

This is a table that hold a comparison of all fundamental types you should know about compared to what they are in other languages:


| Type:                      | Jai             | C#              | C++ (classic)             | C++ (modern)     |
|----------------------------|-----------------|-----------------|---------------------------|------------------|
| 32 bit floating            | `float32`       | ``float``       | ``float``                 | -                |
| 64 bit floating            | `float64`       | ``double``      | ``double``                | -                |
| 128 bit floating           | `f128`          | ``decimal``     | -                         | -                |
| 8 bit integer signed       | `s8`            | ``sbyte``       | ``char``                  | ``int8_t``       |
| 8 bit integer unsigned     | `u8`            | ``byte``        | ``unsigned char``         | ``uint8_t``      |
| 16 bit integer signed      | `s16`           | ``short``       | ``short``                 | ``int16_t``      |
| 16 bit integer unsigned    | `u16`           | ``ushort``      | ``unsigned short``        | ``uint16_t``     |
| 32 bit integer signed      | `s32`           | ``int``         | ``int``                   | ``int32_t``      |
| 32 bit integer unsigned    | `u32`           | ``uint``        | ``unsigned int``          | ``uint32_t``     |
| 64 bit integer signed      | `s64`           | ``long``        | ``long long``             | ``int64_t``      |
| 64 bit integer unsigned    | `u64`           | ``ulong``       | ``unsigned long long``    | ``uint64_t``     |
| boolean                    | `bool`          | ``bool``        | ``bool``                  | -                |
| character                  | `todo`          | ``char``        | ``char``                  | ``char16_t``     |
| string                     | `string`        | ``string``      | ``string``                | -                |
| null                       | `todo`          | ``null``        | ``nullptr``               | -                |

Jai strings are array views over `u8` and are not null-terminated.

## Loops

**Simple for loops:**

The simple format for for loops is `for set action`, where the `set` is something that supports iteration and `action` is a statement or a block.

```jai
for 1..10 {
    print("Number %\n", it); // it is the iteration
}

for i: 1..10 {
    print("Number %\n", i); // you can name the iteration
}

for foods {
    print(" %. %\n", it_index, it); // if looping over a collection you can use it_index to get its index
}

for i: 0..10 {
    for j: 0..10 {
        print("%, %", i, j); // you can also have a nested loop
    }
}

for < i: 0..10 {
    print("%", i); // to do a for loop in reverse, add a < in front of the for loop
}

array := int.[1, 2, 3, 4, 5];
for * ele: array { // To iterate an array by pointer, add a * in front of the for loop.
    ele.* = 0; // Because you are taking a pointer to the array, you can modify the array elements.
}


for 1..10 print("Number %\n", it); // single like loops are also allowed
```

**The remove statement:**

The remove statement is used to remove an element from a dynamic array [..] without needing to rewrite the entire for loop into a while loop. 
The remove statement assumes an unordered remove, the remove swaps the current element that is being iterated on with the last element, 
and then removes the last element. The remove statement happens in constant time O(1).

```jai
arr: [..]int;

for i: 0..10 {
    array_add(*arr, i); // adding element
}

for a: arr {
    if a == 2 {
        remove a; // removing element
    }
}
```

## Ternairy Operator


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

pointers to pointers and dereference chaining in c is like this:

```c
// c

int a = 3;
int* b = &a;
int** c = &b
int*** d = &c

int e = int e = (*(*(*d))); // dereference in a chain
```

pointers to pointers and dereference chaining in jai is like this:

```jai
// jai

a: int = 3;
b: *int = *a;
c: **int = *b;
d: ***int = *c;

e: int = d.*.*.*; // dereference in a chain
```

## Modules And Imports

Jai has no header files. Code organization is handled by `#import` and `#load` instead.
There is no need for `#include` or header guards in Jai, because multiple `#load` calls dont cause duplicate symbols inclusion.
The modules are searched for in the `jai/modules/` directory next to the jai compiler, you can add your own modules here if you want.

Import a module:
```jai
#import "Basic";
```

Load all exported functions/structs/globals of a file, and make the available here:
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

The jai syntax is similar to c in this regard, in c it would be `(T)value` while in jai its `cast(T)value`, it only adds the cast word.
Jai is strict about casts. Implicit widening is allowed, but narrowing requires an explicit cast.

Example:
```jai
a: u32 = 50000;
b: u16 = cast(u16)a;
```

For truncation or unchecked casts, use the `trunc` or `no_check` flags. 
Jai uses comma-separated “attributes” like this: `operation,modifier1,modifier2(type)value`:
```jai
b = cast,trunc(u16)a;
b = cast,no_check(u16)a;
```

Use `xx` when you want the compiler to infer the target type to cast to:
```jai
b = xx a;
```

## Operator Overloading

Jai supports operator overloading for many operators: `+`, `-`, `*`, `/`, `%`, `==`, `!=`, `<<`, `>>`, `[]`, and more.

Jai syntax follows this rule: `operator + :: implementation`, where `+` can be any other operator.

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

in jai a normal array is typed like ``[size]T``, and a slice like ``[]T``, and a dynamic array like ``[..]T``.

unlike in c, arrays store their length in jai, you can get it by the `array.count` member.

you can get the memory adress of the first element in an array using the `array.data` member.

Both Static Arrays and Dynamic Arrays are autocasted to Array Views if the array view is a parameter. Because strings are array views with u8, both share the same definition.

Arrays in jai are simply a tiny struct that holds the size and location of where the array actually is in memory. so copying an array directly makes an array that points to the same data.

You can initialize arrays using the following syntax:

```jai
array: [4]float = float.[10.0, 20.0, 1.4, 10.0];
```

regular arrays:
```jai
// simple array
array: [8]int; // create
value: int = array[0]; // index
```

dynamic arrays:
```jai
// create dynamic array
array: [..]int;

// get length of dynamic array
length: int = array.count;

// add to the dynamic array
array_add(*array, 4);

// remove third element from the dynamic array

// index the dynamic array
value: int = array[0];

// clear the dynamic array
array_reset(*array);
```

slices (array views):
```jai
arr: []int = int.[1,2,3,4,5]; //  represents a view into the data that is contained in an array or a subsection of an array

```

multi dimensional arrays:
```jai
array: [2][2]int; // creating a 2D static array
array: [2][2][2]int; // creating a 3D static array

array: [2][2]int = int.[int.[1, 0], int.[0, 3]]; // initializing a 2D array
array: [2][2]int = .[.[1, 0], .[0, 3]]; // initializing a 2D array with inferred type

value: int = array[0][0]; // indexing a 2D array
```

## Array Pointer Decay

Jai static arrays do not decay to pointers the way C/C++ arrays do.
Instead, an array has a `.data` field for its backing pointer.

## Polymorphism (Generics)

In jai generics is called polymorphism.

Jai’s generics are compile-time polymorphism using `$T` and `Type` parameters.

Generic function:
```jai
foo :: (x: $T) {
    print("%\n", x);
}

foo(1);
foo("hello");
```

Generic function with multiple types:
```jai
foo :: (a: $A, b: $B, c: $C) {
    // use a or b or c here
}
```

Polymorphic structs:
```jai
Box :: struct(T: Type) {
    value: T;
};

b: Box(int);
b.value = 5;
print("type = %", a.T); // you can quiry the type of a stuct like this (prints out "type = int")
```

Jai also supports type constraints such as `$T/SomeStruct` and `$T/interface SomeStruct`, which are similar to traits or interfaces.

## Interfaces / Traits

todo

You can constrain polymorphic types with `/` and `interface` syntax.

## Strings

todo

Jai strings are are array views (slices) over `u8`, arrays are also not null terminated.

## Compile Time Directives (Preprocessor)

todo

## Function Pointers / Function Types

Function pointers are declared much like function types.

Example:
```jai
add :: (a: int, b: int) -> int { return a + b; }

function_type: (int,int)->int;
function: function_type = add;

function: (int,int)->int = add; // also works

result := function(1, 2);
```

## External Libraries / Interop

For external libraries, Jai can map foreign functions and dynamic libraries using `#library` and `#foreign` declarations.

Example:
```jai
lz4 :: #library "liblz4";
LZ4_compressBound :: (inputSize: s32) -> s32 #foreign lz4;
```

## Summary

- Jai has no C++ references; use pointers and `.*` dereference.
- Jai does not use header files; it uses `#import` and `#load`.
- Polymorphism is compile-time and uses `$T` and `Type`.