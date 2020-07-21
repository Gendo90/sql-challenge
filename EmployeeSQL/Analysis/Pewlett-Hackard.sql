-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no","salary"
     )
);

CREATE TABLE "titles" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "emp_no","title"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- 1) Employee details: employee number, last name, first name, gender, and salary.
SELECT employees.emp_no, last_name, first_name, gender, salary
FROM employees
INNER JOIN salaries
ON employees.emp_no = salaries.emp_no

-- 2) Employees who were hired in 1986
SELECT first_name, last_name
FROM employees
WHERE extract(year FROM hire_date) = 1986;

-- 3) Manager information: department number, department name, the manager’s employee number, 
-- last name, first name, and start and end employment dates.
-- NOTE: The hire dates may be earlier than the employment end date of the previous 
-- department manager, because the employee was hired earlier and promoted to dept. manager
-- Also, the to_date value of 9999-01-01 means to-date or currently

SELECT dept_name, dept_manager.dept_no, employees.emp_no, last_name, first_name, hire_date, to_date
FROM dept_manager
INNER JOIN employees
ON dept_manager.emp_no = employees.emp_no
INNER JOIN departments
ON dept_manager.dept_no = departments.dept_no

-- 4) Employees with departments: employee number, last name, first name, and department name.

SELECT employees.emp_no, last_name, first_name, dept_name
FROM employees
INNER JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments
ON dept_emp.dept_no = departments.dept_no

-- 5) List employees with the first name "Hercules" whose last name starts with "B"

SELECT first_name, last_name 
FROM employees
where first_name = 'Hercules' AND last_name LIKE 'B%';

-- 6) List all employees in the Sales department: 
-- employee number, last name, first name, department name
-- This will list "CURRENT" employees in sales - given a "to_date"
-- of "9999-01-01" by selecting the year 9999 (which means current)
-- NOTE: You can find all the employees who were ever in sales by removing
-- the second condition to the "WHERE" statement (after the "AND") if necessary

SELECT employees.emp_no, last_name, first_name, dept_name
FROM employees
INNER JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Sales' AND extract(year FROM dept_emp.to_date) = 9999;

