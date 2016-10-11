-- Listing 3-1. Creating the customers Table
CREATE TABLE customers
(
id NUMBER,
datasrc_id NUMBER,
name VARCHAR2(35),
category VARCHAR2(30),
street_number VARCHAR2(5),
street_name VARCHAR2(60),
city VARCHAR2(32),
postal_code VARCHAR2(16),
state VARCHAR2(32),
phone_number VARCHAR2(15),
customer_grade VARCHAR2(15)
);
