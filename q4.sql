SET search_path TO artistdb;

/*Combine All artist_id and genre_id */
CREATE VIEW AllArtist AS
SELECT a.artist_id,  genre_id
FROM Album a INNER JOIN Artist b ON a.artist_id = b.artist_id;

/*Count every artist has how many genre_ids*/
CREATE VIEW Test AS
SELECT count(DISTINCT genre_id) AS total, artist_id
FROM AllArtist
GROUP BY artist_id;

/*Combine every artist and (his/her/their) roles */
CREATE VIEW MutiRole AS
SELECT Test.artist_id ,"role"."role", Test.total 
FROM Test INNER JOIN "role" ON Test.artist_id = "role".artist_id;

/*Find all artist has >= 3 genre_ids and is not Songwriter*/
CREATE VIEW Answer AS
SELECT Artist.name AS artist_name, MutiRole."role" AS capacity, MutiRole.total AS num_genres
FROM Artist INNER JOIN MutiRole ON Artist.artist_id = MutiRole.artist_id
WHERE MutiRole.total >= 3 AND MutiRole."role" <> 'Songwriter';

/*Combine songwriter_id and genre_id */
CREATE VIEW AlbumAndSong AS
SELECT s.songwriter_id, a.genre_id
FROM BelongsToAlbum b INNER JOIN SONG s ON b.song_id = s.song_id INNER JOIN Album a ON a.album_id = b.album_id;

/*Count the genre_ids of every songwriter */
CREATE VIEW SongWriterThree AS
SELECT count(DISTINCT genre_id) AS number, songwriter_id
FROM AlbumAndSong
GROUP BY songwriter_id;

/*Find songwriter has genre_ids >= 3 */
CREATE VIEW SongWriterThree_1 AS
SELECT songwriter_id, number
FROM SongWriterThree
WHERE number >= 3;

/*Find the artist who is songwriter and has genre_ids >= 3 */
CREATE VIEW SongWriterThree_2 AS
SELECT a.name AS artist_name, r."role" AS capacity, s.number AS num_genres
FROM Artist a INNER JOIN SongWriterThree_1 s ON a.artist_id = s.songwriter_id INNER JOIN "role" r ON s.songwriter_id = r.artist_id
WHERE r."role" = 'Songwriter';
 
/*Union all answer */
(SELECT * FROM Answer ORDER BY Answer.num_genres DESC, Answer.artist_name ASC)
UNION ALL
(SELECT * FROM SongWriterThree_2 s ORDER BY s.num_genres DESC, s.artist_name ASC);

/*Drop Views */
DROP VIEW SongWriterThree_2 CASCADE;
DROP VIEW SongWriterThree_1 CASCADE;
DROP VIEW SongWriterThree CASCADE;
DROP VIEW AlbumAndSong CASCADE;
DROP VIEW Answer CASCADE;
DROP VIEW MutiRole CASCADE;
DROP VIEW Test CASCADE;
DROP VIEW AllArtist CASCADE;