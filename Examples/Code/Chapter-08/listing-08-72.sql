-- Listing 8-72. SDO_FILTER Operator Retrieving All Customers Whose MBRs Intersect Those of Competitor Regions
SELECT COUNT(DISTINCT ct.id)
FROM competitors_sales_regions comp, customers ct
WHERE SDO_FILTER(ct.location, comp.geom)='TRUE';
