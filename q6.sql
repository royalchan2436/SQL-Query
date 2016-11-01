SET search_path TO artistdb;

/*Create a view to find all the artists and their albums and year that are produced
by a record label. */
CREATE VIEW ByLabel AS
SELECT a.album_id, a.artist_id, a."year"
FROM Album a INNER JOIN ProducedBy p ON a.album_id = p.album_id;

/*Create a view to find all the artists that has produced an indie album by 
subtracting all the ByLabel by all the albums. */
CREATE VIEW Indie AS
SELECT album_id, artist_id, "year"
FROM Album EXCEPT (SELECT * FROM ByLabel);

/*Create a view to find the first year in which all artists produce their albums. */
CREATE VIEW AlbumYear AS
SELECT ar.artist_id, min(al."year") AS minyear
FROM Album al INNER JOIN Artist ar ON al.artist_id = ar.artist_id
/*INNER JOIN Indie i ON ar.artist_id = i.artist_id*/
GROUP BY (ar.artist_id);

/*Create a view to find the artist id who has produced an indie album in their 
first year. */
CREATE VIEW StartIndie AS
SELECT y.artist_id
FROM AlbumYear y INNER JOIN Album a ON y.artist_id = a.artist_id AND y.minyear = a."year"
WHERE a.album_id in ( SELECT album_id FROM Indie);

/*Create a view to find all the canadian artists who satisfies the above conditions. */
CREATE VIEW Canada AS
SELECT a.artist_id, a.name
FROM StartIndie s INNER JOIN Artist a ON s.artist_id = a.artist_id
WHERE a.nationality = 'Canada';

/*Find the artist names who have ended up in a US label record later on. */
SELECT DISTINCT c.name AS artist_name
FROM Canada c INNER JOIN Album a ON c.artist_id = a.artist_id
INNER JOIN ProducedBy p ON a.album_id = p.album_id
INNER JOIN RecordLabel r ON p.label_id = r.label_id
WHERE r.country = 'America'
ORDER BY c.name ASC;

DROP VIEW Canada CASCADE;
DROP VIEW StartIndie CASCADE;
DROP VIEW AlbumYear CASCADE;
DROP VIEW Indie CASCADE;
DROP VIEW ByLabel CASCADE;