# Brother WP SDK
[![Build Status](https://cloud.drone.io/api/badges/centerorbit/brother-wp-sdk/status.svg)](https://cloud.drone.io/centerorbit/brother-wp-sdk)

Unofficial SDK for the Brother family of Word Processors, circa 1994.

This SDK is extremely rudimentary, based solely from reverse-engineering efforts, trial, error, and luck. While the end-goal of this project is to produce a library that can be used to build meaningful applications for the Brother Word Processors, it's a very tall order, with limited resources and likely very little public interest. 


# Application Basics 

Applications for the Brother start with an `.APL` file, for example, the hello-world sample will produce a `HELLO.APL` file. This can be copied to the root of a floppy disk, and run from the "Disk Application" menu on your Brother Word Processor.
* Models have different APL ORGs (Origin, which is the memory address of the start of the app). This is compensated for by the SDK.
* APL files start with a header of 8 bytes, the headers are specific to what model you're building for, and an APL of one model-header will refuse to run on another.
* We also know that the different models also have different video memory management, but we don't yet know how they are different.


The `targets` folder has different machine headers setup that are used durring compilation to produce the desired binary.

## Model Differences

### WP-2450 DS and WP-2410 DS
The ROM Dumps from both a WP-2450 DS and WP-2410 DS are identical, and the motherboard model numbers have been the same, so as far as we can tell, they can be treated as the same machine.
* APLs ORG seems to be at &5000 for the 2450, because all `CALL`s in the decompiled APLs are 50??h, with the `?` pointing to a line in the program that's the start of a function.
* Most applications have additional data that is loaded via the initial APL bootstrapping applicaiton, the application binary then jumps to &9000.

### PN-8500DSe
This app ORG starts at &8000, and does not include a bootstrap application.


# Using the SDK
This SDK uses the z80asm compiler to produce the binary APLs, version 1.9 or greater is required.


**Important:** Check your version! There is a breaking bug in label defintion that exists in version 1.8 that was fixed in 1.9.


This bug prevents library include logic that's used by this SDK. While v1.9 was fixed roughly 10 years ago, Debian (and thus Ubuntu) still ship version 1.8. Therefore, unless you build z80asm from source, you cannot simply `apt-get install z80asm`. This was the reason why builds via a Docker image was created, and is the perferred method for compiling the SDK.

## Using Docker
The easiest way to get started is to use Docker and the prebuilt image that contains all necessary

### Windows
1. Open PowerShell and `cd` to the cloned sdk directory.
1. `docker run -v "$((Get-Item -Path ".\").FullName):/workspace" registry.gitlab.com/centerorbit/brother-wp-sdk:latest build`
1. The SDK will compile all sample programs for every supported model, and APLs will appear under the `builds` folder.


**Note:** This assumes you've allowed drive access to your Docker setup. (you will be prompted by Docker to allow access if you haven't yet.)
### Linux
1. Open bash and `cd` to the cloned sdk directory.
1. `docker run -v $(pwd):/workspace registry.gitlab.com/centerorbit/brother-wp-sdk:latest build`
1. The SDK will compile all sample programs for every supported model, and APLs will appear under the `builds` folder.

## Locally

### Linux
Has been tested with Ubuntu and Debian, probably works with many other distros.

### Windows
You will need to have Windows Subsystem for Linux (WSL) installed, along with either the Debian or the Ubuntu distro.

Compile and move an app to floppy, using WSL and PowerShell:


`z80asm --includepath="targets/WP-2450 DS" -i ./samples/hello-world/hello.asm -o "./builds/WP-2410 DS/HELLO.APL"; powershell.exe 'copy-item -path ".\builds\WP-2410 DS\HELLO.APL" -destination "A:\HELLO.APL"'`

## Using DepCharge

`depcharge -f -s -k build -x z80asm  -- --includepath='targets/{{../name}}' -i ./{{location}}/{{input}} -o "./builds/{{../name}}/{{output}}"`

# Getting Started and Learning

## New to Assembly?
If you're new to assembly I've found [ChibiAkumas' Z80 Intro Video Series](https://youtu.be/LpQCEwk2U9w) immensely helpful.


If you're looking to play around with an emulator/debugger/assembler to get your hands a little dirty, ChibiAkumas uses [WinAPE](http://www.winape.net/), which is very helpful in experimenting around with blocks of assembly code.

## New to Reverse Engineering?
If you have APL files, (or if you've downloaded them from the [brother-wp-software](https://github.com/centerorbit/brother-wp-software) repo), one of the most useful decompilers that I've found is the [dz80](http://www.inkland.org.uk/dz80/).

If you don't run Windows, the `z80dasm` (disassembler) can be used as well. This is easily installed on most Linux systems by their package manager of choice (Debian-based: `apt install z80dasm`).


Example disassembly command: `z80dasm -t -l -g 0x5000 TUTOR.APL -o TUTOR.asm`

# What What works?
Currently, the `hello-world` application is all that works from this SDK. It's capable of:
* Creating a valid APL (Brother application) file.
* Load from disk.
* Clear the screen.
* Display the text "Hello World!" in the message bar at the bottom.
* Successfully exit, and return to the Brother main menu.

# Helping / Contributing
There are many many ways to help out with these efforts.
1. If you have software disks that are not yet documented, please consider providing a PR to the [brother-wp-software](https://github.com/centerorbit/brother-wp-software) repo. The more software we have, the more we can decompile to understand how these machines work.
1. Studing and identifying what system calls do, and how to use them.
1. Building other software examples or helper libraries.
1. Adding or updateing information about your Word Processor.

