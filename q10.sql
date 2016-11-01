SET search_path TO artistdb;

CREATE VIEW ToBeDeleted AS
SELECT DISTINCT al.album_id, b.song_id
FROM Album al NATURAL JOIN Artist ar NATURAL JOIN BelongsToAlbum b
WHERE al.title = 'Thriller' and ar.name = 'Michael Jackson';

CREATE TABLE Thriller
(album_id integer, song_id integer);

INSERT INTO Thriller (album_id, song_id)
(SELECT album_id, song_id FROM ToBeDeleted);


SELECT * FROM Thriller;

DELETE FROM ProducedBy
WHERE album_id in (SELECT album_id FROM Thriller);
/*AND label_id = (SELECT label_id FROM Label);*/

DELETE FROM Collaboration
WHERE song_id in (SELECT song_id FROM Thriller);
/*AND artist1 = (SELECT artist1 FROM Collab)
AND artist2 = (SELECT artist2 FROM collab);*/

DELETE FROM BelongsToAlbum
WHERE song_id in (SELECT song_id FROM Thriller) 
AND album_id in (SELECT album_id FROM Thriller);

DELETE FROM Album
WHERE album_id in (SELECT album_id FROM Thriller);

DELETE FROM Song
WHERE song_id in (SELECT song_id FROM Thriller);

SELECT * FROM Album;
SELECT * FROM Song;

DROP VIEW ToBeDeleted CASCADE;
DROP TABLE Thriller CASCADE;