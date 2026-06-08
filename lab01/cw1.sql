CREATE TABLE REGIONS (
    region_id NUMBER PRIMARY KEY,
    region_name VARCHAR2(50)
);

CREATE TABLE COUNTRIES (
    country_id CHAR(2) PRIMARY KEY,
    country_name VARCHAR2(50),
    region_id NUMBER
);

CREATE TABLE LOCATIONS (
    location_id NUMBER PRIMARY KEY,
    street_address VARCHAR2(100),
    postal_code VARCHAR2(20),
    city VARCHAR2(50),
    state_province VARCHAR2(50),
    country_id CHAR(2)
);

CREATE TABLE JOBS (
    job_id VARCHAR2(10) PRIMARY KEY,
    job_title VARCHAR2(50) NOT NULL,
    min_salary NUMBER,
    max_salary NUMBER,
    CONSTRAINT chk_salary CHECK (max_salary - min_salary >= 2000)
);

CREATE TABLE DEPARTMENTS (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL,
    location_id NUMBER
);

CREATE TABLE EMPLOYEES (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(50) UNIQUE,
    phone_number VARCHAR2(20),
    hire_date DATE NOT NULL,
    job_id VARCHAR2(10),
    salary NUMBER,
    commission_pct NUMBER,
    manager_id NUMBER,
    department_id NUMBER
);

CREATE TABLE JOB_HISTORY (
    employee_id NUMBER,
    start_date DATE,
    end_date DATE,
    job_id VARCHAR2(10),
    department_id NUMBER,
    PRIMARY KEY (employee_id, start_date)
);

ALTER TABLE DEPARTMENTS ADD manager_id NUMBER;

ALTER TABLE COUNTRIES ADD CONSTRAINT fk_countr_reg FOREIGN KEY (region_id) REFERENCES REGIONS(region_id);

ALTER TABLE LOCATIONS ADD CONSTRAINT fk_loc_countr FOREIGN KEY (country_id) REFERENCES COUNTRIES(country_id);

ALTER TABLE DEPARTMENTS ADD CONSTRAINT fk_dept_loc FOREIGN KEY (location_id) REFERENCES LOCATIONS(location_id);

ALTER TABLE DEPARTMENTS ADD CONSTRAINT fk_dept_mgr FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id);

ALTER TABLE EMPLOYEES ADD CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);

ALTER TABLE EMPLOYEES ADD CONSTRAINT fk_emp_job FOREIGN KEY (job_id) REFERENCES JOBS(job_id);

ALTER TABLE EMPLOYEES ADD CONSTRAINT fk_emp_mgr FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id);

ALTER TABLE JOB_HISTORY ADD CONSTRAINT fk_jh_emp FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id);

ALTER TABLE JOB_HISTORY ADD CONSTRAINT fk_jh_job FOREIGN KEY (job_id) REFERENCES JOBS(job_id);

ALTER TABLE JOB_HISTORY ADD CONSTRAINT fk_jh_dept FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id);