---
title: "A guide to the Ninja build system"
date: "2025-09-15"
description: |
    In this guide i will be going over how the basic syntax of the Ninja build system works.

summary: "In this guide i will be covering the ninja build system basics"
ShowToc: true
TocOpen: true
ShowBreadCrumbs: true
---

## Rules

* Define *how* to generate outputs from inputs.

```ninja
rule <rulename>
    command = <shell command>
    description = <optional description>
```

```ninja
rule cc
    command = gcc -c $in -o $out
```

* `$in` → input file(s)
* `$out` → output file

## Build Statements

* Declare **targets** (what you want to create), **dependencies** (what they need), and the **rule** to use.

```ninja
build <output>: <rulename> <input>
```

```ninja
build main.o: cc main.c
build utils.o: cc utils.c
```

## Phony Targets

* Like `clean` in Make.

```ninja
build all: phony main.o utils.o
```

## Variables

```ninja
cflags = -Wall -O2

rule cc
    command = gcc $cflags -c $in -o $out
```

## Example

```ninja
rule cc
    command = gcc -c $in -o $out

rule link
    command = gcc $in -o $out

build main.o: cc main.c
build utils.o: cc utils.c

build app: link main.o utils.o

default app
```