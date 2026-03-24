; Edit these targets before running.
procedure(dumpSchematic(libName cellName)
  let((cv)
    cv = dbOpenCellViewByType(libName cellName "schematic" "" "r")
    printf("=== %s/%s/schematic ===\n" libName cellName)
    unless(cv
      printf("open failed\n\n")
      return()
    )
    printf("instances=%d nets=%d terminals=%d shapes=%d pins=%d\n"
      length(cv~>instances) length(cv~>nets) length(cv~>terminals)
      length(cv~>shapes) length(cv~>pins))
    foreach(inst cv~>instances
      printf("inst %s master=%s/%s/%s xy=%L orient=%L bBox=%L\n"
        inst~>name inst~>libName inst~>cellName inst~>viewName
        inst~>xy inst~>orient inst~>bBox)
    )
    foreach(term cv~>terminals
      printf("term %s dir=%L pins=%d net=%L\n"
        term~>name term~>direction length(term~>pins)
        when(term~>net term~>net~>name))
    )
    foreach(shape cv~>shapes
      printf("shape objType=%L lpp=%L bBox=%L net=%L\n"
        shape~>objType shape~>lpp shape~>bBox
        when(shape~>net shape~>net~>name))
    )
    printf("\n")
    dbClose(cv)
  )
)

; Replace these with your own known-good and target cells.
dumpSchematic("YOUR_REFERENCE_LIB" "YOUR_REFERENCE_CELL")
dumpSchematic("YOUR_TARGET_LIB" "YOUR_TARGET_CELL")

exit()
