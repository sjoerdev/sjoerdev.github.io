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

## Memory

## Pointers

## Modules And Imports

## Standard Library

## Initialization

## Structs

## Casting

## Array Programming (Operator Overloading)

## Arrays / Slices

## Polymorphism (Generics)

## Strings

## Function Pointers / Function Types