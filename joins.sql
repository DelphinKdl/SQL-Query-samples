-- Join Types


-- In SQL, there are many different ways to join tables.


-- INNER JOIN: Returns rows that have matching values in both tables. You should use it when you want to find matching rows between two tables.
-- LEFT JOIN: Returns all rows from the left table even if there are no matches in the right table. Use when you want to retrieve all rows from the left table, even if there are no matches in the right table. This method ensures you don't lose any rows in the left table.
-- RIGHT JOIN: Returns all rows from the right table, even if there are no matches in the left table. This is the opposite of a left join but isn't used much at all in the real world, so we won't practice them in this course. Use when you want to retrieve all rows from the right table, even if there are no matches in the left table (e.g., finding products without any sales).
-- FULL OUTER JOIN: Returns all rows when there is a match in either left or right table. Use when you want to combine all rows from both tables, regardless of whether there are matches.
-- SELF JOIN: Joins a table to itself to compare data within the same table. Use when you want to compare data within a single table (e.g., finding parent-child relationships).
-- ANTI JOIN: Returns all the rows in the left table that are NOT in the right table (where the right table key is null).

