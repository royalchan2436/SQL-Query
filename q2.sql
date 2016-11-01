SET search_path TO artistdb;

/*Create view to find the sales for albums which include songs that are 
collaberated between two differrnt artists. */
CREATE VIEW Collab AS
SELECT DISTINCT be.album_id, al.artist_id, al.sales
FROM Collaboration co INNER JOIN BelongsToAlbum be ON co.song_id = be.song_id
INNER JOIN Album al ON be.album_id = al.album_id ;

/*Create view to find the sales for albums which includes only songs that
are done by individual artist. */
CREATE VIEW Indep AS
SELECT DISTINCT album_id, artist_id, sales
FROM Album
EXCEPT (SELECT * FROM collab);

/*Create view to find the average album sales for which artist has collaboration
with another artist. */
CREATE VIEW AveCollab AS
SELECT DISTINCT avg(sales) AS avg_sales, artist_id
FROM Collab
GROUP BY artist_id;

/*Create view to find the average album sales for which artist has done 
individually. */
CREATE VIEW AveIndep AS
SELECT DISTINCT avg(sales) AS avg_sales, artist_id
FROM Indep
GROUP BY artist_id;

/*Find the artists' names and average sales for collaboration albums in 
which the average album sales for collaboration is higher. */
SELECT DISTINCT a.name AS artists, c.avg_sales AS avg_collab_sales
FROM AveCollab c INNER JOIN AveIndep i ON c.artist_id = i.artist_id
INNER JOIN Artist a ON a. artist_id = c.artist_id
WHERE c.avg_sales > i.avg_sales
ORDER BY a.name ASC ;

/*Drop Views*/
DROP VIEW AveIndep CASCADE;
DROP VIEW AveCollab CASCADE;
DROP VIEW Indep CASCADE;
DROP VIEW Collab CASCADE;