# Simple Memory Allocator

## Part 1: Simple BRK heap

```
pointer allocate(%rdi: size);
void deallocate(%rdi: pointer);
```

### Allocation Scenarios

- When the heap is not initialised
  - [x] Create it.
  - [x] Leave a margin for subsequent allocations.
  - [x] Expand at by at least the pagesize.
- When there are no free blocks which will fit the allocation:
  - [x] Expand the heap to create a new block.
  - [x] Expand the heap from the start of a trailing free block, rather than the end of the heap.
  - [x] Leave a margin for subsequent allocations.
  - [x] Expand at by at least the pagesize.
- When there are free blocks which will fit the allocation:
  - [x] Allocate the existing block.
  - [x] Split the existing block.

### Deallocation Scenarios

- [x] Mark a block as free.
- [x] Combine free blocks with subsequent free blocks.
- [x] Combine free blocks with preceeding free blocks.
- [x] Consider start/end of heap when merging blocks.

### Clean Up

- [ ] `%rcx` use is probably unreliable.
- [ ] Probably some local variable rearrangement is redundant.
- [ ] Align jump targets.
- Bit twiddling opportunities.
  - [ ] `roundUp` can probably be optimised.
  - [x] `writeHeader` can probably be optimised.
- Logic can probably be shared.
  - [x] `writeHeader` and `writeFooter` could probably often be consolidated into `writeBlock`.
  - [x] Between `initialise` and `expandHeap`: calculating new end of heap.
  - [x] Between `initialise` and `expandHeap`: writing allocated block and free remainder block.
  - [x] Between `expandHeap` and `deallocate`: inspecting the previous block.

### Error Scenarios

Could optionally be handled:

- [ ] Deallocating a block which has already been deallocated.
- [ ] Allocating 0 bytes.
- [ ] Deallocating a block which is off either end of the heap.
- [ ] BRK failing to allocate.

### Limitations

- Overhead per memory allocation.
- Risk of fragmentation.
- Real workload performance.
  - When to expand.
  - Best fit vs first fit.
- Portability.
- Heap shrinking.

## References

- https://www.youtube.com/watch?v=UTii4dyhR5c
- https://git.busybox.net/uClibc/tree/libc/stdlib/malloc/malloc.h
- https://git.busybox.net/uClibc/tree/libc/stdlib/malloc/malloc.c
- https://my.eng.utah.edu/~cs4400/malloc.pdf
- https://en.wikipedia.org/wiki/C_dynamic_memory_allocation
- https://www.youtube.com/watch?v=vHWiDx_l4V0
- https://lemire.me/blog/2024/06/27/how-much-memory-does-a-call-to-malloc-allocates/
