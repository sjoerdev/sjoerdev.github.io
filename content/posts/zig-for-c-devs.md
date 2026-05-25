---
title: "Zig guide for C devs"
date: "2025-01-31"
description: |
    In this guide i will be comparing only the major differences between the languages, all the similarities will be left out.
    Zig is a modern systems programming language that improves upon C while maintaining its philosophy.
    As a C developer you don't need to learn Zig from the ground up, you just need to know the major differences.

summary: "In this guide i will be comparing only the major differences between C and Zig"
ShowToc: true
TocOpen: true
ShowBreadCrumbs: true
---

## Types

Zig has a similar set of types to C, but with some improvements and clearer naming. Here's a comparison:

| Type:                      | C                        | Zig              |
|----------------------------|--------------------------|------------------|
| 32 bit floating            | ``float``                | ``f32``          |
| 64 bit floating            | ``double``               | ``f64``          |
| 8 bit integer signed       | ``char`` / ``int8_t``    | ``i8``           |
| 8 bit integer unsigned     | ``unsigned char``        | ``u8``           |
| 16 bit integer signed      | ``short``                | ``i16``          |
| 16 bit integer unsigned    | ``unsigned short``       | ``u16``          |
| 32 bit integer signed      | ``int``                  | ``i32``          |
| 32 bit integer unsigned    | ``unsigned int``         | ``u32``          |
| 64 bit integer signed      | ``long long``            | ``i64``          |
| 64 bit integer unsigned    | ``unsigned long long``   | ``u64``          |
| boolean                    | ``bool`` (C99)           | ``bool``         |
| void/nothing               | ``void``                 | ``void``         |
| null                       | ``NULL``                 | ``null``         |
| undefined                  | N/A                      | ``undefined``    |
| pointer to type            | ``Type*``                | ``*Type``        |
| slice of type              | N/A                      | ``[]Type``       |
| array of type              | ``Type[size]``           | ``[size]Type``   |

One key difference is that Zig has an ``undefined`` value, which represents an uninitialized variable. This is explicitly different from a zero-initialized variable, which helps catch bugs at compile time or runtime.

## Pointers and References

In Zig, pointers work similarly to C but with some additional safety features:

**Basic Pointers:**

```zig
// zig
var x: i32 = 10;
var ptr: *i32 = &x;
var y: i32 = ptr.*;
```

Pointer syntax in Zig places the ``*`` before the type, not after the variable name like in C.

**Single-Item Pointers vs Many-Item Pointers:**

In Zig, there's a distinction between pointers to a single item and pointers to many items (arrays):

```zig
// zig

// pointer to single item
var x: i32 = 10;
var single: *i32 = &x;

// pointer to many items (like an array pointer in C)
var array: [5]i32 = [_]i32{1, 2, 3, 4, 5};
var many: [*]i32 = &array; // use [*]Type for array pointers
```

**Optional Pointers:**

Zig has optional types built into the language, making null pointers explicit:

```zig
// zig

var x: i32 = 10;
var maybe_ptr: ?*i32 = &x;

// check if the pointer is null
if (maybe_ptr) |ptr| {
    // ptr is not null here
    _ = ptr.*;
} else {
    // pointer was null
}
```

This is safer than C's implicit null pointers.

## Memory Management

**Stack vs Heap:**

Like C, Zig allows you to allocate on the stack or heap:

```zig
// zig

// stack allocation
var stack_array: [10]i32 = undefined;

// heap allocation (requires an allocator)
const allocator = // ... some allocator instance
const heap_array = try allocator.alloc(i32, 10);
defer allocator.free(heap_array); // use defer to free when scope exits
```

**Allocators:**

One of Zig's innovations is the explicit allocator pattern. Instead of having a single malloc/free system, you pass allocators to functions that need them:

```zig
// zig

const std = @import("std");

fn process_data(allocator: std.mem.Allocator) !void {
    const data = try allocator.alloc(u8, 1024);
    defer allocator.free(data);
    
    // use data
}
```

Common allocators include:
- ``std.heap.page_allocator`` - allocates entire pages
- ``std.heap.gpa`` - General Purpose Allocator with leak detection
- ``std.heap.arena_allocator`` - allocates memory in arenas, frees all at once

**Manual vs Automatic:**

Zig uses ``defer`` to handle cleanup, which is similar to Go's defer:

```zig
// zig

var file = try std.fs.cwd().openFile("test.txt", .{});
defer file.close(); // close() will be called when this scope exits
```

## Error Handling

**The Try-Catch Alternative:**

Unlike C's implicit error codes, Zig has explicit error handling built into the language. Functions that can error return an error union type:

```zig
// zig

// function that can fail
fn divide(a: i32, b: i32) !i32 {
    if (b == 0) {
        return error.DivisionByZero;
    }
    return a / b;
}

// calling a function that can error
fn main() !void {
    const result = try divide(10, 2); // try unwraps the value or returns the error
    std.debug.print("Result: {}\n", .{result});
}
```

**Error Sets:**

You can define custom error sets:

```zig
// zig

const FileError = error{
    NotFound,
    PermissionDenied,
    UnexpectedEOF,
};

const AllErrors = FileError || error{
    OutOfMemory,
    InvalidData,
};

fn read_file(path: []const u8) AllErrors![]u8 {
    if (!file_exists(path)) {
        return error.NotFound;
    }
    // ...
}
```

**Try vs Catch:**

The ``try`` keyword is shorthand for returning errors:

```zig
// zig

// these two are equivalent:
const x = try maybe_error_fn();

// is equivalent to:
const x = maybe_error_fn() catch |err| return err;

// you can also catch and handle:
const x = maybe_error_fn() catch |err| {
    std.debug.print("Error: {}\n", .{err});
    return;
};
```

## Slices

Zig has slices, which are a safer abstraction over array pointers. A slice is a pointer to data plus a length:

```zig
// zig

var array: [5]i32 = [_]i32{1, 2, 3, 4, 5};

// create a slice from array
var slice: []i32 = &array;

// slice a portion
var sub_slice: []i32 = array[1..4]; // elements 1, 2, 3

// get length
var len: usize = slice.len;

// index
var first: i32 = slice[0];

// iterate
for (slice) |item| {
    std.debug.print("{}\n", .{item});
}
```

Slices are much safer than C's pointer arithmetic because they carry length information.

## Structs

In Zig, structs are defined similarly to C but with some modern features:

```zig
// zig

const Point = struct {
    x: i32,
    y: i32,
};

// create instance
var p: Point = .{
    .x = 10,
    .y = 20,
};

// field access
var x = p.x;
```

**Methods:**

Zig doesn't have methods like C++ or C#, but you can define functions that take structs as arguments:

```zig
// zig

const Point = struct {
    x: i32,
    y: i32,
};

fn distance(self: Point, other: Point) i32 {
    const dx = self.x - other.x;
    const dy = self.y - other.y;
    return @intCast(i32, @sqrt(dx * dx + dy * dy));
}

var p1: Point = .{ .x = 0, .y = 0 };
var p2: Point = .{ .x = 3, .y = 4 };
var dist = distance(p1, p2);
```

## Functions

Functions in Zig are similar to C but with some differences in declaration:

```zig
// zig

// basic function
fn add(a: i32, b: i32) i32 {
    return a + b;
}

// function that returns void
fn print_message() void {
    std.debug.print("Hello\n", .{});
}

// function that can error
fn risky_operation() !void {
    // ...
}

// function with default parameters (not directly supported, use overloading or struct params)
```

**Calling Convention:**

```zig
// zig

// simple call
const result = add(5, 3);

// calling with error handling
fn wrapper() !void {
    try risky_operation();
}
```

## The Comptime Feature

One of Zig's most powerful features is ``comptime``, which allows you to run code at compile time:

```zig
// zig

// compute value at compile time
const BUFFER_SIZE: usize = comptime 1024 * 1024;

// generic-like behavior using comptime
fn ArrayList(comptime T: type) type {
    return struct {
        items: []T,
        capacity: usize,
    };
}

// use the comptime function
var list: ArrayList(i32) = undefined;

// compute array at compile time
const LOOKUP_TABLE = comptime blk: {
    var table: [256]u32 = undefined;
    for (0..256) |i| {
        table[i] = i * i;
    }
    break :table;
};
```

Comptime is similar to C macros or C++ templates but much more powerful and explicit.

## Imports and Modules

Zig doesn't have header files like C. Instead, it uses the ``@import`` builtin to import modules:

```zig
// zig

// import the standard library
const std = @import("std");

// import a local module
const my_module = @import("my_module.zig");

// use imported items
var arena = std.heap.ArenaAllocator.init(allocator);
var result = my_module.my_function();
```

All Zig files are modules, and you can import any ``.zig`` file directly. There are no header/implementation separation like C.

Zig does not have an official package manager like Cargo or NuGet. Dependencies are normally included as source in your repository, and `build.zig` is used to wire them into the build. That means Zig code dependencies are usually compiled together as source, so Zig projects are effectively static at the Zig-source level.

Many projects use vendoring or git submodules to manage external libraries, because keeping dependency source in the tree is the most common way to share Zig code. But git submodules are a workflow choice, not a Zig language feature.

Multiple files can safely `@import("same_module.zig")`; the compiler treats it as the same shared module and does not duplicate the code.

## Strings and Arrays

**String Literals:**

```zig
// zig

// string literal (comptime known length)
const hello: []const u8 = "hello";

// string literal with explicit length annotation
const hello_str = "hello world";

// byte array
const bytes: [5]u8 = "hello".*;
```

**Arrays:**

```zig
// zig

// fixed-size array
var array: [5]i32 = [_]i32{1, 2, 3, 4, 5};

// array with undefined initialization
var uninitialized: [10]i32 = undefined;

// get length
var len = array.len;

// slice the array
var slice = array[1..4];

// iterate
for (array) |item| {
    std.debug.print("{}\n", .{item});
}

// enumerate with index
for (array, 0..) |item, i| {
    std.debug.print("[{}] = {}\n", .{i, item});
}
```

## Type Casting and Coercion

Zig has explicit casting builtins:

```zig
// zig

// explicit cast using @intCast
var x: i64 = 1000;
var y: i32 = @intCast(i32, x);

// float to int
var f: f32 = 3.14;
var i: i32 = @intFromFloat(i32, f);

// int to float
var num: i32 = 42;
var floating: f32 = @floatFromInt(f32, num);

// pointer cast
var ptr: *u8 = @ptrCast(*u8, some_other_ptr);

// bitcast (reinterpret bits)
var f: f32 = 3.14;
var bits: u32 = @bitCast(u32, f);
```

The explicit nature of casts makes it clear where type conversions happen.

## Initialization

**Variable Declaration:**

```zig
// zig

// mutable variable with explicit type
var x: i32 = 10;

// mutable variable with inferred type
var y = 10; // type is i32

// immutable constant with explicit type
const z: i32 = 10;

// immutable constant with inferred type
const w = 10;

// uninitialized variable
var uninitialized: i32 = undefined;

// array initialization
var array = [_]i32{1, 2, 3, 4, 5}; // underscore means infer length

// struct initialization with named fields
var point = Point{ .x = 10, .y = 20 };
```

**Key Differences from C:**

- Zig requires explicit ``var`` or ``const`` keywords
- Zig infers types when possible
- Zig distinguishes between mutable and immutable variables at the declaration level

## Build System

Zig has a built-in build system that replaces the need for Make, CMake, etc.:

```bash
# build a project
zig build

# run tests
zig build test

# build and run
zig build run

# set optimization level
zig build -Doptimize=ReleaseFast
```

The build system is defined in a `build.zig` file:

```zig
// zig (build.zig)

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "myapp",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
```

## Testing

Zig has built-in testing support with the ``test`` keyword:

```zig
// zig

const std = @import("std");

fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "add function" {
    try std.testing.expectEqual(add(2, 2), 4);
    try std.testing.expectEqual(add(-1, 1), 0);
}

test "another test" {
    var x: i32 = 10;
    try std.testing.expect(x > 5);
}
```

Run tests with:
```bash
zig build test
```

## Optional Types

Zig has optional types built into the language (using the ``?`` syntax):

```zig
// zig

// declare optional type
var maybe_value: ?i32 = 10;
maybe_value = null; // can be set to null

// check and unwrap optional
if (maybe_value) |value| {
    std.debug.print("Value: {}\n", .{value});
} else {
    std.debug.print("Value is null\n", .{});
}

// unwrap with default
var x: i32 = maybe_value orelse 0;

// function returning optional
fn find_item(items: []const i32, target: i32) ?usize {
    for (items, 0..) |item, i| {
        if (item == target) {
            return i;
        }
    }
    return null;
}
```

## Builtins

Zig provides many builtins using the ``@`` prefix. Some common ones:

```zig
// zig

// type operations
@typeInfo(type) // get information about a type
@sizeOf(type) // get size of a type
@alignOf(type) // get alignment of a type

// memory operations
@memcpy(dst, src, len) // copy memory
@memset(ptr, value, len) // set memory

// integer operations
@intCast(target_type, value) // cast integer
@intFromFloat(int_type, float_value) // float to int
@floatFromInt(float_type, int_value) // int to float

// other
@import("module") // import a module
@panic("message") // terminate with panic
@cImport { ... } // import C headers
```

## C Interop

Zig can call C code directly and easily:

```zig
// zig

// import a C header
const c = @cImport(@cInclude("stdio.h"));

pub fn main() void {
    c.printf("Hello from C!\n");
}
```

Zig can also be called from C code, making it easy to integrate with existing C projects.

## Defer Statement

The ``defer`` statement ensures code runs when the scope exits, similar to Go:

```zig
// zig

const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("test.txt", .{});
    defer file.close(); // this will always run before exiting the scope

    var buffer: [256]u8 = undefined;
    const bytes_read = try file.readAll(&buffer);
}
```

This is a safer alternative to manual resource management in C.

## Union Types

Zig has union types for representing values that can be one of several types:

```zig
// zig

const Value = union {
    int: i32,
    float: f32,
    bool: bool,
};

var v: Value = .{ .int = 42 };

// access the value
var i = v.int; // 42

// switch on union
switch (v) {
    .int => |value| std.debug.print("Int: {}\n", .{value}),
    .float => |value| std.debug.print("Float: {}\n", .{value}),
    .bool => |value| std.debug.print("Bool: {}\n", .{value}),
}
```

Tagged unions (which union you're using is tracked at runtime) are also supported.

## Dot based type inference

In zig a type can be inferred, but inference is explicitely denoted by a dot. The leading . is a shorthand literal/variant marker used when the target type can be inferred from context:

```zig
// zig

// arrays
const array1: [4]i32 = .[1, 2, 3, 4];
const array2: [4]i32 = [4]i32{1, 2, 3, 4};

// structs
const p1: Point = .{ .x = 10, .y = 20 };
const p2: Point = Point{ .x = 10, .y = 20 };

// enum values
const color1: Color = .Red;
const color2: Color = Color.Red;
```

## Object like behaviour

In zig you can get something like an object with members by using this:

```zig
// zig

const Foo = struct {
    test: i32,

    fn Bar(self: @This(), x: i32) i32 {
        return self.test * x;
    }
};

const foo = Foo{ .test = 3 };
const result = foo.Bar(10); // 30
```

## Enums

Zig has enums similar to C but with more features:

```zig
// zig

const Color = enum {
    Red,
    Green,
    Blue,
};

var c: Color = Color.Red;

// enums can have associated values
const Status = enum {
    Success,
    Error: []const u8, // error with message
};

var status: Status = .Success;
status = .{ .Error = "Something failed" };

// switch on enum
switch (c) {
    .Red => std.debug.print("Red\n", .{}),
    .Green => std.debug.print("Green\n", .{}),
    .Blue => std.debug.print("Blue\n", .{}),
}
```

## Key Differences Summary

| Aspect                | C                           | Zig                              |
|-----------------------|-----------------------------|----------------------------------|
| Error handling        | Implicit return codes       | Explicit error union types       |
| Memory allocation     | malloc/free                 | Allocators (explicit)            |
| Memory cleanup        | Manual                      | defer statement                  |
| Type inference        | Not available               | Yes, with ``var`` and ``const``  |
| Null pointers         | Implicit                    | Explicit with ``?*Type``         |
| Arrays                | Pointer decay               | Proper arrays and slices         |
| Modules               | Header/implementation files | Single .zig files                |
| Compile-time code     | Preprocessor (macros)       | comptime feature                 |
| Safety                | Low                         | Higher (bounds checking, etc.)   |
| Cross-compilation     | Complex                     | Built-in and easy               |
| Testing               | Not built-in                | Built-in ``test`` keyword        |

## Things to Remember About Zig

- Zig is a modern systems language designed to improve upon C while staying true to its philosophy
- Error handling is explicit and type-safe
- Memory management is explicit through allocators and defer
- Comptime is a powerful feature for zero-cost abstractions
- There are no header files - all code is in .zig files
- Zig has better cross-compilation support than C
- C interoperability is seamless both ways
- The language is still evolving, so expect changes in newer versions
