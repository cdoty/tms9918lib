tms9918lib is a game development library using Inufuto's [CATE](https://github.com/inufuto/Cate) and [asm8](https://github.com/inufuto/asm8) compilers.
The library can compile the same game code, in a C like language, across every supported platform.

The library currently supports low level graphics, joystick, and sprite access across:  
  16 targets:  
    Colecovision, VTech Creativision, Tatung Einstein, MSX, Memotech MTX, Nichibutsu My Vision, Nabu, Hanimex Pencil 2, Casio PV-2000, Tomy Tutor/Pyuta, TI-99/4a, Sega SG-1000, Sord M5, Samsung SPC-1000, Spectravision 318/328, and HBC-56/Pico-56.  
    
  and 3 processors:  
    Z80, 6502, and TMS9900  

Expanded RAM can also be detected and used. In some cases, it detects added RAM expansion, in others it detects memory difference between different versions of the computer.

It needs the [base project](https://github.com/cdoty/Crab), [system specific startup](https://github.com/cdoty/SG1000) and interrupt code and system definitions, and the [tools](https://github.com/cdoty/Tools). The [actual game code](https://github.com/cdoty/Game) and this library are submodules of the system specific code.
