-- Listing 12-1. Branches in San Francisco

SELECT street_number num,
       street_name,
       city,
       postal_code
  FROM branches
 WHERE city = 'SAN FRANCISCO';
