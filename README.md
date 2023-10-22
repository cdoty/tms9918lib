tms9918lib is a game development library using Inufuto's [CATE](https://github.com/inufuto/Cate) and [asm8](https://github.com/inufuto/asm8) compilers.
The library can compile the same game code, in a C like language, across every supported platform.

The library currently supports low level graphics, joystick, and sprite access across:
  18 targets:
    Colecovision, VTech Creativision, Tatung Einstein, MSX, Memotech MTX, Nichibutsu My Vision, Nabu, Hanimex Pencil 2, Casio PV-2000, Tomy Tutor/Pyuta, Sega SG-1000, Sord M5, Samsung SPC-1000, and Spectravision 318/328
    
  and 3 processors:
    Z80, 6502, and TMS9900

Expanded RAM can also be detected and used. In some cases, it detects added RAM expansion, in others it detects memory difference between different versions of the computer.

There are two other pieces required to use this library, which will be put up later. It needs the actual game code, and it needs system specific startup and interrupt code, and system definitions.
