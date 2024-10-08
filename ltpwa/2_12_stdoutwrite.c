#include<stdio.h>

int main()
{
  char formatstring1[] = "%s is %d\n\0";
  char sallyname[] = "Sally\0";
  long int sallyage = 53;
  fprintf(stdout, formatstring1, sallyname, sallyage);
  return 0;
}
