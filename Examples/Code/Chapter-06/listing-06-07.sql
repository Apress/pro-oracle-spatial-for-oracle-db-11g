-- Listing 6-7. FORMAT_GEO_ADDR Procedure
CREATE OR REPLACE PROCEDURE format_geo_addr (
  address SDO_GEO_ADDR
)
AS
BEGIN
  dbms_output.put_line ('- ID                     ' || address.ID);
  dbms_output.put_line ('- ADDRESSLINES');
  if address.addresslines.count() > 0 then
    for i in 1..address.addresslines.count() loop
      dbms_output.put_line ('- ADDRESSLINES['||i||']           ' || address.ADDRESSLINES(i));
    end loop;
  end if;
  dbms_output.put_line ('- PLACENAME              ' || address.PLACENAME);
  dbms_output.put_line ('- STREETNAME             ' || address.STREETNAME);
  dbms_output.put_line ('- INTERSECTSTREET        ' || address.INTERSECTSTREET);
  dbms_output.put_line ('- SECUNIT                ' || address.SECUNIT);
  dbms_output.put_line ('- SETTLEMENT             ' || address.SETTLEMENT);
  dbms_output.put_line ('- MUNICIPALITY           ' || address.MUNICIPALITY);
  dbms_output.put_line ('- REGION                 ' || address.REGION);
  dbms_output.put_line ('- COUNTRY                ' || address.COUNTRY);
  dbms_output.put_line ('- POSTALCODE             ' || address.POSTALCODE);
  dbms_output.put_line ('- POSTALADDONCODE        ' || address.POSTALADDONCODE);
  dbms_output.put_line ('- FULLPOSTALCODE         ' || address.FULLPOSTALCODE);
  dbms_output.put_line ('- POBOX                  ' || address.POBOX);
  dbms_output.put_line ('- HOUSENUMBER            ' || address.HOUSENUMBER);
  dbms_output.put_line ('- BASENAME               ' || address.BASENAME);
  dbms_output.put_line ('- STREETTYPE             ' || address.STREETTYPE);
  dbms_output.put_line ('- STREETTYPEBEFORE       ' || address.STREETTYPEBEFORE);
  dbms_output.put_line ('- STREETTYPEATTACHED     ' || address.STREETTYPEATTACHED);
  dbms_output.put_line ('- STREETPREFIX           ' || address.STREETPREFIX);
  dbms_output.put_line ('- STREETSUFFIX           ' || address.STREETSUFFIX);
  dbms_output.put_line ('- SIDE                   ' || address.SIDE);
  dbms_output.put_line ('- PERCENT                ' || address.PERCENT);
  dbms_output.put_line ('- EDGEID                 ' || address.EDGEID);
  dbms_output.put_line ('- ERRORMESSAGE           ' || address.ERRORMESSAGE);
  dbms_output.put_line ('- MATCHVECTOR            ' || address.MATCHVECTOR);
  dbms_output.put_line ('-   '||  substr (address.errormessage,5,1)  ||' '||substr (address.matchvector,5,1)  ||' House or building number'); 
  dbms_output.put_line ('-   '||  substr (address.errormessage,6,1)  ||' '||substr (address.matchvector,6,1)  ||' Street prefix');
  dbms_output.put_line ('-   '||  substr (address.errormessage,7,1)  ||' '||substr (address.matchvector,7,1)  ||' Street base name'); 
  dbms_output.put_line ('-   '||  substr (address.errormessage,8,1)  ||' '||substr (address.matchvector,8,1)  ||' Street suffix');
  dbms_output.put_line ('-   '||  substr (address.errormessage,9,1)  ||' '||substr (address.matchvector,9,1)  ||' Street type'); 
  dbms_output.put_line ('-   '||  substr (address.errormessage,10,1) ||' '||substr (address.matchvector,10,1) ||' Secondary unit'); 
  dbms_output.put_line ('-   '||  substr (address.errormessage,11,1) ||' '||substr (address.matchvector,11,1) ||' Built-up area or city'); 
  dbms_output.put_line ('-   '||  substr (address.errormessage,14,1) ||' '||substr (address.matchvector,14,1) ||' Region'); 
  dbms_output.put_line ('-   '||  substr (address.errormessage,15,1) ||' '||substr (address.matchvector,15,1) ||' Country'); 
  dbms_output.put_line ('-   '||  substr (address.errormessage,16,1) ||' '||substr (address.matchvector,16,1) ||' Postal code'); 
  dbms_output.put_line ('-   '||  substr (address.errormessage,17,1) ||' '||substr (address.matchvector,17,1) ||' Postal add-on code');
  dbms_output.put_line ('- MATCHCODE              ' || address.MATCHCODE || ' = ' ||
    case address.MATCHCODE
      when  1 then 'Exact match'
      when  2 then 'Street type not matched'
      when  3 then 'House number not matched'
      when  4 then 'Street name not matched'
      when 10 then 'Postal code not matched'
      when 11 then 'City not matched'
    end
  );
  dbms_output.put_line ('- MATCHMODE              ' || address.MATCHMODE);
  dbms_output.put_line ('- LONGITUDE              ' || address.LONGITUDE);
  dbms_output.put_line ('- LATITUDE               ' || address.LATITUDE);
end;
/
show errors
