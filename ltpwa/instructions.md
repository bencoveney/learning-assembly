# Instructions

| Instr     | Operand | Operand     | Behaviour                                        |
| --------- | ------- | ----------- | ------------------------------------------------ |
| `movq`    | source  | destination | Move quadword                                    |
| `syscall` |         |             | Perform a system call. Args passed in registers. |

## Syscalls

| Syscall | Number - `%rax` | `%rdi` |
| ------- | --------------- | ------ |
| exit    | 60              | code   |
