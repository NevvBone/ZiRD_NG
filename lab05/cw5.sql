-- zad1
DECLARE
  v_max_id        departments.department_id%TYPE;
  v_new_dept_id   departments.department_id%TYPE;
  v_dept_name     departments.department_name%TYPE := 'EDUCATION';
BEGIN
  SELECT MAX(department_id) INTO v_max_id FROM departments;
  DBMS_OUTPUT.PUT_LINE('Maksymalny numer departamentu: ' || v_max_id);
  v_new_dept_id := v_max_id + 10;
  INSERT INTO departments (department_id, department_name, manager_id, location_id)
  VALUES (v_new_dept_id, v_dept_name, NULL, NULL);
  COMMIT;
END;
-- zad2
BEGIN
  UPDATE departments
  SET location_id = 3000
  WHERE department_name = 'EDUCATION';
  COMMIT;
END;
-- zad1 zaaktualizowane
DECLARE
  v_max_id        departments.department_id%TYPE;
  v_new_dept_id   departments.department_id%TYPE;
  v_dept_name     departments.department_name%TYPE := 'EDUCATION';
BEGIN
  SELECT MAX(department_id) INTO v_max_id FROM departments;
  DBMS_OUTPUT.PUT_LINE('Maksymalny numer departamentu: ' || v_max_id);
  v_new_dept_id := v_max_id + 10;
  INSERT INTO departments (department_id, department_name, manager_id, location_id)
  VALUES (v_new_dept_id, v_dept_name, NULL, NULL);
  UPDATE departments
  SET location_id = 3000
  WHERE department_id = v_new_dept_id;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Dodano i zaktualizowano departament o ID: ' || v_new_dept_id);
END;
/
-- zad3
CREATE TABLE nowa (
    wartosc VARCHAR2(10)
);

BEGIN
    FOR i IN 1..10 LOOP
        IF i NOT IN (4, 6) THEN
            INSERT INTO nowa (wartosc) VALUES (TO_CHAR(i));
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Zakonczono wstawianie do tabeli NOWA.');
END;
/
-- zad4
DECLARE
    v_kraj countries%ROWTYPE;
BEGIN
    SELECT * INTO v_kraj 
    FROM countries 
    WHERE country_id = 'CA';
    
    DBMS_OUTPUT.PUT_LINE('Nazwa: ' || v_kraj.country_name || ', Region ID: ' || v_kraj.region_id);
END;
/
-- zad5
DECLARE
    CURSOR c_pracownicy IS 
        SELECT salary, last_name 
        FROM employees 
        WHERE department_id = 50;
BEGIN
    FOR rec IN c_pracownicy LOOP
        IF rec.salary > 3100 THEN
            DBMS_OUTPUT.PUT_LINE(rec.last_name || ' - nie dawać podwyżki');
        ELSE
            DBMS_OUTPUT.PUT_LINE(rec.last_name || ' - dać podwyżkę');
        END IF;
    END LOOP;
END;
/
-- zad6
DECLARE
    CURSOR c_prac_param (p_min_sal NUMBER, p_max_sal NUMBER, p_imie VARCHAR2) IS
        SELECT first_name, last_name, salary
        FROM employees
        WHERE salary BETWEEN p_min_sal AND p_max_sal
          AND UPPER(first_name) LIKE '%' || UPPER(p_imie) || '%';
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Parametry: 1000-5000, litera A ---');
    FOR rec IN c_prac_param(1000, 5000, 'A') LOOP
        DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name || ' - ' || rec.salary);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('--- Parametry: 5000-20000, litera U ---');
    FOR rec IN c_prac_param(5000, 20000, 'U') LOOP
        DBMS_OUTPUT.PUT_LINE(rec.first_name || ' ' || rec.last_name || ' - ' || rec.salary);
    END LOOP;
END;
/
-- zad9a
CREATE OR REPLACE PROCEDURE p_dodaj_job (p_id IN VARCHAR2, p_title IN VARCHAR2) IS
BEGIN
    INSERT INTO jobs (job_id, job_title) VALUES (p_id, p_title);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Dodano job: ' || p_title);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas dodawania: ' || SQLERRM);
END;
/
EXECUTE p_dodaj_job('IT_TEST', 'Tester Oprogramowania');
-- zad9b
CREATE OR REPLACE PROCEDURE p_modyfikuj_job (p_id IN VARCHAR2, p_nowy_title IN VARCHAR2) IS
    e_no_jobs_updated EXCEPTION;
BEGIN
    UPDATE jobs SET job_title = p_nowy_title WHERE job_id = p_id;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_jobs_updated;
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Zaktualizowano job: ' || p_id);
EXCEPTION
    WHEN e_no_jobs_updated THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: Nie znaleziono stanowiska (No jobs updated)');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Inny błąd: ' || SQLERRM);
END;
/
EXECUTE p_modyfikuj_job('IT_TEST', 'Główny Tester');
EXECUTE p_modyfikuj_job('ZLY_ID', 'Nie zadziala');
-- zad9c
CREATE OR REPLACE PROCEDURE p_usun_job (p_id IN VARCHAR2) IS
    e_no_jobs_deleted EXCEPTION;
BEGIN
    DELETE FROM jobs WHERE job_id = p_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE e_no_jobs_deleted;
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usunięto stanowisko: ' || p_id);
EXCEPTION
    WHEN e_no_jobs_deleted THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: Brak stanowiska do usunięcia (No jobs deleted)');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Inny błąd usuwania: ' || SQLERRM);
END;
/
EXECUTE p_usun_job('IT_TEST');
EXECUTE p_usun_job('ZLY_ID');
-- zad9d
CREATE OR REPLACE PROCEDURE p_dane_pracownika (
    p_emp_id IN NUMBER, 
    p_salary OUT NUMBER, 
    p_last_name OUT VARCHAR2
) IS
BEGIN
    SELECT salary, last_name INTO p_salary, p_last_name 
    FROM employees 
    WHERE employee_id = p_emp_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono pracownika o ID: ' || p_emp_id);
END;
/
DECLARE
    v_pensja NUMBER;
    v_nazwisko VARCHAR2(50);
BEGIN
    p_dane_pracownika(100, v_pensja, v_nazwisko);
    DBMS_OUTPUT.PUT_LINE('Zarobki: ' || v_pensja || ', Nazwisko: ' || v_nazwisko);
END;
/
-- zad9e
CREATE OR REPLACE PROCEDURE p_dodaj_pracownika (
    p_first_name IN VARCHAR2 DEFAULT 'Jan',
    p_last_name IN VARCHAR2 DEFAULT 'Kowalski',
    p_email IN VARCHAR2 DEFAULT 'jkowalski@test.com',
    p_hire_date IN DATE DEFAULT SYSDATE,
    p_job_id IN VARCHAR2 DEFAULT 'IT_PROG',
    p_salary IN NUMBER DEFAULT 5000
) IS
    e_zbyt_wysoka_pensja EXCEPTION;
BEGIN
    IF p_salary > 20000 THEN
        RAISE e_zbyt_wysoka_pensja;
    END IF;
    INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id, salary)
    VALUES (EMPLOYEES_SEQ.NEXTVAL, p_first_name, p_last_name, p_email, p_hire_date, p_job_id, p_salary);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pomyślnie dodano pracownika: ' || p_last_name);
EXCEPTION
    WHEN e_zbyt_wysoka_pensja THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: Wynagrodzenie ' || p_salary || ' przekracza dozwolony limit 20000!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił inny błąd: ' || SQLERRM);
END;
/
EXECUTE p_dodaj_pracownika(p_salary => 6000);
EXECUTE p_dodaj_pracownika(p_last_name => 'Bogacz', p_email => 'bogacz@test.com', p_salary => 25000);