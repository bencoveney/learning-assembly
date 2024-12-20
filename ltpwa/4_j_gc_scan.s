# Contains the garbace collection function, gc_scan. The details of this function are divided into
# other files...

.globl gc_scan
.section .text

# Parameters - none
# Registers - none
gc_scan:
  enter $0, $0

  # Setup space for pointer list
  call gc_scan_init
  # Unmark all objects
  call gc_unmark_all
  # Get initial set of pointers from base objects
  # (stack, data)
  call gc_scan_base_objects
  # Walk pointer list
  call gc_walk_pointers
  # Give back space from pointer list
  call gc_scan_cleanup

  leave
  ret
