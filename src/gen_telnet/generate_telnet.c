// Copyright Allen Cruiz

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    char imei[16];
    char password[9];
    int accumulator = 0;

    printf("Enter IMEI: ");
    scanf_s("%15s", imei);

    // process 8 digits starting from index 7
    for (int i = 0; i < 8; i++) {
        int digit = imei[i + 7] - '0';
        accumulator = i + accumulator + digit;
        password[i] = (accumulator % 10) + '0';
    }

    password[8] = '\0';

    printf("Telnet Password: %s\n", password);

    return 0;
}
