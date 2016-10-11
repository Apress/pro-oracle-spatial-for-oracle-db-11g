-- Listing 4-16. Creating a Preferred Transformation Path Between 41155 (Projection-Based on NAD27) and 4269 (NAD83)
SQL > call sdo_cs.create_pref_concatenated_op(
10000, -- any unique id of the operation,
TFM_PLAN(
SDO_TFM_CHAIN(
 41155, -- source srid
 14205, 4267, -- convid 14205 from srid 41155 (32041) to srid 4267
 1241, 4269 -- convid 1241 from 4267 to 4269
 ),
NULL);
