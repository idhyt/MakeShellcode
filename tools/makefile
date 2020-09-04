# export PATH=$PATH:/path/to/ndk/toolchains/llvm/prebuilt/linux-x86_64/bin
# make build T=linux64 or make build T=arm64
# 
SFLAGS      = -fno-stack-protector -z execstack
TARCH       = $(T)
OUTF        = ../run
CC          = gcc

$(info [*] build elf for run shellcode)

 # set CC fro arm
ifeq ($(TARCH), arm)
    CC     = armv7a-linux-androideabi29-clang
else ifeq ($(TARCH), arm64)
    CC     = aarch64-linux-android29-clang
else ifeq ($(TARCH), linux)
    SFLAGS     += -m32
else ifeq ($(TARCH), linux64)
    SFLAGS     += -m64
else
    $(error set arch error, $(TARCH) not support!)
endif

$(info [+] gcc: $(CC), arch: $(TARCH), flags: $(SFLAGS))

.PHONY: build

build:
	$(CC) $(SFLAGS) ./run.c -o $(OUTF)
