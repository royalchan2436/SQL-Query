SET search_path TO artistdb;

/*Create view to get the label id, label name for every record label and 
sales and year for each album. */
CREATE VIEW Labels AS
SELECT al.sales, re.label_id, re.label_name, al."year"
FROM RecordLabel re INNER JOIN ProducedBy pr ON re.label_id = pr.label_id
INNER JOIN Album al ON al.album_id = pr.album_id;

/*Create view to get the sales for each label and each year.  */
CREATE VIEW LabelSales AS
SELECT label_id, sum(sales) AS album_sales, "year"
FROM Labels
GROUP BY label_id, "year";

/*Create view to get only the sales where each record label have more 
than 0 revenue for that year. */
CREATE VIEW Sales AS
SELECT *
FROM LabelSales l
WHERE l.album_sales != 0;

/*Find the label name, album sales and year for each record label. */ 
SELECT DISTINCT r.label_name AS record_label, s."year", s.album_sales AS total_sales
FROM Sales s INNER JOIN RecordLabel r ON s.label_id = r.label_id
ORDER BY r.label_name ASC , s."year" ASC;

/*Drop Views*/
DROP VIEW Sales CASCADE;
DROP VIEW LabelSales CASCADE;
DROP VIEW Labels CASCADE;