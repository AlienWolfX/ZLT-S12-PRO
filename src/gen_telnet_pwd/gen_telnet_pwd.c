// Copyright Allen Cruiz

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    char imei[32] = {0};
    char password[9] = {0};
    int accumulator = 0;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-i") == 0 || strcmp(argv[i], "--imei") == 0) {
            if (i + 1 < argc) {
                strncpy_s(imei, sizeof(imei), argv[i + 1], _TRUNCATE);
                break;
            }
        } else if (strncmp(argv[i], "-i", 2) == 0 && strlen(argv[i]) > 2) {
            /* support -i123456... */
            strncpy_s(imei, sizeof(imei), argv[i] + 2, _TRUNCATE);
            break;
        }
    }

    if (imei[0] == '\0') {
        fprintf(stderr, "Copyright Allen Cruiz\n");
        fprintf(stderr, "Usage: gen_telnet -i IMEI\n");
        fprintf(stderr, "       -i IMEI, --imei IMEI   Specify IMEI to generate telnet password\n");
        return 1;
    }

    size_t len = strlen(imei);
    if (len < 15) {
        fprintf(stderr, "IMEI must be at least 15 digits long (got %zu)\n", len);
        return 3;
    }
    for (size_t j = 0; j < len; j++) {
        if (imei[j] < '0' || imei[j] > '9') {
            fprintf(stderr, "IMEI must contain digits only\n");
            return 4;
        }
    }

    for (int i = 0; i < 8; i++) {
        int digit = imei[i + 7] - '0';
        accumulator = i + accumulator + digit;
        password[i] = (accumulator % 10) + '0';
    }

    password[8] = '\0';

    printf("URL: http://192.168.254.254\n");
    printf("Username: root\n");
    printf("Telnet Password: %s\n", password);

    return 0;
}
