-- Listing 3-4. Sample Address for a Specific Customer in the customers Table
SELECT street_number, street_name, city, state, postal_code
FROM customers
WHERE id = 1;

