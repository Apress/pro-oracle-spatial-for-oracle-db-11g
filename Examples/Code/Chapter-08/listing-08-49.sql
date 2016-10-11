-- Listing 8-49. Explaining the Execution Plan for a SQL Statement
@?/rdbms/admin/utlxplan -- Load only once
SET AUTOTRACE ON
SELECT ct.id
FROM customers ct
WHERE SDO_WITHIN_DISTANCE
(
  ct.location,
  ( SELECT location FROM competitors WHERE id=1),
  'DISTANCE=0.25 UNIT=MILE '
)='TRUE'
