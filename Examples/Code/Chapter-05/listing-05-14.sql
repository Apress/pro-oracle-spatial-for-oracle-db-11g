-- Listing 5-14. Enabling Spatial Indexes for the Tables in the Transported Tablespace
CONNECT SYS/<password>
ALTER TABLESPACE TBS READ WRITE;
CONNECT spatial/spatial;
EXEC SDO_UTIL.INITIALIZE_INDEXES_FOR_TTS;
