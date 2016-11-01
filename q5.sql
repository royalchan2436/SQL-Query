SET search_path TO artistdb;

/*Combine all song and album */
CREATE VIEW T1 AS
SELECT al.artist_id, s.songwriter_id, al.album_id
FROM Song s INNER JOIN BelongsToAlbum b ON s.song_id = b.song_id INNER JOIN Album al ON b.album_id = al.album_id;

/*Find all empty album */
CREATE VIEW T2 AS
SELECT album_id FROM Album WHERE album_id NOT IN (SELECT DISTINCT album_id FROM BelongsToAlbum);

/*Find all empty album artist and album title*/
CREATE VIEW T3 AS
SELECT Artist.name AS artist_name, Album.title AS album_name FROM T2 INNER JOIN Album ON T2.album_id = Album.album_id INNER JOIN Artist ON Album.artist_id = Artist.artist_id;

/*Find how many songwriters in one album*/
CREATE VIEW T4 AS
SELECT count(DISTINCT songwriter_id) AS number, album_id
FROM T1
GROUP BY album_id;

/*Find the album only have one songwriter*/
CREATE VIEW T5 AS
SELECT album_id
FROM T4
WHERE number = 1;

/*Find the songwriter match the album*/
CREATE VIEW T6 AS
SELECT T1.songwriter_id, T1.album_id, T1.artist_id
FROM T5 INNER JOIN T1 ON T5.album_id = T1.album_id;

/*Find the album which only songwriter_id equal to artist_id*/
CREATE VIEW T7 AS
SELECT DISTINCT album_id
FROM T6
WHERE songwriter_id = artist_id;

/*Find the artist name and album title*/
CREATE VIEW T8 AS
SELECT a.name AS artist_name, b.title AS album_name
FROM T7 INNER JOIN Album b ON T7.album_id = b.album_id INNER JOIN Artist a ON b.artist_id = a.artist_id;

/*Combine with empty album*/
CREATE VIEW T9 AS
(SELECT * FROM T3) UNION (SELECT * FROM T8);

/*Answer*/

SELECT * FROM T9 ORDER BY T9.artist_name ASC, T9.album_name ASC;

/*Drop Views*/
DROP VIEW T9 CASCADE;
DROP VIEW T8 CASCADE;
DROP VIEW T7 CASCADE;
DROP VIEW T6 CASCADE;
DROP VIEW T5 CASCADE;
DROP VIEW T4 CASCADE;
DROP VIEW T3 CASCADE;
DROP VIEW T2 CASCADE;
DROP VIEW T1 CASCADE;