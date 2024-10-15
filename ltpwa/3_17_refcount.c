#include<stdio.h>

void *allocate(int);
void deallocate(void *);

void retain(void *);
void release(void *);

int main() {
  char *a = allocate(500);
  retain(a);
  retain(a);
  release(a);
  char *b = allocate(300); // New allocation
  retain(a);
  release(a);
  release(a);
  char *c = allocate(300); // New allocation
  release(a); // Object is deallocated here
  char *d = allocate(300); // Re-uses space from a
  fprintf(stdout, "Allocations: %d, %d, %d, %d\n", a, b, c, d);
}
