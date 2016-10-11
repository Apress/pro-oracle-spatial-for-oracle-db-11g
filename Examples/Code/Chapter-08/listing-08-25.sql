-- Listing 8-25. A Simple Example of the SDO_NN Operator
SELECT ct.id, ct.name
FROM competitors comp, customers ct
WHERE comp.id=1
AND SDO_NN(ct.location, comp.location)='TRUE' ;

