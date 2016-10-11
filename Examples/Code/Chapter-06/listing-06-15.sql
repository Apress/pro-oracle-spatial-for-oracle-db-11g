-- Listing 6-15. FORMAT_ADDR_ARRAY Procedure
CREATE OR REPLACE PROCEDURE format_addr_array
(
  address_list SDO_ADDR_ARRAY
)
AS
BEGIN
  IF address_list.count() > 0 THEN
    FOR i IN 1..address_list.count() LOOP
      dbms_output.put_line ('ADDRESS['||i||']');
      format_geo_addr (address_list(i));
    END LOOP;
  END IF;
END;
/
show errors
