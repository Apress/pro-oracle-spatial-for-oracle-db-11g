REM Listing 5-19. Executing the Output Files from SHP2SDO to Load Data into Oracle
SQLPLUS spatial/spatial @customers.sql
SQLLDR spatial/spatial CONTROL=customers.ctl
