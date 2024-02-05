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

## References

https://web.archive.org/web/20160801075139/http://www.x86-64.org/documentation/abi.pdf
