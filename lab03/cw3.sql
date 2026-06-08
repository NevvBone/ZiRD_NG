-- zad1
SELECT first_name, last_name, salary,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS ranking_pensji
FROM EMPLOYEES;
-- zad2
SELECT first_name, last_name, salary,
       SUM(salary) OVER () AS calkowita_suma_pensji
FROM EMPLOYEES;
-- zad3
CREATE TABLE sales AS SELECT * FROM HR.sales;
CREATE TABLE products AS SELECT * FROM HR.products;
-- zad4
SELECT e.last_name, p.product_name,
       SUM(s.quantity * p.price) OVER (PARTITION BY e.employee_id ORDER BY s.sale_date) AS skumulowana_sprzedaz,
       RANK() OVER (ORDER BY (s.quantity * p.price) DESC) AS ranking_sprzedazy
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id
JOIN products p ON s.product_id = p.product_id;
-- zad5
SELECT e.last_name, p.product_name, p.price,
       COUNT(s.product_id) OVER (PARTITION BY s.product_id, TRUNC(s.sale_date)) AS liczba_transakcji_dnia,
       SUM(s.quantity * p.price) OVER (PARTITION BY s.product_id, TRUNC(s.sale_date)) AS suma_zaplacona_dnia,
       LAG(p.price) OVER (PARTITION BY s.product_id ORDER BY s.sale_date) AS poprzednia_cena,
       LEAD(p.price) OVER (PARTITION BY s.product_id ORDER BY s.sale_date) AS kolejna_cena
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN products p ON s.product_id = p.product_id;
-- zad6
SELECT p.product_name, p.price,
       SUM(s.quantity * p.price) OVER (PARTITION BY s.product_id, TRUNC(s.sale_date, 'MM')) AS suma_calkowita_miesiac,
       SUM(s.quantity * p.price) OVER (PARTITION BY s.product_id, TRUNC(s.sale_date, 'MM') ORDER BY s.sale_date) AS suma_rosnaca_miesiac
FROM sales s
JOIN products p ON s.product_id = p.product_id;
-- zad7
WITH sales2022 AS (
    SELECT p.product_name, p.category_name, s.sale_date, p.price
    FROM sales s JOIN products p ON s.product_id = p.product_id
    WHERE EXTRACT(YEAR FROM s.sale_date) = 2022
),
sales2023 AS (
    SELECT p.product_name, s.sale_date, p.price
    FROM sales s JOIN products p ON s.product_id = p.product_id
    WHERE EXTRACT(YEAR FROM s.sale_date) = 2023
)
SELECT s22.category_name, s22.product_name,
       s22.price AS cena_2022, 
       s23.price AS cena_2023,
       (s23.price - s22.price) AS roznica_ceny
FROM sales2022 s22
JOIN sales2023 s23 ON s22.product_name = s23.product_name
AND TO_CHAR(s22.sale_date, 'MM-DD') = TO_CHAR(s23.sale_date, 'MM-DD');
-- zad8
SELECT p.category_name, p.product_name, p.price,
       MIN(p.price) OVER (PARTITION BY p.category_name) AS min_cena_w_kategorii,
       MAX(p.price) OVER (PARTITION BY p.category_name) AS max_cena_w_kategorii,
       MAX(p.price) OVER (PARTITION BY p.category_name) - MIN(p.price) OVER (PARTITION BY p.category_name) AS roznica_max_min
FROM products p;
-- zad9
SELECT p.product_name, s.sale_date, p.price,
       AVG(p.price) OVER (PARTITION BY s.product_id ORDER BY s.sale_date 
                          ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS srednia_kroczaca
FROM sales s
JOIN products p ON s.product_id = p.product_id;
-- zad10
SELECT product_name, category_name, price,
       RANK() OVER (PARTITION BY category_name ORDER BY price DESC) AS ranking,
       ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY price DESC) AS numer_wiersza,
       DENSE_RANK() OVER (PARTITION BY category_name ORDER BY price DESC) AS ranking_gesty
FROM products;
-- zad11
SELECT e.last_name, p.product_name,
       SUM(p.price * s.quantity) OVER (PARTITION BY e.employee_id ORDER BY s.sale_date) AS wartosc_rosnaca_sprzedazy,
       RANK() OVER (ORDER BY (p.price * s.quantity) DESC) AS globalny_ranking_zamowienia
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN products p ON s.product_id = p.product_id;
-- zad12
SELECT DISTINCT e.first_name, e.last_name, j.job_title
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
JOIN sales s ON e.employee_id = s.employee_id;