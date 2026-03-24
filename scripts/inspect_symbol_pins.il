; Edit these targets before running.
procedure(dumpMaster(libName cellName)
  let((cv)
    cv = dbOpenCellViewByType(libName cellName "symbol" "" "r")
    printf("=== %s/%s/symbol ===\n" libName cellName)
    unless(cv
      printf("open failed\n\n")
      return()
    )
    printf("bBox=%L terms=%d shapes=%d pins=%d\n"
      cv~>bBox length(cv~>terminals) length(cv~>shapes) length(cv~>pins))
    foreach(term cv~>terminals
      printf("term %s dir=%L pins=%d\n" term~>name term~>direction length(term~>pins))
      foreach(pin term~>pins
        printf("  figType=%L figBBox=%L\n" pin~>fig~>objType pin~>fig~>bBox)
      )
    )
    printf("\n")
    dbClose(cv)
  )
)

; Replace these with the symbols you need to inspect.
dumpMaster("YOUR_DEVICE_LIB" "YOUR_DEVICE_CELL")
dumpMaster("YOUR_BLOCK_LIB" "YOUR_BLOCK_CELL")

exit()
