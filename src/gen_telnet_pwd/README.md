# Generating Telnet Password

1. Start with the IMEI The IMEI is a 15-digit number unique to each device. For example:

```text
8612345678901234
```

2. Ignore the first 7 digits Only the last 8 digits are used to generate the password. From the example above, we extract:

```text
78901234
```

3. Initialize a running total (accumulator) This is a number that starts at zero and gets updated as we process each digit.

4. Process each of the 8 digits one by one For each digit:

## Example Walkthrough

From the sample IMEI from above the last 8 digits are: `78901234` (processed in order: 7, 8, 9, 0, 1, 2, 3, 4).

| Step | Input digit | Accumulator calculation | Result digit |
| ---: | :---------: | :---------------------- | :----------: |
|    0 |      7      | 0 + 0 + 7 = 7           |      7       |
|    1 |      8      | 1 + 7 + 8 = 16          |      6       |
|    2 |      9      | 2 + 16 + 9 = 27         |      7       |
|    3 |      0      | 3 + 27 + 0 = 30         |      0       |
|    4 |      1      | 4 + 30 + 1 = 35         |      5       |
|    5 |      2      | 5 + 35 + 2 = 42         |      2       |
|    6 |      3      | 6 + 42 + 3 = 51         |      1       |
|    7 |      4      | 7 + 51 + 4 = 62         |      2       |

Final password:

```text
76705212
```

This method ensures that the password is unique to each IMEI, but still reproducible.
