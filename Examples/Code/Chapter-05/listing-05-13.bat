REM Listing 5-13. Creating the Transported Tablespace in the Target Database
REM <copy the file to new system with user spatial created>
IMP USERID = "'SYS/<password>'" TRANSPORT_TABLESPACE=Y FILE=trans_ts.dmp DATAFILES='sdo_tts.dbf' TABLESPACES=tbs
