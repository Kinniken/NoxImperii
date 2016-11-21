# Nox Imperii Overview

The Empire of Terra, dominant power of this sector of the Galaxy, is in decline after centuries of expansion. As weak emperors and widespread corruption weaken the Terran realm, beyond the Imperial borders barbarian forces gather strength. Meanwhile, opposite Betelgeuse, the Empire's great rival prepares to challenge Imperial supremacy. Kicked out of Navy school but proud owner of a derelict shuttle, will you help the Empire recover, join force with its rival, or simply focus on surviving and prospering in a Galaxy that has seen better days?

Nox Imperii follows the footstep of classics such as Elite, Freelancer or most closely Escape Velocity to put you in command of a spaceship with a Galaxy to explore. Trade, fight, perform missions, survey the wilderness, turn to piracy, it's all up to you - a huge, mostly random Galaxy awaits!

## Roots in Naev

   Nox Imperii is a fork of [Naev](https://github.com/naev/naev). Most of the code and all the technical
   setup comes from it. For more information on Naev, please visit
   http://wiki.naev.org/wiki/Main_Page
   or view the man page (If you're on a Unix-like system).

   An exhaustive list of command line arguments is detailed in the man page.

   Hardware requirements can also be found on the website.

## DEPENDENCIES

Naev's dependencies are intended to be relatively common. In addition to
an OpenGL-capable graphics card and driver, Naev requires the following:

* SDL
* libxml2
* freetype2
* libpng
* OpenAL
* libvorbis (>= 1.2.1 necessary for Replaygain)
* binutils
* libzip

Note that several distributions ship outdated versions of libvorbis, and
thus libvorbisfile is statically linked into the release binary.

Compiling your own binary on many distributions will result in Replaygain
being disabled.

See http://wiki.naev.org/wiki/Compiling_Nix for package lists for several
distributions.

Mac Dependencies are different, see [extras/macosx/COMPILE](extras/maxosx/COMPILE) for details.

## COMPILING

Run:

```
   ./autogen.sh && ./configure
   make
```

If you need special settings you should pass flags to configure, using -h
will tell you what it supports.

On Mac OS X, see [extras/macosx/COMPILE](extras/maxosx/COMPILE) for details. Uses Xcode, not gcc.


## INSTALLATION

Naev currently supports make install which will install everything that
is needed.

If you wish to create a .desktop for your desktop environment, logos
from 16x16 to 256x256 can be found in [extras/logos](extras/logos)

## CRASHES & PROBLEMS

Please take a look at the FAQ (linked below) before submitting a new
bug report, as it covers a number of common gameplay questions and
common issues.

If Naev is crashing during gameplay, please file a bug report after
reading http://wiki.naev.org/wiki/Bugs

## KEYBINDINGS

As of 0.5.0, it's possible to set keybindings in-game which is generally
more convenient than editing the configuration file.

A full list of keys can be found at http://wiki.naev.org/wiki/Keybinds

### Introduction / About

Naev uses a dynamic keybinding system that allows you to set
the keybindings to joystick, keyboard or a mixture of both.

This can changed via conf.lua, or with the in-game editor.

### Joystick
If you have a joystick you'll have to tell Naev which joystick
to use.  You can either use the -j or -J parameter from the
command-line or put it in the conf.lua file.
Examples:
```
naev -j 0
naev -J "Precision"
joystick = "Precision" # in conf.lua
```

### Syntax
KEY_IDENTIFIER = { type = KEY_TYPE, key = KEY_NUMBER,
  [reverse = KEY_REVERSE, mod = MOD_IDENTIFIER] }
KEY_IDENTIFIER is the identifier given below
KEY_TYPE can be one of keyboard, jaxis or jbutton
KEY_NUMBER is the number of the key (found with xev usually, just
  convert the keysym from hex to base 10)
KEY_REVERSE is whether it is reversed or not, which is only useful
  in the case of jaxis
MOD_IDENTIFIER is the sodifier to take into account, can be one of:
  lctrl, rctrl, lshift, rshift, lmeta, rmeta, ralt, lalt
  It isn't used with joystick bindings.
#### Example
accel = { type = "jbutton", key = 0 }
