-- zad1
CREATE VIEW v_wysokie_pensje AS
SELECT * FROM employees 
WHERE salary > 6000;
-- zad2
CREATE OR REPLACE VIEW v_wysokie_pensje AS
SELECT * FROM employees 
WHERE salary > 12000;
-- zad3
DROP VIEW v_wysokie_pensje;
-- zad4
CREATE VIEW v_pracownicy_finance AS
SELECT e.employee_id, e.last_name, e.first_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';
-- zad5
CREATE VIEW v_srednie_zarobki AS
SELECT employee_id, last_name, first_name, salary, job_id, email, hire_date
FROM employees
WHERE salary BETWEEN 5000 AND 12000;
-- zad6a
UPDATE v_pracownicy_zakres_pensji
SET last_name = 'Roku'
WHERE employee_id = 120;
-- zad6b
INSERT INTO v_pracownicy_zakres_pensji (employee_id, last_name, email, hire_date, job_id, salary)
VALUES (39, 'Kasane', 'teto@crypton.co.jp', SYSDATE, 'IT_PROG', 8039);
-- zad6c
DELETE FROM v_pracownicy_zakres_pensji
WHERE employee_id = 39;
-- zad7
CREATE VIEW v_statystyki_dzialow AS
SELECT d.department_id, 
       d.department_name, 
       COUNT(e.employee_id) AS liczba_pracownikow, 
       AVG(e.salary) AS srednia_pensja, 
       MAX(e.salary) AS najwyzsza_pensja
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) >= 4;
-- zad8
CREATE OR REPLACE VIEW v_pracownicy_zakres_pensji_check AS
SELECT 
    employee_id, 
    last_name, 
    first_name, 
    salary, 
    job_id, 
    email, 
    hire_date
FROM 
    employees
WHERE 
    salary BETWEEN 5000 AND 12000
WITH CHECK OPTION CONSTRAINT v_zakres_pensji_chk;
-- zad8a
INSERT INTO v_pracownicy_zakres_pensji_check (
    employee_id, 
    last_name, 
    first_name, 
    salary, 
    job_id, 
    email, 
    hire_date
)
VALUES (
    991, 
    'Kowalski', 
    'Jan', 
    7000, 
    'IT_PROG', 
    'JKOWAL@example.com', 
    SYSDATE
);
-- zad8b
INSERT INTO v_pracownicy_zakres_pensji_check (
    employee_id, 
    last_name, 
    first_name, 
    salary, 
    job_id, 
    email, 
    hire_date
)
VALUES (
    992, 
    'Nowak', 
    'Anna', 
    13000, 
    'IT_PROG', 
    'ANOWAK@example.com', 
    SYSDATE
); -- nie można dodać ORA-01402: view WITH CHECK OPTION where-clause violation
-- zad9
CREATE MATERIALIZED VIEW v_managerowie AS
SELECT DISTINCT m.employee_id, m.first_name, m.last_name, d.department_name
FROM employees m
JOIN employees e ON m.employee_id = e.manager_id
LEFT JOIN departments d ON m.department_id = d.department_id;
-- zad10
CREATE VIEW v_najlepiej_oplacani AS
SELECT employee_id, first_name, last_name, salary
FROM employees
ORDER BY salary DESC
FETCH FIRST 10 ROWS ONLY;