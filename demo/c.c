#include <stdio.h>

#define SOMETHING 0x00010000

#if DEBUG
    int x = 3;
#else
    int x = 4;
#endif

const int XX = 0;
char c = '0';

typedef struct x {
    int field;
    char *ptr;
} X;

/// \brief Something
int main(int argc, char **argv) {

    int y = x-x;

    if (argc < 1) {
        printf("Expected at least one argument!\n");
        return 1;    
    }

    return 0;
}
