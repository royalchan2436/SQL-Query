SET search_path TO artistdb;

/*Create view to find the artist id for Mick Jagger. */
CREATE VIEW Jagger AS
SELECT artist_id
FROM Artist
WHERE name = 'Mick Jagger';

/*Create view to find the artist id for band Rolling Stones. */
CREATE VIEW Rolling AS
SELECT artist_id
FROM Artist
WHERE name = 'Rolling Stones';

/*Create view to find the artist id for Adan Levine. */
CREATE VIEW Adam AS
SELECT artist_id
FROM Artist
WHERE name = 'Adam Levine';

/*Create view to find the artist id for band Maroon 5. */
CREATE VIEW Maroon AS
SELECT artist_id
FROM Artist
WHERE name = 'Maroon 5';

/*Create view to combine the artist id for Jagger and band id for Maroon 5. */
CREATE VIEW Tuple AS
SELECT j.artist_id AS artist, m.artist_id AS band
FROM Jagger j, Maroon m;

/*Update the band information for Mick Jagger and Rolling Stones. */
UPDATE WasInBand
SET end_year = 2014
WHERE artist_id = (SELECT artist_id FROM Jagger)
AND band_id = (SELECT artist_id FROM Rolling);

/*Update the band information for Adam Levine and Maroon 5. */
UPDATE WasInBand
SET end_year = 2014
WHERE artist_id = (SELECT artist_id FROM Adam)
AND band_id = (SELECT artist_id FROM Maroon);

/*Insert a new tuple for band information for Mick Jagger and Maroon 5. */
INSERT INTO WasInBand(artist_id, band_id, start_year, end_year)
(SELECT t.artist, t.band, 2014,2015 FROM Tuple t);

/*SELECT * FROM WasInBand ORDER BY artist_id ;*/

DROP VIEW Tuple CASCADE;
DROP VIEW Maroon CASCADE;
DROP VIEW Adam CASCADE;
DROP VIEW Rolling CASCADE;
DROP VIEW Jagger CASCADE;