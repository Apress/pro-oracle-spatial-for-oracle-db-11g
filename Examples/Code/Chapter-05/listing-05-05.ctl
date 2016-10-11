-- Listing 5-6. sales_regions.ctl File
LOAD DATA
  INFILE sales_regions.dat
  INTO TABLE sales_regions
  APPEND
  FIELDS TERMINATED BY '|'
  TRAILING NULLCOLS
  (
    id NULLIF ID = BLANKS,
    geom COLUMN OBJECT
    (
      SDO_GTYPE INTEGER EXTERNAL,
      SDO_POINT COLUMN OBJECT
      (
        X FLOAT EXTERNAL,
        Y FLOAT EXTERNAL
      )
    )
)
