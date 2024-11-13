# Simple Memory Allocator

## Part 1: Simple BRK heap

```
pointer allocate(%rdi: size);
void deallocate(%rdi: pointer);
```

### Allocation Scenarios

- [x] Expand the heap on inital allocation.
- When there are no free blocks which will fit the allocation:
  - [x] Expand the heap to create a new block.
  - [ ] Expand the heap from the start of a trailing free block (Needs footer).
  - [ ] Expand at least N bytes at a time, to give some wiggle room.
- When there are free blocks which will fit the allocation:
  - [x] Allocate the existing block.
  - [x] Split the existing block.

### Deallocation Scenarios

- [x] Mark a block as free.
- [x] Combine free blocks with subsequent free blocks.
- [ ] Combine free blocks with preceeding free blocks (Needs footer).

### Supporting Changes

- [ ] Use SBRK rather than BRK to avoid duplicate initial syscalls.
- [ ] Store a footer to support block merging.

## References

- https://www.youtube.com/watch?v=UTii4dyhR5c
- https://git.busybox.net/uClibc/tree/libc/stdlib/malloc/malloc.h
- https://git.busybox.net/uClibc/tree/libc/stdlib/malloc/malloc.c
- https://my.eng.utah.edu/~cs4400/malloc.pdf
- https://en.wikipedia.org/wiki/C_dynamic_memory_allocation
