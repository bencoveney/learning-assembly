# Programming from ground up book

https://mirrors.sarata.com/non-gnu/pgubook/ProgrammingGroundUp-1-0-booksize.pdf

## CH2 notes

### Data sizes

| Name          | Size in bits | Size in bytes | Max value (2^bits - 1) |
| ------------- | ------------ | ------------- | ---------------------- |
| bit           | 1            | 0             | 1                      |
| byte          | 8            | 1             | 255                    |
| word (8086)   | 16           | 2             | 65535                  |
| word (IA-32)  | 32           | 4             | 4294967295             |
| word (x86-64) | 64           | 8             | 18446744073709551615   |

Word size _should_ depend on processor architecture howeverthings like windows API and x86 assembly refer to weord as 16 bits for backwards compatibility.

| Name                | Size in bits | Size in bytes | Max value (2^bits - 1) |
| ------------------- | ------------ | ------------- | ---------------------- |
| halfword            | 8            | 1             | 255                    |
| word                | 16           | 2             | 65535                  |
| dword (double-word) | 32           | 4             | 4294967295             |
| qword (quad-word)   | 64           | 8             | 18446744073709551615   |

### Addressing modes

Some notes on most important ones, but there are others.

#### Immediate mode

The instruction contains direct data. E.g. we pass the number `5`.

#### Register addressing mode

An instruction contains a register. E.g. we pass `EAX`.

#### Direct addressing mode

An instruction contains a memory address. E.g. we pass memory location `#1024`

#### Indexed addressing mode

An instruction contains a memory address, and an index register. E.g. we pass memory location `#1024` and index register `EAX`. If the register EAX contains an offset of `8` we would use memory location `1024 + 8` = `#1032`.

In x86 you can also specify a multiplier. This can be used to say "get the Nth byte" or "get the Nth word". E.g. we pass memory location `#1024` and index register `EAX` and multiplier `4`. If the register EAX contains an offset of `8` we would use memory location `1024 + (8 * 7)` = `1024 + 56` = `#1080`.

#### Indirect addressing mode

An instruction contains a register, which contains a memory address. E.g. we pass `EAX`, and `EAX` contains `#1024`.

#### Base pointer addressing mode

An instruction contains a register, which contains a memory address, and an offset. E.g. we pass `EAX` and an offset of `8`, and `EAX` contains `#1024`. We would use memory location `1024 + 8` so `#1032`
