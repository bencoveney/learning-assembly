// Does a short test showing the usage of the garbage collector code in C.

#include <stdio.h>

void *gc_allocate(int);
void gc_scan();
void gc_init();

volatile void **foo;
volatile void **goo;

int main() {
  gc_init();

  foo = gc_allocate(500);
  fprintf(stdout, "Allocation 1: %x\n", foo);

  goo = gc_allocate(200);
  // Hold a reference to goo so it won't go away
  foo[0] = goo;
  fprintf(stdout, "Allocation 2: %x\n", goo);
  gc_scan();

  goo = gc_allocate(300);
  fprintf(stdout, "Allocation 3: %x\n", goo);
  gc_scan();

  goo = gc_allocate(200);
  fprintf(stdout, "Allocation 4: %x\n", goo);
  gc_scan(); // Allocation 3 cleared up - no longer referenced on the stack

  // This will be put in the same spot as allocation 3
  goo = gc_allocate(200);
  fprintf(stdout, "Allocation 5: %x - Should match 3\n", goo);
  gc_scan(); // Allocation 4 cleared up - no longer referenced on the stack

  foo = gc_allocate(500);
  fprintf(stdout, "Allocation 6: %x\n", foo);
  gc_scan(); // Allocation 1 & 2 cleared up - no longer referenced on the stack

  // This will be put in the same spot as allocation 1
  goo = gc_allocate(10);
  fprintf(stdout, "Allocation 7: %x - Should match 1\n", goo);
  gc_scan(); // Allocation 5 cleared up - no longer referenced on the stack

  // This will be put in the same spot as allocation 2
  foo = gc_allocate(10);
  fprintf(stdout, "Allocation 8: %x - Should match 2\n", foo); // Allocation 6 cleared up - no longer referenced on the stack
}
