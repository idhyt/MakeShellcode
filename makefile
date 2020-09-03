# idhyt
# make build SC=linux/reverse64IPv4
# make test
# ./test ./shellcode

INCLUDEDIR = ./src/include/
INCLUDE    = -I $(INCLUDEDIR)
# SFLAGS     = -D SYSCALL
ifneq (,$(findstring 64,$(SC)))
    SFLAGS     = -D SYSCALL
else
    SFLAGS     = -D INT80
endif

shellcode = ./src/$(SC).s


.PHONY: shellcode run

all: sc elf

shellcode:
	@echo "\033[33m[+] Build shellcode for $(shellcode) \033[0m" 
	nasm $(shellcode) $(INCLUDE) $(SFLAGS) -o shellcode

elf:
	@echo "\033[33m[+] Build elf to run shellcode \033[0m" 
	gcc -fno-stack-protector -z execstack run.c -o run

clean:
	rm -rf shellcode run