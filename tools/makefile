# make build T=linux64

SFLAGS      = -fno-stack-protector -z execstack
TARCH       = $(T)
OUTF        = ../run

$(info [*] build elf for run shellcode)

 # set linux arch SFLAGS
ifeq ($(TARCH), linux64)
    SFLAGS     += -D linux64
else ifeq ($(TARCH), linux)
    SFLAGS     += -D linux
else ifeq ($(TARCH), arm64)
    SFLAGS     += -D arm64
else ifeq ($(TARCH), arm)
    SFLAGS     += -D arm32
else
    $(error set arch error, $(TARCH) not support!)
endif

$(info [+] arch: $(TARCH), flags: $(SFLAGS))

.PHONY: build

build:
	gcc $(SFLAGS) ./run.c -o $(OUTF)
