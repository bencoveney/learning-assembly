#include <stdio.h>

long squareme(long x) {
  return x * x;
}

long myval;
int main() {
  fprintf(stdout, "Enter a number: \n");
  fscanf(stdin, "%d", &myval);
  fprintf(stdout, "The square of %d is %d", myval, squareme(myval));
}
