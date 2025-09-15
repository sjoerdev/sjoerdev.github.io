---
title: "A guide to the Linux command line"
date: "2025-09-15"
description: |
    In this guide i will be going over how the Linux command line works.
    I will be discussing what parts it is made of and how they all work together.
    I will also be covering command commands that every person should know.
    And i will cover the basics of shell scripting.

summary: "In this guide i will be comparing only the major differences between C# and C++"
ShowToc: true
TocOpen: true
ShowBreadCrumbs: true
---

## Parts of the command line

The linux command line is not one singular thing, it consists of many parts.
Each having a specific important purpose. Each of these parts is modular and can be swapped out to fit your needs.

**The Terminal:**

The terminal (often called terminal emulator), is a front end interface that allows you to interact with the shell of the system.
At its core its just a window in which you input text which gets passed down to the shell and then displays the output of the shell.
The terminal emulator does not understand commands, it just passes input to the shell and renders output.
Common terminal emulators include: ``Konsole``, ``Kitty``, ``Gnome Terminal``, and ``Ghostty``.

**The Shell:**

The shell is a program that interprets commands and then runs the right programs. 
It is like the bridge between the user and the kernel. its the most basic form of interacting with your system.
The most commonly used shell programs are: ``Bash``, ``Zsh``, ``Powershell``.

**The Binaries:**

The shell itself doesnt execute anything, it just interprets a command and then executes the correct binary programs with the correct arguments.
Each command is just calling one or more of those binary programs.
So the commands like: ``cd``, ``ls``, ``cat``.
Are basically just names of executable binaries.
All major Linux distro's come with a standard set of these commands (binaries).
Most of these binaries are part one of the following projects: ``gnu-coreutils``, ``util-linux``, ``procps-ng``, ``iproute2``, ``iputils``. and then there are a number of binaries that are their own projects.
But you can be sure that all major Linux distros come with the binaries of those 5 projects, so if you learn those you are set.

## Commonly used commands

<table>
    <thead>
        <tr>
            <th>Command</th>
            <th>Project</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr><td>ls</td><td>gnu</td><td>List files and directories</td></tr>
        <tr><td>cd</td><td>bash</td><td>Change the current directory</td></tr>
        <tr><td>pwd</td><td>gnu</td><td>Print current working directory</td></tr>
        <tr><td>cp</td><td>gnu</td><td>Copy files or directories</td></tr>
        <tr><td>mv</td><td>gnu</td><td>Move or rename files/directories</td></tr>
        <tr><td>rm</td><td>gnu</td><td>Remove files or directories</td></tr>
        <tr><td>mkdir</td><td>gnu</td><td>Create directories</td></tr>
        <tr><td>rmdir</td><td>gnu</td><td>Remove empty directories</td></tr>
        <tr><td>touch</td><td>gnu</td><td>Create empty file or update timestamp</td></tr>
        <tr><td>cat</td><td>gnu</td><td>Display or concatenate file contents</td></tr>
        <tr><td>echo</td><td>bash</td><td>Print text to stdout</td></tr>
        <tr><td>chmod</td><td>gnu</td><td>Change file permissions</td></tr>
        <tr><td>chown</td><td>gnu</td><td>Change file owner and group</td></tr>
        <tr><td>find</td><td>gnu</td><td>Search for files in directories</td></tr>
        <tr><td>grep</td><td>gnu</td><td>Search text in files using patterns</td></tr>
        <tr><td>ps</td><td>procps-ng</td><td>Show currently running processes</td></tr>
        <tr><td>kill</td><td>gnu</td><td>Terminate a process by PID</td></tr>
        <tr><td>uname</td><td>gnu</td><td>Show system and kernel information</td></tr>
        <tr><td>uptime</td><td>procps-ng</td><td>Show system uptime and load</td></tr>
        <tr><td>who</td><td>util-linux</td><td>Show who is logged in</td></tr>
        <tr><td>id</td><td>gnu</td><td>Show user and group IDs</td></tr>
        <tr><td>groups</td><td>gnu</td><td>List groups for a user</td></tr>
        <tr><td>tar</td><td>gnu</td><td>Archive or extract files</td></tr>
        <tr><td>gzip</td><td>gnu</td><td>Compress files</td></tr>
        <tr><td>gunzip</td><td>gnu</td><td>Decompress gzip files</td></tr>
        <tr><td>ping</td><td>iputils</td><td>Test network connectivity</td></tr>
        <tr><td>ip</td><td>iproute2</td><td>Show or configure network interfaces</td></tr>
        <tr><td>which</td><td>other</td><td>Locate a command in PATH</td></tr>
        <tr><td>whereis</td><td>util-linux</td><td>Locate binaries, source, and manuals</td></tr>
        <tr><td>type</td><td>bash</td><td>Show command type information</td></tr>
        <tr><td>basename</td><td>gnu</td><td>Strip directory path from filename</td></tr>
        <tr><td>dirname</td><td>gnu</td><td>Strip filename to show directory path</td></tr>
        <tr><td>xargs</td><td>gnu</td><td>Build and execute commands from input</td></tr>
        <tr><td>env</td><td>gnu</td><td>Show or set environment variables</td></tr>
        <tr><td>export</td><td>gnu</td><td>Set environment variables for child processes</td></tr>
        <tr><td>mount</td><td>util-linux</td><td>Mount disks or drive</td></tr>
        <tr><td>unmount</td><td>util-linux</td><td>Unmount disks or drive</td></tr>
        <tr><td>fdisk</td><td>util-linux</td><td>Manages disks or drives</td></tr>
        <tr><td>curl</td><td>other</td><td>Downloads files from the web</td></tr>
        <tr><td>wget</td><td>other</td><td>Downloads files from the web</td></tr>
    </tbody>
</table>

## Basics of bash and scripting

comming soon...

## Posix and compatibility

comming soon...
