# idhyt
# make build T=linux.reverse64IPv4
# make run
# ./run ./shellcode

TARGET       = $(T)

.PHONY: shellcode run

all: shellcode run

shellcode:
	@cd asm; make build T=$(TARGET)
	@echo "\033[32m[+] build success.\033[0m" 

run:
	@cd tools; make build T=$(TARGET)
	@echo "\033[32m[+] build success.\033[0m" 

clean:
	rm -rf shellcode run
