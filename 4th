-- Step 1: Create Database
CREATE DATABASE emp_company_db;
USE emp_company_db;

-- Step 2: Create Tables

CREATE TABLE emp (
    eid INT PRIMARY KEY,
    ename VARCHAR(50),
    street VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE company (
    company_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50)
);

CREATE TABLE works (
    eid INT,
    company_name VARCHAR(50),
    salary INT,
    PRIMARY KEY (eid, company_name),
    FOREIGN KEY (eid) REFERENCES emp(eid),
    FOREIGN KEY (company_name) REFERENCES company(company_name)
);

CREATE TABLE manages (
    eid INT PRIMARY KEY,
    manager_id INT,
    FOREIGN KEY (eid) REFERENCES emp(eid),
    FOREIGN KEY (manager_id) REFERENCES emp(eid)
);

-- Step 3: Insert Sample Data

INSERT INTO emp VALUES
(1, 'Prashant', 'MG Road', 'Pune'),
(2, 'Amit', 'FC Road', 'Pune'),
(3, 'Neha', 'Link Road', 'Mumbai'),
(4, 'Rahul', 'Main Street', 'Delhi');

INSERT INTO company VALUES
('Infosys', 'Pune'),
('TCS', 'Mumbai'),
('Accenture', 'Bangalore');

INSERT INTO works VALUES
(1, 'Infosys', 25000),
(2, 'Infosys', 18000),
(3, 'TCS', 30000),
(4, 'Accenture', 40000);

INSERT INTO manages VALUES
(1, 2),
(3, 4);

-- =====================================================
-- QUERIES
-- =====================================================

-- 1. Update company of employee 'Prashant' from Infosys to TCS

UPDATE works
SET company_name = 'TCS'
WHERE eid = (
    SELECT eid FROM emp WHERE ename = 'Prashant'
)
AND company_name = 'Infosys';

-- 2. Names & cities of employees working for Infosys

SELECT e.ename, e.city
FROM emp e
JOIN works w ON e.eid = w.eid
WHERE w.company_name = 'Infosys';

-- 3. Names & street of employees who work in TCS cities and earn > 20000

SELECT e.ename, e.street
FROM emp e
JOIN works w ON e.eid = w.eid
JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'TCS'
AND w.salary > 20000;

-- 4. Employees who do NOT work for Infosys

SELECT ename
FROM emp
WHERE eid NOT IN (
    SELECT eid FROM works WHERE company_name = 'Infosys'
);

-- 5. Company-wise total salary

SELECT company_name, SUM(salary) AS total_salary
FROM works
GROUP BY company_name;

-- 6. Employees who work for Accenture

SELECT e.ename
FROM emp e
JOIN works w ON e.eid = w.eid
WHERE w.company_name = 'Accenture';
