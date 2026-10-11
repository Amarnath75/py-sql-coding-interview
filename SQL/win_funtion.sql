
-- SAMPLE TABLE: employees
-- employee_id | employee_name | salary
-- 101         | Arun           | 90000
-- 102         | Priya          | 80000
-- 103         | Kumar          | 80000
-- 104         | Ravi           | 70000
-- 105         | Divya          | 60000


-- 1. ROW_NUMBER()
-- Assigns a unique number to every row.

SELECT employee_id,
       employee_name,
       salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn
FROM employees;


-- 2. RANK()
-- Tied salaries get the same rank; skips the next rank.

SELECT employee_id,
       employee_name,
       salary,
       RANK() OVER (ORDER BY salary DESC) AS rnk
FROM employees;


-- 3. DENSE_RANK()
-- Tied salaries get the same rank; no rank is skipped.

SELECT employee_id,
       employee_name,
       salary,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS drnk
FROM employees;


-- 4. TOP 3 SALARIES (INCLUDING TIES)

WITH cte AS (
    SELECT *,
           DENSE_RANK() OVER (
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
)
SELECT *
FROM cte
WHERE rnk <= 3;


-- 5. SECOND-HIGHEST DISTINCT SALARY

WITH cte AS (
    SELECT salary,
           DENSE_RANK() OVER (
               ORDER BY salary DESC
           ) AS rnk
    FROM employees
)
SELECT DISTINCT salary
FROM cte
WHERE rnk = 2;


-- 6. REMOVE DUPLICATES, KEEP ONE RECORD
-- Keep the latest record for each employee.

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY employee_id
               ORDER BY updated_at DESC
           ) AS rn
    FROM employees
)
SELECT *
FROM cte
WHERE rn = 1;

/*
INTERVIEW MEMORY TRICK

ROW_NUMBER()  -> 1, 2, 3, 4, 5
RANK()        -> 1, 2, 2, 4, 5
DENSE_RANK()  -> 1, 2, 2, 3, 4

ROW_NUMBER: Unique row numbers
RANK:       Skips ranks after ties
DENSE_RANK: No skipped ranks
*/