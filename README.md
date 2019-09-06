# Brother WP SDK
[![Build Status](https://cloud.drone.io/api/badges/centerorbit/brother-wp-sdk/status.svg)](https://cloud.drone.io/centerorbit/brother-wp-sdk)

Unofficial SDK for the Brother Word Processors (circa 1994)

This SDK is extremely rudimentary, based solely from reverse-engineering efforts, trial and error. While the end-goal of this project is to produce a library that can be used to build meaningful applications for the Brother Word Processors, it's a very tall order, with limited resources and likely less public interest. 

# Building

Applications for the Brother start with an `.APL` file, for example, the hello-world sample will produce a `HELLO.APL` file. This can be copied to the root of a floppy disk, and run from the "Disk Application" menu on your Brother Word Processor.


*What works?*


Currently, the `hello-world` application is all that works from this SDK. It's capable of:
* Creating a valid APL (Brother application) file.
* Load from disk.
* Clear the screen.
* Display the text "Hello World!" in the message bar at the bottom.
* Successfully exit, and return to the Brother main menu.

There are a few other helpful methods in the `library`, but nothing much substantial beyond what's already described.

## Using Docker

### Windows
1. Open PowerShell and `cd` to the cloned sdk directory.
1. `docker build -t brother-wp-sdk:latest .`
1. `docker run -v "$((Get-Item -Path ".\").FullName+'\builds'):/code/builds" brother-wp-sdk:latest`
1. Builds will now show up in the sdk's 'builds' folder!

### Linux
1. Open bash and `cd` to the cloned sdk directory
1. `docker build -t brother-wp-sdk:latest .`
1. `docker run -v $(pwd)/builds:/code/builds brother-wp-sdk:latest`
1. Builds will now show up in the sdk's 'builds' folder!

## Locally

### Linux
Has been tested with Ubuntu and Debian, probably works with many other distros.

1. Install `z80asm` assembler: `sudo apt-get update && sudo apt-get install -y z80asm`
1. `cd` to the cloned sdk directory
1. Build the "Hello World" sample: `z80asm -i ./samples/hello-world/hello.asm -o ./builds/HELLO.APL`
1. A `HELLO.APL` app should now exist in the `./builds/ directory.

### Windows
You will need to have Windows Subsystem for Linux (WSL) installed, along with either the Debian or the Ubuntu distro.

Compile and move an app to floppy, using WSL and PowerShell:


`z80asm -i ./samples/hello-world/hello.asm -o ./samples/hello-world/HELLO.APL; powershell.exe 'copy-item -path .\samples\hello-world\HELLO.APL 
-destination A:\HELLO.APL'`

# Helping / Contributing
There are many many ways to help out with these efforts.
1. If you have software disks that are not yet documented, please consider providing a PR to the [brother-wp-software](https://github.com/centerorbit/brother-wp-software) repo. The more software we have, the more we can decompile to understand how these machines work.
1. Studing and identifying what system calls do, and how to use them.
1. Building other software examples or helper libraries.
1. Adding or updateing information about your Word Processor.

## Getting Started and Learning
* If you have APL files, (or if you've downloaded them from the [brother-wp-software](https://github.com/centerorbit/brother-wp-software) repo), one of the most useful decompilers that I've found is the [dz80](http://www.inkland.org.uk/dz80/).
* If you're new to assembly I've found [ChibiAkumas' Z80 Intro Video Series](https://youtu.be/LpQCEwk2U9w) immensely helpful.
* If you're looking to play around with an emulator/debugger/assembler to get your hands a little dirty, ChibiAkumas uses [WinAPE](http://www.winape.net/), which I agree is very helpful in experimenting around with blocks of assembly code.


# Model Differences

## WP-2450 DS and WP-2410 DS
* APLs ORG seems to be at &5000 for the 2450, because all `CALL`s in the decompiled APLs are 50??h, with the `?` pointing to a line in the program that's the start of a function.
  * Most applications have additional data that is loaded via the initial APL bootstrapping applicaiton, the application binary then jumps to &9000.

* For the 8500, the ORG is &8000.
  * Makes some sense, the 'newer' the machine, the bigger the firmware, need to push that offset out a bit.
  * The 8500 also does away with the bootstrapping APLs, and the applications seem to just start with the main program.


# What the `rst`?
It looks like all system calls are made with `rst`.

## rst 30h
* looks like params are in `a` and `b`
  * a = 05
  * b = 03
* for one call b = 0 (a=5)

## rst 28h
* works with `a` accumulator alot
* a = 06 or 01

## Frequency of `rst` in Apps
Can use the following to generate counts:

`cat turn\ about/TURN-ABT.asm | grep rst | awk '{print $3 "
" $4}'|sort|uniq -c | sort -r | awk '{print $2 "\t" $3 "\t" "\tx"$1}'`

### TUTOR
    rst     28h x7
    rst     30h x3
    rst     10h x1

### ADDRESS
    rst     28h x13
    rst     30h x7
    rst     10h x5
    rst     38h x3
    rst     08h x1

### SPREAD
    rst     28h x26
    rst     10h x17
    rst     30h x16
    rst     20h x10
    rst     08h x2

### TETRIS
    rst     38h     x192 // Probably interrupt (at least it is on other popular firmwares)
    rst     28h     x10
    rst     10h     x10
    rst     20h     x8
    rst     18h     x5
    rst     30h     x4
    rst     08h     x3
    rst     00h     x1

### TURN-ABT
    rst     38h     x190 // Probably interrupt (at least it is on other popular firmwares)
    rst     10h     x26
    rst     30h     x11
    rst     08h     x11
    rst     28h     x7
    rst     20h     x5
    rst     00h     x4
    rst     18h     x3


## Suspicious
* While SPREAD doesn't `rst 38h`, it does `ld      de,0038h`
* There's also a `ld      hl,0010h`

