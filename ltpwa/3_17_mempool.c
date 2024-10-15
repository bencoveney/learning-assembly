#include<stdio.h>

void *allocate(int, int);
void deallocate(void *);
void deallocate_pool(int);

int main() {
  char *a1 = allocate(1, 400);

  fprintf(stdout, "Allocations: %d\n", a1);

  char *a2 = allocate(2, 32);

  fprintf(stdout, "Allocations: %d, %d\n", a1, a2);

  char *a3 = allocate(2, 80);

  fprintf(stdout, "Allocations: %d, %d, %d\n", a1, a2, a3);

  deallocate_pool(2);

  char *a4 = allocate(3, 64);

  fprintf(stdout, "Allocations: %d, %d, %d, %d\n", a1, a2, a3, a4);

  char *a5 = allocate(3, 32);

  fprintf(stdout, "Allocations: %d, %d, %d, %d, %d\n", a1, a2, a3, a4, a5);

  fscanf(stdin, "%s", a4);
  fprintf(stdout, "%s", a4);
}
