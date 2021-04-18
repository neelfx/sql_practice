/*
 Write an SQL query to determine the 5th highest salary without using TOP or limit method.
*/
 
 
SELECT Salary
FROM Worker W1
WHERE 4 = (
 SELECT COUNT( DISTINCT ( W2.Salary ) )
 FROM Worker W2
 WHERE W2.Salary >= W1.Salary
 );
 
 