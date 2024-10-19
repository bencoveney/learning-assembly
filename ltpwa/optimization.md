# Optimization

## Memory

### Alignment

You can access data from any memory address (e.g. 17, 18, 19). In practice, RAM has a lower
resolution, and is usually grouped depending on architecture (e.g. quadwords for x86-64). So, it is
fastest to access values that are at addresses which are divisible by 8.

`.balign` can be used to align the data section, e.g. `.balign 8`.

### Cache Lines

Data is often accessed repeatedly, so it will be cached. Nearby data is often accessed
sequentially, so entire lines will be pulled into the cache rather than individual values. Most
x86-64 CPUs will use cache lines of 64 bytes, therefore it can help to align data which is used
together to a 64-byte boundary.

`.balign` can be used for this too, e.g. `.balign 64`.

## Instructions

### Pipelining

Processors will process batches of instructions to keep the processor busy, called "pipelining". If
there are any instructions which can't be pipelined, this can create a `pipeline stall`. An example
would be an instruction which writes to `%rax`, followed by an instruction which reads from `%rax`.

Register reuse can work against pipelining, so it can be advantageous to use different registers
each time where possible.

### Branch Prediction

Code will be cached, but the processor tries to anticipate this and prefetch upcoming instructions.
For this to work, it helps if it can make a good guess about where it will jump to after branches.

Based on the branch predictions, the processor can do speculative execution of instructions. If it
later turns out the prediction was incorrect, the processor can stall while unwinding anything it
executed speculatively.

Indirect jumps can make this process harder.

### Alignment

Aligning jump targets with `.balign` to cache lines (e.g. 64 bytes) can help ensure they are quick
to access.

### Instruction Choice

Different instructions have different physical sizes, which impacts caching. `movaps` and `movapd`
perform identical operations, but the encoding for `movaps` is fewer bytes, and more of them will
fit on a cache line.

`enter` is specifically designed to set up a cache frame, but it is slower than setting one up
manually.

https://agner.org/optimize/
