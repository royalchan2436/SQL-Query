SET search_path TO artistdb;

/*Create a view to find all the cover songs. */
CREATE VIEW CoverSongs AS
SELECT b1.album_id AS album1, b2.album_id AS album2, b1.song_id AS song
FROM BelongsToAlbum b1 INNER JOIN BelongsToAlbum b2 ON b1.song_id = b2.song_id
WHERE b1.album_id != b2.album_id;

/*Find the albums' names, years, and artistss names of the cover songs. */
SELECT DISTINCT s.title AS song_name, al."year", ar.name AS artist_name
FROM CoverSongs c INNER JOIN Album al ON c.album1 = al.album_id
INNER JOIN Artist ar ON al.artist_id = ar.artist_id
INNER JOIN Song s ON c.song = s.song_id
ORDER BY s.title ASC, al."year" ASC, ar.name ASC;

DROP VIEW CoverSongs CASCADE;