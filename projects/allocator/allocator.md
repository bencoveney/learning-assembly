# Simple Memory Allocator

## Part 1: Simple BRK heap

```
pointer allocate(%rdi: size);
void deallocate(%rdi: pointer);
```

Implement a memory allocator, with the following features:

- Header contains:
  - Size.
  - Link forward.
- Footer contains:
  - Link backward.
- Allocate entrypoint
  - If not initialized
    - Run heap initialization
  - Check for space on the heap
    - Walk the allocated blocks, checking for available space
  - If no space available
    - Expand the heap
  - Perform the allocation
    - Update the header
    - Add another header at the end of the block
    - return the pointer
- Deallocate entrypoint
  - Mark the header block as free
  - Merge empty blocks left
  - Merge empty blocks right
- General initialization
  - Get the start of the heap
  - That will also be the end
  - Allocate enough memory for the initial allocation, plus a bit extra

## References

- https://www.youtube.com/watch?v=UTii4dyhR5c
- https://git.busybox.net/uClibc/tree/libc/stdlib/malloc/malloc.h
- https://git.busybox.net/uClibc/tree/libc/stdlib/malloc/malloc.c
- https://my.eng.utah.edu/~cs4400/malloc.pdf
- https://en.wikipedia.org/wiki/C_dynamic_memory_allocation
