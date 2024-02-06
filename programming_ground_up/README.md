# Programming from ground up book

https://savannah.nongnu.org/projects/pgubook/
https://mirrors.sarata.com/non-gnu/pgubook/ProgrammingGroundUp-1-0-booksize.pdf

## Useful commands

```bash
objdump -D ./output/file.o
objdump -x ./output/file.o
readelf -aW ./output/file.o
hd ./output/file.o
hd ./output/file
# Note: Object files with the same content can produce different output
diff <(command ./output/file.o) <(command ./output/file_alt.o)
shasum ./output/file.o ./output/file_alt.o
```

## x86 and x86-64

Having worked through this book to near the end of chapter 4, I am finding that there is a lot of differences between x86 assembly (for which this book was written) and x86-64 assembly (my processor's architecture). This includes:

- Operations on the stack, which are based on the wordsize.
- Calling conventions.

For this reason I am abandoning this book and switching to the one covered here:

https://lists.nongnu.org/archive/html/pgubook-readers/2021-11/msg00000.html

## References

https://web.archive.org/web/20160801075139/http://www.x86-64.org/documentation/abi.pdf
