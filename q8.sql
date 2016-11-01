SET search_path TO artistdb;

/*Create a view to find the information about the band 'AC/DC'. */
CREATE VIEW BandInfo AS
SELECT DISTINCT w.artist_id, w.band_id
FROM Artist a INNER JOIN WasInBand w ON a.artist_id = w.band_id
WHERE a.name = 'AC/DC';

INSERT INTO WasInBand(artist_id, band_id, start_year, end_year)
(SELECT artist_id, band_id, 2014, 2015 FROM BandInfo);

DROP VIEW BandInfo CASCADE;

