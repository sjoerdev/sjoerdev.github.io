---
title: "A guide to the Odin language"
date: "2026-06-01"
description: A general Odin guide for somewhat experienced programmers.
summary: "A general Odin guide for somewhat experienced programmers."
ShowToc: true
TocOpen: true
ShowBreadCrumbs: true
---

## Types

This is a table that hold a comparison of all fundamental types you should know about compared to what they are in other languages:

|          Type:           |        Odin        |    C#     |
| ------------------------ | ------------------ | --------- |
| 16 bit floating          | `f16`              |           |
| 32 bit floating          | `f32`              | `float`   |
| 64 bit floating          | `f64`              | `double`  |
| 128 bit floating         |                    | `decimal` |
| 8 bit integer signed     | `i8`               | `sbyte`   |
| 8 bit integer unsigned   | `u8`               | `byte`    |
| 16 bit integer signed    | `i16`              | `short`   |
| 16 bit integer unsigned  | `u16`              | `ushort`  |
| 32 bit integer signed    | `i32`              | `int`     |
| 32 bit integer unsigned  | `u32`              | `uint`    |
| 64 bit integer signed    | `i64`              | `long`    |
| 64 bit integer unsigned  | `u64`              | `ulong`   |
| 128 bit integer signed   | `s128`             |           |
| 128 bit integer unsigned | `u128`             |           |
| pointer sized integer    | `uintptr`          | `nint`    |
| boolean                  | `bool`             | `bool`    |
| character                | `rune`             | `char`    |
| string                   | `string`/`cstring` | `string`  |
| no type                  | `any`              | `object`  |
| type identifier          | `typeid`           | `Type`    |
| null                     | `nil`              | `null`    |

In odin types are first class, meaning types are values. 
This means functions are values and can be assigned like any other value.
All types like `int` and `float` are of type `typeid`.

```odin
a :: int; // a is int
b: a = 1; // b is now an int
```

In Odin `typeid` is a bit of an overloaded term, because there is a difference between a compile time typeid and a runtime typeid.
if it's at compile time, typeid is a type, if it's at runtime, typeid is an integer representing a type
```odin
x :: int // this works, x is a *type*
x := int // error, you'll need to do typeid_of(int)
```

## Loops

**Simple for loops:**

Doing loops in Odin is very simple and c like, with some nice syntax choices, like merging for and while loops, 
and having a `for value in collection` syntax for things like arrays.

```odin
// basic loop
for i := 0; i < 10; i += 1 {
	fmt.println(i)
}

// while loop equivelant
for i < 10 {
	fmt.println(i)
}

// range loop
for i in 0..<10 {
	fmt.println(i)
}

// array loop (array/slice/dynamic/string/map)
for value in some_array {
	fmt.println(value)
}

// named index array loop
for value, index in some_array {
	fmt.println(index, value)
}

// named key and value map loop
for key, value in some_map {
	fmt.println(key, value)
}

// infinite loop
for {
	fmt.println(i)
}

// nested loop
for i := 0; i < 10; i += 1 {
	for j := 0; j < 10; j += 1 {
        fmt.println(i, j)
    }
}

// nested array loop
for outer in outer_array {
	for inner in inner_array {
        fmt.println(inner, outer)
    }
}

// reverse loop
#reverse for x in array {
	fmt.println(x)
}

// array loop by reference
for &value in some_array {
	value = something // element can be modified
}

// map loop by referende (key can not be referenced)
for key, &value in some_map {
	value += 1
}

// single line loops with scope block
for i := 0; i < 10; i += 1 { }

// single line loop (using the do keyword)
for i := 0; i < 10; i += 1 do foo()
```

## Ternary Operator

In Odin there are 3 types of ternary operator syntaxes:

```odin
foo = condition ? x : y // runtime ternary
foo = x if condition else y // runtime ternary
foo = x when condition else y // compile time ternary
```

## References

In odin there are no references like in C++ and no reference types like in C#, Odin is similar to C in that you need a pointer to reference variables.
    
When passing a value as an argument, it passes as a pointer automatically if its more effecient
this is enabled by the fact that all parameters are immutable in Odin, like a `const&` in cpp, making it feel like everything is always copied like in c.

Passing a pointer value always makes a copy of the pointer, not the data it points to. 

slices, dynamic arrays, and maps have no special considerations here, 
they are normal structs with pointer fields, and are passed as such, in that regard they work like reference types.

## Memory

Odin is a manual memory managed language, it requires you to allocate and free heap memory yourself. Stack memory is tied to its scope and freed automatically.

`new()` -> allocates a value of the type given and returns a pointer:

```odin
ptr: ^int = new(int)
```

`free()` - frees the memory at the pointer given:

```odin
ptr: ^int = new(int)
free(ptr)
```

`make()` - allocates memory for the backing data of either a slice, dynamic array, or map:

```odin
my_slice := make([]int, 100)
my_dynamic_array := make([dynamic]int, 100)
my_map := make(map[string]int, 100)
```

`delete()` - deletes the backing memory of a anything allocated with make:

```odin
delete(my_slice)
delete(my_dynamic_array)
delete(my_map)
```

## Pointers

pointers have the same semantics as in c, but not the same syntax. using `^type` as pointer types, `ptr^` as dereference syntax, and `&value` as the adress of operator.

```c
// c
int x = 1;
int* p = &x;
*p = 2;
```

```odin
// odin
x := 1;
p: ^int = &x;
p^ = 2;
```

There is no such thing as pointer aritmatic like in c, 
because unlike in c, arrays are not just pointers, 
for pointer arritmatic like behaviour there are "multi pointers" of the `[^]T` type, 
which are pointers that map to multiple items, and can be indexed like an array. 
multi pointers are easiest to use with the `raw_data()` buildin call. 
the `raw_data` is a builtin which returns the underlying data of a builtin data type as a multi pointer.

simple usage example of a multi pointer:

```odin
ptr: [^]int
arr := [3]int{10, 20, 30}
ptr = raw_data(arr[:]) // get multi pointer to a slice of the array
fmt.println(ptr, ptr[1], arr) // 0x7FFCBE9FE688 20 [10, 20, 30]
```

basic rules for indexing and slicing for multi pointers:

```odin
mptr: [^]T
mptr[i] -> T // indexing
mptr[:] -> [^]T // slicing with full range
mptr[i:] -> [^]T // slicing with specific start
mptr[:n] -> []T // slicing with specific end
mptr[i:n] -> []T // slicing with specific start and end
```

what multi pointers support:
- indexing
- slicing (if both high and low operands are given)
- implicit conversions between `^T` and `[^]T`

What multi pointers do not support:
- dereferencing

## Modules And Imports

Instead of headers of modules or namespaces, the Odin language uses packages. 
Packages in odin are directory based, similar to how golang manages packages, 
this makes using submodules usefull, and makes it so you dont need a package manager.
In Odin a package is a directory of Odin code files, all of which have the same package declaration at the top.
Make a file part of a package by putting the `package package_name` declaration at the top of the odin files in the package. 
A directory cannot contain more than 1 package, so you can not have different package declarations in the same directory.
To import a package (make it accesable), you use the `import` keyword.
To import a standard library package you can use a prefex like `import "core:fmt"` where `core:` is the library prefix. 
If no prefix is specified the package will be searched relative to the current file path.
Packages can be namespaced by using the `import foo "core:fmt"` syntax.

## Standard Library

## Initialization

## Structs

## Casting

## Array Programming (Operator Overloading)

## Arrays / Slices

## Polymorphism (Generics)

## Strings

## Function Pointers / Function Types