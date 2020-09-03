# idhyt
# make build T=linux.reverse64IPv4

INCLUDEDIR  = ./include/
INCLUDE     = -I $(INCLUDEDIR)
TFILE       = $(T)
TARCH       = $(basename $(TFILE))
OUTF        = ../shellcode

# build for shellcode

ifeq (0, $(words $(TFILE)))
    $(error target not found! usage like: make build T=linux.reverse64IPv4)
endif

BF = ./$(subst .,/,$(TFILE)).s
$(info [*] build shellcode for $(BF))

BA =
# set linux arch SFLAGS
ifeq ($(TARCH), linux)
    ifneq (,$(findstring 64,$(TFILE)))
        SFLAGS     = -D SYSCALL
        BA         = linux64
    else
        SFLAGS     = -D INT80
        BA         = linux
    endif
endif

# set arm arch SFLAGS
ifeq ($(TARCH), arm)
    ifneq (,$(findstring 64,$(TFILE)))
        SFLAGS     = -D arm64
        BA         = arm64
    else
        SFLAGS     = -D arm32
        BA         = arm32
    endif
endif

$(info [+] arch: $(BA), flags: $(SFLAGS))

# $(error exit)

.PHONY: build

build:
	nasm $(BF) $(INCLUDE) $(SFLAGS) -o $(OUTF)
