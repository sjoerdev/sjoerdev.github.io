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

| Type:                      | Jai               | C#              | C++ (classic)             | C++ (modern)     |
|----------------------------|-------------------|-----------------|---------------------------|------------------|
| 32 bit floating            | `float32`/`float` | ``float``       | ``float``                 | -                |
| 64 bit floating            | `float64`         | ``double``      | ``double``                | -                |
| 128 bit floating           | `f128`            | ``decimal``     | -                         | -                |
| 8 bit integer signed       | `s8`              | ``sbyte``       | ``char``                  | ``int8_t``       |
| 8 bit integer unsigned     | `u8`              | ``byte``        | ``unsigned char``         | ``uint8_t``      |
| 16 bit integer signed      | `s16`             | ``short``       | ``short``                 | ``int16_t``      |
| 16 bit integer unsigned    | `u16`             | ``ushort``      | ``unsigned short``        | ``uint16_t``     |
| 32 bit integer signed      | `s32`             | ``int``         | ``int``                   | ``int32_t``      |
| 32 bit integer unsigned    | `u32`             | ``uint``        | ``unsigned int``          | ``uint32_t``     |
| 64 bit integer signed      | `s64`/`int`       | ``long``        | ``long long``             | ``int64_t``      |
| 64 bit integer unsigned    | `u64`             | ``ulong``       | ``unsigned long long``    | ``uint64_t``     |
| boolean                    | `bool`            | ``bool``        | ``bool``                  | -                |
| character                  | `u8`              | ``char``        | ``char``                  | ``char16_t``     |
| string                     | `string`          | ``string``      | ``string``                | -                |
| null                       | `null`            | ``null``        | ``nullptr``               | -                |

In jai types are first class, meaning types are values. 
This means functions are values and can be assigned like any other value.
All types like `int` and `float` are of type `Type`.

```jai
a: Type = int; // a is int
b: a = 1; // b is now an int
```

If a `Type` is constant (in other words, known at compile time), you can declare other variables of that `Type`.
In general, the kinds of things you would do with 'generics' in other languages, we just do with constant Type variables. 

## Loops

**Simple for loops:**

The simple format for for loops is `for set action`, where the `set` is something that supports iteration and `action` is a statement or a block.

```jai
for 1..10 {
    print("%", it); // it is the iteration
}

for i: 1..10 {
    print("%", i); // you can name the iteration
}

for foods {
    print("%, %", it_index, it); // if looping over a collection you can use it_index to get its index
}

for element, index: foods {
    print("%, %", index, element); // you can also name both the iteration and the index
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
for * element: array { // To iterate an array by pointer, add a * in front of the for loop.
    element.* = 0; // Because you are taking a pointer to the array, you can modify the array elements.
}

for array {
    print("%", it); // simple jai style array loop
}

for i: 0..array.count-1 {
    print("%", array[i]); // c like verbose array loop
}

for 1..10 print("%", it); // single like loops are also allowed
```

**The remove statement:**

The remove statement is used to remove an element from a `[..]` dynamic array, 
the remove swaps the current element that is being iterated on with the last element, 
and then removes the last element.

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

## Ternary Operator

jai uses `ifx` as its ternary operator, the syntax is `ifx condition then value else value`, but `then` is optional:

```jai
a := 0;
b := 100;

c := ifx a > b 10 else 1000; // without explicit then
d := ifx a > b then 10 else 1000; // with explicit then
```

## References

Jai has a unique take on how to deal with reference vs value semantics.

Arguments to procedures fall into two basic categories:

- `small` -> basic types that are less than or equal to 8 bytes.
- `big` -> any type larger than 8 bytes, and any struct regardless of size.

The `small` arguments are always passed by value into a procedure. They fit into simple machine
registers on a 64-bit machine, so it would be less efficient to pass them by reference than
by value. So they are always passed by value. These arguments behave the same as they do in C.

The `big` arguments are passed maybe by reference. But in terms of language semantics, it looks like
you have a copy of the struct by value. It behaves like a `const&` parameter would
behave in C++, so you can't modify it even though it was passed by reference.

In practive things pretty much always work as if they are copied and if you want to modify what you pass you use a pointer.
You can pretend like everything is passed by value like it is in the C language.

A regular parameter doesnt mutate the original:
```jai
foo :: (x: int) {
    x = 2; // only changes local copy of x value
}
```

A pointer parameter mutates the caller:
```jai
foo :: (x: *int) {
    x.* = 2; // changes the original x value
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
int** c = &b;
int*** d = &c;

int e = (*(*(*d))); // dereference in a chain
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

Jai does not use `public`/`private` member access labels.
Visibility is controlled by module scope and directives such as `#scope_file` and `#scope_export`.

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

// inferred type (since beta 0.2.022)
point: Point = { 1, 2 }; // {}

// designated initializer
point: Point = .{ x = 1, y = 2 }; // notice how the fields dont need a dot like in c and cpp

// default initialized
point: Point = .{};
```

Arrays:
```jai
// explicit type
arr: [4]int = int.[ 1, 2, 3, 4 ]; // T.[]

// inferred type
arr: [4]int = .[ 1, 2, 3, 4 ]; // .[]

// default initialized
arr: [4]int = .[];
```

## Structs

Jai structs are defined directly. There is no `typedef` requirement. The name `Point` is the type.

In jai, structs store their memory in the same order as their fields.

Example:
```jai
Point :: struct {
    x: int;
    y: int;
};
```

in jai, you can make the fields of a struct available in local scope with the `using` keyword:

```jai
point: Point;
using point; // now all point's members are local names for us.
x = 10; // this modifies the x of point
```

in jai You can copy structs around in memory, manually, if you want, like to an array and back:

```jai
Point :: struct {
    x: int;
    y: int;
};

point: Point;
arr: [size_of(Point)]u8;

memcpy(arr.data, *point, size_of(Point)); // copies all bytes in the struct to a byte array
memcpy(*point, arr.data, size_of(Point)); // copies all bytes back into the struct
```

## Casting

The jai syntax is similar to c in this regard, in c it would be `(T)value` while in jai its `cast(T)value`, it only adds the cast word.
Jai is strict about casts. Implicit widening is allowed, but narrowing requires an explicit cast.

Example:
```jai
a: u32 = 50000;
b: u16 = cast(u16)a;
```

For truncation or unchecked casts, use the `trunc` or `no_check` flags:
```jai
b = cast,trunc(u16)a;
b = cast,no_check(u16)a;
```

Use `xx` when you want the compiler to infer the type to cast to:
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

both static arrays and dynamic arrays are automatically casted to array views (slices) if the array view is a parameter.

regular arrays:
```jai
// simple array
array: [4]int; // create empty

array: [4]int = int.[1, 2, 3, 4]; // initialize with explicit type using array litteral
array: [4]int = .[1, 2, 3, 4]; // initialize with inferred type using array litteral

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
slice: []int = int.[1,2,3,4,5]; //  represents a view into the data that is contained in an array or a subsection of an array

ptr: int* = slice.data; // pointer to the first element of the slice

size: int = slice.count; // the size of the slice
```

multi dimensional arrays:
```jai
array: [2][2]int; // creating a 2D static array
array: [2][2][2]int; // creating a 3D static array

array: [2][2]int = int.[int.[1, 0], int.[0, 3]]; // initializing a 2D array
array: [2][2]int = .[.[1, 0], .[0, 3]]; // initializing a 2D array with inferred type

value: int = array[0][0]; // indexing a 2D array
```

Static arrays actually hold all of their own data, meaning that copying a static array does a full copy.
Dynamic arrays and array views (slices) are basically just pointers, 
therefore copying them doesnt copy the actual data, therefore they act like reference types.
This is what each type of array basically is in practice:

```jai
// regular array
one largu unit holding all of the actual data

// dynamic array
struct {
    count: s64; // number of elements
    data: *void; // location of the first element
    allocated: s64; // total bytes used
    allocator: Allocator; // the allocator in use
}

// array view (slice)
struct {
    count: s64; // number of elements
    data: *u8; // location of the first element
}
```

## Polymorphism (Generics)

In jai generics is called polymorphism.

Jai’s generics system is compile time polymorphism using the `x: $T` and `$T: Type` parameters.

The `$` before a value means we must know the value at compile time (needs to be a constant) for it to work.

Generic function taking variable of any type:
```jai
foo :: (x: $T) {
    print("%\n", x);
}

foo(1);
foo("hello");
```

Generic function taking a type itself as parameter:
```jai
foo :: ($T: Type) {
    print("size of type = %", size_of(T));
}

foo(int);
foo(string);
```

Generic function with multiple types:
```jai
foo :: (a: $A, b: $B) {
    // do something
}
```

Generic structs:
```jai
Box :: struct($T: Type) {
    value: T;
};

box: Box(int);
box.value = 5;
print("type = %", box.T); // you can quiry the type of a stuct like this (prints out "type = int")
```

## Interfaces / Traits / Constraints

todo

uses things like `/`, `interface`, `$T/SomeStruct`, `$T/interface SomeStruct`

When working with polymorphic procedures and structs, there's a lightweight syntax for restricting the type of the argument. It looks like: `f :: (x: $T/SomeType) { ... }`

`$T/Object` indicates that the `$T` must be a parameterized struct of the type `Object`

```jai
HashTable :: struct (K: Type, V: Type, N: int) {
    keys: [N]K;
    values: [N]V;
}

function :: (table: $T/HashTable, key: T.K, value: T.V) {
  // do stuff
}

// implicit polymorphism version
function :: (table: Table, key: table.K, value: table.V) {
  // do stuff
}
```

`$T/interface` Object indicates that the `$T` must have the fields that `Object` has. `$T/interface` accepts only types that contain members declared in the target struct.

```jai
Vec3 :: struct {
    x, y, z: float;
}

OtherVec3 :: struct {
    x, y, z: float;
}

dot_product :: (a: $T/interface Vec3, b: T) -> float {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

main :: () {
    another: OtherVec3;
    product := dot_product(another, another);
}
```

```jai
NamedType :: struct {
    name: string;
}

foo :: (x: $T/interface NamedType) {
    // do something
}

// Any struct with the same member names and types as 'NamedType' can be passed
// as an argument to 'foo'. This includes just a NamedType, but then it's
// pointless to use 'interface'. It's more for cases like this:

SomeThing :: struct {
    name: string;
    tag: string;
    type: Type;
}
```

## Strings

Jai strings are just array views (slices) over `u8`.
string literals in jai are actually null terminated in memory for c compatibility, 
even though this is not needed in jai since strings know their own length, 
but the null terminator is not included in the count of the string, 
so in jai it may seem like strings are actually not null terminated. 
this only counts for string literals, not runtime generated strings.

```jai
message: string = "Hello, World!";
length: int = message.count; // get string length

// strings are just array views over u8
data: *u8 = message.data; // get pointer to first byte

// you can slice strings
substring: string = message[0..5]; // "Hello"
```

## Compile Time Directives (Preprocessor)

todo

## Function Pointers / Function Types

Function pointers are declared much like function types.

Example:
```jai
add :: (a: int, b: int) -> int { return a + b; }

function_type: (int,int)->int; // declaring a function type
function: function_type = add; // declaring a function of our funciton type

function: (int,int)->int = add; // (int,int)->int is the function pointer type

result := function(1, 2);
```

## External Libraries / Interop

todo

## Comma Modifiers

In jai there is an interresting mostly undocumented syntax feature that used commas to pass modifiers to compiler directives and compiler keywords.

Since this isnt well documented right now, i have given the name comma modifier myself, i dont know how else to call it.

Jai currently doesnt have a complete list of all compiler directives and compiler buildin keywords, so many will be missing here.

Jai is changing constantly at the time of writing this (june 2026), and many of these directives will probably be depricated or changed.

these are some compiler directives that have comma modifiers:

| Directive         | Modifiers                                                     |
|-------------------|---------------------------------------------------------------|
| #code             | `,null` / `,typed` / `,infer`                                 |
| #import           | `,string` / `,file` / `,dir`                                  |
| #library          | `,system` / `,no_static_library` / `,no_dll` / `,link_always` |
| #run              | `,stallable` / `,host`                                        |
| #string           | `,cr`                                                         |
| #system_library   | `,no_dll` / `,link_always`                                    |
| #type             | `,distinct` / `,isa`                                          |


these are some build in compiler keywords that have comma modifiers:

| Keyword           | Modifiers                                                     |
|-------------------|---------------------------------------------------------------|
| cast              | `,trunc` / `,force` / `,no_check`                             |
| push_context      | `,defer_pop`                                                  |
| using             | `,except()` / `,only()` / `,map(mapper)` / `,no_parameters`   |

## Metaprogramming

todo

