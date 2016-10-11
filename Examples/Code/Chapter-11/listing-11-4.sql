-- Listing 11-4. Performing the partitioning

exec sdo_router_partition.partition_router('NODE_PART', 1000);
-- Now delete temporary tables left over by the partitioning
drop table EDGE_PART purge;
drop table FINAL_PARTITION purge;
drop table NODE_PART purge;
drop table PARTITION_TMP_2 purge;
drop table PARTITION_TMP_3 purge;
drop table SUPER_EDGE_IDS purge;
drop table SUPER_NODE_IDS purge;
purge recyclebin;
