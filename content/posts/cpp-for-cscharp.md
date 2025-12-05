---
title: "C++ guide for C# devs"
date: "2025-01-31"
description: |
    In this guide i will be comparing only the major differences between the languages, all the similarities will be left out.
    This guide started as a personal reference card for myself to hold on to when writing C++ at work.
    As a C# developer you don't need to learn C++ from the ground up, you just need to know the major differrences.

summary: "In this guide i will be comparing only the major differences between C# and C++"
ShowToc: true
TocOpen: true
ShowBreadCrumbs: true
---

## Types

In C++ most types have the same or a similar name as in C#, but not always. 
This is a table that hold a comparison of all fundamental types you should know about:

![types](/images/table-types.png)

## References

In C++ classes are value types by default, not reference types like in C#.

Passing a class instance by reference to a function in C# is:
```csharp
// csharp
void Example(Class instance)
{
    // changes the original instance
    instance.variable = 1;

    // this creates a copy
    Class instance_copy = instance.Clone();
}
```

Passing a class instance by reference to a function in C++ is:
```cpp
// cpp
void Example(Class& instance)
{
    // changes the original instance
    instance.variable = 1;

    // this creates a copy
    Class instance_copy = instance;
}
```

You can also pass a class instance in C++ with a pointer:
```cpp
// cpp
void Example(Class* instance_ptr)
{
    // changes the original instance
    instance_ptr->variable = 1;

    // changes the original instance
    (*instance_ptr).variable = 1;

    // this creates a copy
    Class instance_copy = *instance_ptr;
}
```

## Memory

**Stack:**

When creating a variable in C++ it uses the stack by default.
Memory on the stack is local to its scope and gets released automatically when the variable goes out of scope.

**Heap:**

When you want memory to exist outside of the scope it is created in, you must allocate memory for it on the heap.
You can allocate memory on the heap using ``malloc()`` and release it using ``free()``.
But a better alternative is using ``auto variable = new Type();`` and release it using ``delete variable;``

**Leaks:**

In C++ heap memory does not automatically free when the application terminates. and in both C++ and C# OpenGL data like buffers and textures in vram also dont automatically free when the application terminates.
Generally speaking the os will reclaim unfreed memory when the application terminates, but relying on this is bad practice.

## Pointers

**Basic:**

Raw pointers in C++ work the same as in C#, the syntax is the exact same:
```cpp
int x = 1;
int* ptr = &x;
int y = *ptr;
```

it doesnt matter where in a pointer you use a space as it will all work:

```cpp
int* ptr = &x;
int *ptr = &x;
int*ptr = &x;
```

**Smart:**

There are 3 types of smart pointers: ``std::unique_ptr`` ``std::shared_ptr`` ``std::weak_ptr``, to use them with ``#include <memory>``

## Headers

![headers](/images/headers.png)

**What are they?:**

In C# you can acces functions that are in a different ``.cs`` file by just making them both use the same namespace. In C++, its a little bit more complex.
Header files can be seen as an outline of all the functions contained in a ``.cpp`` file.
All code goes in ``.cpp`` files, and then every file has a header ``.hpp`` file with the same exact name which contains all the declerations (names) of your functions.
Using headers help the compiler understand how source files are connected, which is one of the reasons C++ code compiles so very fast compared to C# code.

**How are they used?:**

You can access code from other files only by using ``#include "file.h"`` at the top of your code. Which will simply copy the entire header to that point.
You can include a header in 2 ways: ``#include "file.h"`` or ``#include <file.h>``. Using quotes will search the header in your current directory and using angled brackets will search the header in the include directory.

**Further Reading:**

- [header files](https://www.learncpp.com/cpp-tutorial/header-files/)
- [build mechanics](https://hackingcpp.com/cpp/lang/separate_compilation.html)

## Standard Library

There are a set of build in header libraries you can use for common operations called the ``Standard Libary`` or ``std`` for short. You can look at the standard library as the conceptual equivelant to the ``System`` namespace in the C# language, it provides libraries for common operations like input and output and file operations as well as containers like strings, lists, dictionaries and others.

This table describes the most commonly used headers in the standard library:
![standardlibrary](/images/table-headers.png)

## Initialization

**Stack / Heap:**

C++ allows you to initialize objects on the stack or the heap. But In C# you don't get to choose, classes will be on the heap because they are reference types and structs on the stack because they are value types, and in C# you must always use the ``new`` keyword.

**Copy / Direct:**

Another thing to keep in mind about C++ initialization in particular is that there is a distinction between copy and direct initialization, direct initialization is slightly faster because there is no need for an unnecessary copy operation to be done.

**C++ stack initialization:**
```cpp
// direct
Type test; // uninitialized
Type test{}; // initializes with default value
Type test(x);
Type test{x};
Type test{x, y, z}; // works on aggregates (like arrays or structs)
Type test{ .foo = x, .bar = y }; // works on structs (C++20 only)

// copy
Type test = Type(x);
Type test = Type{x};
Type test = {x, y, z}; // works on aggregates (like arrays or structs)
Type test = { .foo = x, .bar = y }; // works on structs (C++20 only)
```

**C++ heap initialization:**
```cpp
Type* test = new Type(x);
Type* test = new Type{x};
Type& test = *new Type(x); // get as reference instead of pointer
```

**C# initialization:**
```csharp
Type test; // uninitialized
Type test = new Type(x); // standard way of initializing
Type test = [x, y, z]; // works on collections like arrays and lists
```

**Things to remember about initialization:**

- C++ gives more control over stack vs heap
- C++ supports multiple syntaxes: parentheses and curly braces
- C++ gives more control about when copy operations are used
- C# classes are reference types (heap), structs are value types (stack)
- C# always requires the new keyword for both structs and classes

## Public / Private

In C# you can put public or private before any member of a class like so:

```csharp
// csharp
class Person
{
    public float a;
    private float b;
    public float c;
}
```

In C++ you put all public member under ``public:`` and all private members under ``private:`` like so:

```cpp
// cpp
class Person
{
    public:
        float a;
        float c;
    private:
        float b;
}
```

## Structs

In C/C++ you define structs syntactically slightly different than in C#

In C# you define a scruct like this:

```csharp
struct Point
{
    int x;
    int y;
}
```

In C++ you define a struct like this:

```cpp
struct Point
{
    int x;
    int y;
}; // <- semicolon is required
```

In plain C you define a struct like this:

```cpp
typedef struct Point // <- typedef is required
{
    int x;
    int y;
} Point; // <- typedef is required
```

If you plan on writing plain C instead of C++ then there are a couple more ways to declare a struct. 
The rules for which do not apply when writing C++, for that usecase only ``struct Point { ... };`` is really commonly used, 
since in C++ it automatically creates a type without requiring ``typedef`` to be used.
In plain C you can write a struct declaration in one of the following ways:
<table>
  <thead>
    <tr><th>Form</th><th>Has Tag</th><th>Has Typedef</th><th>Info</th></tr>
  </thead>
  <tbody>
    <tr><td><code>typedef struct Point { ... } Point</code></td><td>Yes</td><td>Yes</td><td>Modern way</td></tr>
    <tr><td><code>struct Point { ... };</code></td><td>Yes</td><td>No</td><td>Classic way</td></tr>
    <tr><td><code>typedef struct { ... } Point;</code></td><td>No</td><td>Yes</td><td>Uncommon</td></tr>
    <tr><td><code>struct { ... } Point;</code></td><td>No</td><td>No</td><td>Uncommon</td></tr>
  </tbody>
</table>

Examples showing each form of declaring a struct in plain C syntax:
```cpp
// modern way
typedef struct Point {
    int x;
    int y;
} Point;

// classic way (no typedef)
struct Point {
    int x;
    int y;
};

// uncommon (no tag)
typedef struct {
    int x;
    int y;
} Point;

// uncommon (no tag or typedef)
struct {
    int x;
    int y;
} Point;
```

## Lambda Expressions

A lambda expression like in C# is a lambda calculus function. In simple terms it can be described as an inline function.

The basic structure of a lambda:
- csharp: ``(input)=>{body};``
- cpp: ``[catch](input){body};``

This is how lambdas in C# look:
```csharp
// csharp

// single line lambda
var add = (int a, int b) => a + b;

// multi line lambda
var add_and_mult = (int a, int b) =>
{
    var x = a + b;
    var y = x * 2;
    return y;
};
```

This is how lambdas in C++ look:
```cpp
// cpp

// single line lambda
auto add = [](int a, int b) { return a + b; };

// multi line lambda
auto add_and_mult = [](int a, int b)
{
    auto x = a + b;
    auto y = x * 2;
    return y;
};

// lambda with explicit return type
auto add = [](int a, int b) -> int
{
    return a + b;
};
```

When using C++ lambda expressions also have the ability to capture variables from their surrounding scope.
Capturing determines how variables from the surrounding scope are made available to inside the lambda.
You determine how do capture variabled based on what you place inside the ``[ ]`` capture brackets.
```cpp
// cpp

int first = 10;
int second = 20;

// capture all surrounding variabled by value
auto lambda = [=](int a)
{
    a = first + second;
    first = a; // doesnt change the original
};

// capture all surrounding variabled by reference
auto lambda = [&](int a)
{
    a = first + second;
    first = a; // changes the original
};

// captures 'int first' by value and 'int second' by reference
auto lambda = [first, &second](int a)
{
    a = first + second;
    first = a; // doesnt change the original
};

// captures 'int first' by reference and 'int second' by value
auto lambda = [&first, second](int a)
{
    a = first + second;
    first = a; // changes the original
};
```

## Trailing Return Types

In C++ you can use something called trailing return types, which is just a different syntax for declaring an explicit return type of a function or a lambda.

Instead of placing the return type before the function name, it is placed after the parameter list using the ``->`` syntax.

The syntax for declaring an explicit return type is ``auto foo() -> type { }`` instead of the more usual ``type foo() { }`` which you are used to as a C# developer.

These are all the ways you can declare an explicit return type in C++ syntax:
```cpp
// cpp

// normal
int Add(int a, int b)
{
    return a + b;
}

// trailing
auto Add(int a, int b) -> int // notice the "-> int"
{
    return a + b;
}

// trailing (lambda)
auto add = [](int a, int b) -> int // notice the "-> int"
{
    return a + b;
};
```

## Operator Overloading

In C# operator overloading works like this:
```csharp
// csharp
public static Type operator +(Type a, Type b)
{
    return new Type(a.value + b.value);
}
```

In C# you always need to make an operator overload ``public`` and ``static``, in C++ you dont.
Also as you can see for C# we use the ``new`` keyword because that makes the object exist on the heap and it returns a type by reference, thats default for C#.

In C++ operator overloading works like this:
```cpp
// cpp
Type operator +(Type& b)
{
    return Type(this->value + b.value);
}
```

Also as you can see for C++ we dont use the ``new`` keyword because in C++ everything is a value type by default which are on the stack, the ``new`` keyword makes objects on the heap.

## Arrays / Lists

Important differences:
- In C# you write ``int[] name``, while in C++ you write ``int name[]``, it differs where you place the brackets.
- In C# arrays are always on the heap and made with ``new``, while in C++ arrays are on the stack.
- In C# ``int[][]`` is a jagged array while in C++ ``int[][]`` is a multidimensional array.
- In C++ a list is called a vector (yes thats really confusing).

In C# you use arrays like so:

```csharp
// csharp

// simple array
int[] array = new int[8]; // create
int value = array[0]; // index

// multidimensional array
int[,] array = new int[8, 8]; // create
int value = array[0, 0]; // index

// jagged array (array of arrays)
int[][] array = new int[8][]; // create
int value = array[0][0]; // index
```

In C++ you use arrays like so:
```cpp
// cpp

// simple array
int array[8]; // create
int value = array[0] // index

// multidimensional array
int array[8][8]; // create
int value = array[0][0]; // index
```

In C# you use lists like so:
```csharp
// csharp

// create list
List<int> list = new List<int>();

// get length of list
int length = list.Count;

// add to list
list.Add(4);

// remove third element from list:
list.RemoveAt(2);

// index list
int value = list[0];

// clear list
list.Clear();
```

In C++ you use lists (called vectors in c++) like so:
```cpp
// cpp

// create vector
vector<int> vector;

// get length of vector
int length = vector.size();

// add to vector
vector.push_back(4);

// remove third element from vector
vector.erase(vector.begin() + 2);

// index vector
int value = vector[0];

// clear vector
vector.clear();
```

## Generics / Templates

In C# you create generics like so:
```csharp
// csharp

// generic function
void Print<T>(T value)
{
    Console.WriteLine("value: " + value);
}

// generic function with multiple parameters
void Print<T1, T2>(T1 a, T2 b)
{
    Console.WriteLine("a: " + a + " b: " + b);
}

// generic class
class Box<T>
{
    T value;
}
```

In C++ you create generics like so:
```cpp
// cpp

// generic function
template <typename T>
void Print(T value)
{
    cout << "value: " << value;
}

// generic function with multiple parameters
template <typename T1, typename T2>
void Print(T1 a, T2 b)
{
    cout << "a: " << a << " b: " << b;
}

// generic class
template <typename T>
class Box
{
    T value;
};
```

## Strings

In C# you use strings like so:
```csharp
// csharp

// creating a string
string hello = "hello";

// combining strings
string combined = hello + "world";

// comparing strings
bool test = ("apple" == "orange");

// number to string
int age = 22;
string message = age.ToString() + " years old";

// get length of string
string test = "test";
int length = test.Length;

// indexing a string
string test = "test";
char index = test[0];
```

In C++ you use strings like so:
```cpp
// cpp

// creating a string
string hello = "hello"; // c++ style
char hello[] = "hello"; // plain c style
char* hello = "hello"; // plain c style

// combining strings
string combined = hello + "world";

// comparing strings
bool test = ("apple" == "orange");

// number to string
int age = 22;
string message = to_string(age) + " years old";

// get length of string
string test = "test";
int length = test.length();

// indexing a string
string test = "test";
char index = test[0];
```

## Immutables And Statics

In both languages there is commonly some confusion about the differences between immutable variables,
Because the keywords ``const`` and ``static`` have a different meaning in both languages.
And both languages add extra keywords ``readonly`` (**C#**) and ``constexpr`` (**C++**), which adds to the confusion.

In C# you use immutables and statics like so:
```csharp
// csharp

// compile time immutable (also static by default)
const int test = 1;

// runtime immutable
readonly int test = 1;

// shared mutable (shared across all instances)
static int test = 1;
```

In C++ you use immutables and statics like so:
```cpp
// cpp

// compile time immutable
constexpr int test = 1;

// runtime immutable
const int test = 1;

// shared mutable (shared across file scope)
static int test = 1;
```

Conclusion:

- C# ``const`` ≈ C++ ``constexpr`` (compile-time immutable)
- C# ``readonly`` ≈ C++ ``const`` (runtime immutable)
- C# ``static`` ≈ C++ ``static`` (shared across a scope)

## Header Guards

Imagine you have 4 different C++ files that all use ``library.h`` and so all 4 different files do ``#include "library.h"``, now what happens is that when compiling the code 
the library gets included 4 times, and because of this it will give an error, because the declared functions in the header file are basically introduced 4 times into your code. 
To make sure that no duplicate function declarations get introduced due to multiple files including a header file we use something called header guards. 
A header guard makes sure that a header only gets included once in the compilation with the help of the preprocessor even if multiple files need to include the header. 

Consider you have ``first.cpp`` like this:
```cpp
// cpp

#include "library.h"

void func()
{
    library::SomeFunction();
}
```

And you have ``second.cpp`` like this:
```cpp
// cpp

#include "library.h"

void func()
{
    library::SomeFunction();
}
```

Now if we compile this with ``g++ first.cpp second.cpp -o program.exe``, the code inside ``library.h`` will exist double because we included the header twice in our code. 
We can fix this by putting a header guard inside the ``library.h`` file like so:

```cpp
// cpp

#ifndef LIBRARY_NAME
#define LIBRARY_NAME

// the library header code in here

#endif
```

Now if we compile the code, when the preprocessor processes the code, 
it will see if the header is already included somewhere once and will ignore further inclusions, 
Allowing us to use the header from multiple C++ files without duplicate declaration errors. 
Because ``#ifndef`` checks if ``LIBRARY_NAME`` was defined somewhere already indicating the file was already included, 
and if not then it uses ``#define`` to make sure next time it is defined. 
Making it so the contents of the header only get included once during the compilation.

## Preprocessor

coming soon

## Function Pointers

In C# if you want a reference to a function to for example pass as to another function as parameter you will probably have used an ``delegate`` or its ``Action`` abstraction. 
In C and C++ you reference functions by having a direct pointer, pointing to the function. The function can then be called using that pointer. 
There is a specific syntax for function pointers, this ``output_type (*ptr_name)(input_params);`` being the basis of declaring a function pointer.

Simple example of a function pointer:
```c
// declare a function pointer, pointing to Foo
void (*foo_ptr)(void) = &Foo;

// dereference and call the function pointer
(*foo_ptr)();

// call with implicit dereference (works too)
foo_ptr();
```

Here is another example of declaring some function pointers:
```c
// creating a pointer that points to a func returning nothing
void (*foo_ptr)() = &Foo;

// creating a pointer that points to nothing yet
void (*bar_ptr)() = NULL;

// creating a pointer that points to a func that takes and returns nothing
void (*baz_ptr)(void) = &Baz;

// creating a pointer that points to a rounding function
int (*round_ptr)(float x) = &Round;

// creating a pointer that points to a function that adds floats
float (*add_ptr)(float a, float b) = &Add;
```

Using ``typedef`` on function pointers:
```c
// this declares a single pointer variable named Foo
void (*Foo)(void);

// this creates a type alias called Foo
typedef void (*Foo)(void);

// same as: "void (*func_ptr)(void)";
Foo func_ptr;

// you can use the alias to pass the ptr
SomeFunction(Foo func_ptr);
```

Casting a function pointer:
```c
// creating the FuncPtr type
typedef void (*FuncPtr)(void);

// getting a function pointer to a dll
void* fn = dlsym(...);

// casting FuncPtr before calling
((FuncPtr)fn)();

// creating the AddFuncPtr type
typedef float (*AddFuncPtr)(float a, float b);

// getting a function pointer to a dll
void* fn = dlsym(...);

// casting AddFuncPtr before calling
float added = ((AddFuncPtr)fn)(1.0f, 2.0f);
```

Other noteworthy stuff:
```c
// these two ways work the same (the '&' is optional)
void (*foo_ptr)() = &Foo;
void (*foo_ptr)() = Foo;

// these are different
void (*foo_ptr)(); // function taking an any number of parameters
void (*foo_ptr)(void); // function taking no parameters

// these two ways work the same (parameter names are optional)
float (*foo_ptr)(float a, float b);
float (*foo_ptr)(float, float);
```

## Member Definition Outside The Class

Sometimes in C++ you will see something like this:
```cpp
void ClassName::MethodName()
{
    // some code
}
```

Why is the ``::`` syntax used? And why is ``ClassName`` there? It is the syntax for defining (implementing) a class's method outside of the class itself, 
often even in another file entirely, with the class often only being declared in a header file:

Inside the ``ClassName.h`` file:
```cpp
// cpp

class ClassName
{
    public:
        void MethodName(); // declaration
};
```

Inside the ``ClassName.cpp`` file:
```cpp
// cpp

#include "ClassName.h"

void ClassName::MethodName() // definition (implementation)
{
    // some code here
}
```

## Plain C Exclusive Features

people often say that all C code is valid C++ code, but that is hardly true, there are many things C can do that C++ can not do.

**Designated Initializers:**

Are used to initialize specific fields of a struct without having to init the struct members in a specific order.
This feature was added in C++20, but most codebases are still using a lower version, making this mostly a plain C only feature.

In C# we would initialize a struct with specific field values like so:
```csharp
// csharp

Person person = new Person()
{
    age = 30,
    name = "Alice"
};
```

In plain C the same can be done using the ``.variable`` syntax:
```c
// plain c

Person person =
{
    .age = 30,
    .name = "Alice" // <- note how it has a dot before
};
```

In C++ (before C++20) you have to use the exact order in which the variables 
are declared:
```cpp
// cpp

Person person =
{
    30, // <- the int has to be first
    "Alice" // <- the string has to be second
};
```

**Compound Literals:**

Are a C only feature that makes a temporary variable using the ``(type){value}`` syntax:
```c
// compound literal for a basic type
int x = (int){42};

// compound literal for a typedef struct
Vec3 v = (Vec3){1.0f, 2.0f, 3.0f};

// compound literal for an array
int* arr = (int[]){1, 2, 3, 4, 5};
```