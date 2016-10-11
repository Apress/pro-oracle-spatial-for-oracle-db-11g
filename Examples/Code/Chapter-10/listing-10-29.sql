-- Listing 10-29. Setting Link Levels for the UNET Network
UPDATE unet_links SET link_leveL = 1 WHERE link_id IN (1, 2, 3, 5, 6, 7, 10);
UPDATE unet_links SET link_leveL = 2 WHERE link_id IN (4, 11);
UPDATE unet_links SET link_level = 3 WHERE link_id IN (8, 9);
COMMIT;
