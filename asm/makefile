# idhyt
# make build T=linux.reverse64IPv4

INCLUDEDIR  = ./include/
INCLUDE     = -I $(INCLUDEDIR)
TFILE       = $(T)
TARCH       = $(basename $(TFILE))
OUTF        = ../shellcode
CC          =
SFLAGS      =
BCMD        =

# build for shellcode

ifeq (0, $(words $(TFILE)))
    $(error target not found! usage like: make build T=linux.reverse64IPv4)
endif

BF = ./$(subst .,/,$(TFILE)).asm
$(info [*] build shellcode for $(BF))

BA =
# set linux arch build cmd
ifeq ($(TARCH), linux)
    CC      = nasm
    ifneq (,$(findstring 64,$(TFILE)))
        SFLAGS     = -D SYSCALL
        BA         = linux64
    else
        SFLAGS     = -D INT80
        BA         = linux
    endif
    BCMD    = $(CC) $(BF) $(INCLUDE) $(SFLAGS) -o $(OUTF)

# set android arch build cmd
else ifeq ($(TARCH), android)
    ifneq (,$(findstring 64,$(TFILE)))
        CC         = aarch64-linux-android-as
        LD         = aarch64-linux-android-ld
        OC         = aarch64-linux-android-objcopy
        BA         = arm64
    else
        CC         = arm-linux-androideabi-as
        LD         = arm-linux-androideabi-ld
        OC         = arm-linux-androideabi-objcopy
        BA         = arm32
    endif
    BCMD    = $(CC) $(BF) -o $(OUTF).S; $(LD) $(OUTF).S -o $(OUTF).elf; $(OC) -O binary $(OUTF).elf $(OUTF)
else
    $(error set arch error, $(TARCH) not support!)
endif


$(info [+] CC: $(CC), arch: $(BA), flags: $(SFLAGS))

# $(error exit)

.PHONY: build

build:
	$(BCMD)
