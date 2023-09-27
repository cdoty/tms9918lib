# Set the name of the output ROM.
name		= Boot

# Set the output file extension. Some emulators look for specific extension.
extension	= rom

# Set the ROM and RAM start addresses
cseg		= C800
dseg	 	= 6000

# Set the tools path.
TOOLS_PATH	= ../../../../../Tools

# Set the CATE compiler path. Bin and lib are expected to exist inside the directory.
CATE_PATH	= $(TOOLS_PATH)/Cate
BIN_PATH	= $(CATE_PATH)/bin
LIB_PATH	= $(CATE_PATH)/lib

# CATE/ASM8/Lib compile ID. (ie CATEXX.exe)
compileType	= 80

# Customize the processor type and the TMS-9918 interface type, if needed.
Boot_S		= $(wildcard Boot.s)

objects		= $(Boot_S:.s=.obj)

lists 		= $(Boot_S:.s=.lst)

all: $(name).$(extension)

clean:
	rm -f $(objects)
	rm -f $(lists)
	rm -f $(name).symbols.txt

%.obj: %.s
	$(BIN_PATH)/Asm$(compileType) $<
	
$(name).$(extension): $(objects)
	$(BIN_PATH)/LinkLE $(name).$(extension) $(cseg) $(dseg) $(objects)
	$(TOOLS_PATH)/PadToBlock 1024 $(name).$(extension)
