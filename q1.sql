SET search_path TO artistdb;

/* Create View all include artist who is band */
CREATE VIEW notband AS
SELECT Artist.name
FROM Artist INNER JOIN "role" ON Artist.artist_id = "role".artist_id
WHERE "role"."role" = 'Band';

/* Extract All artist birthdate */
CREATE VIEW Birth AS
SELECT artist_id ,EXTRACT(YEAR FROM birthdate) AS year_birth
FROM Artist;

/* Find Steppeenwolf's Artist_id */
CREATE VIEW Steppen AS
SELECT artist_id
FROM Artist
WHERE name = 'Steppenwolf';

/* Find the Year of Steppen First Album */
CREATE VIEW Min_year AS
SELECT min("year") AS year_want
FROM Album INNER JOIN Steppen ON Album.artist_id = Steppen.artist_id;

/* Find all the artist who born in the year of Steppen First Album */
CREATE VIEW Total AS
SELECT DISTINCT Artist.name ,Artist.nationality
FROM Artist INNER JOIN Birth ON Artist.artist_id = Birth.artist_id
WHERE Birth.year_birth = (SELECT DISTINCT year_want FROM Min_year);

/* Exclude the band name */
SELECT name, nationality
FROM Total
WHERE name NOT IN (SELECT name FROM notband)
ORDER BY name ASC;


/* Drop Views */
DROP VIEW notband CASCADE;
DROP VIEW Total CASCADE;
DROP VIEW Min_year CASCADE;
DROP VIEW Birth CASCADE;
DROP VIEW Steppen CASCADE;



