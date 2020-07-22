

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

-- 7) List all employees in the Sales and Development departments, include: 
-- employee number, last name, first name, and department name
-- NOTE: This query will return all 'current' employees in those departments
-- by selecting only those employees with the 'to_date' (end employment date)
-- in the year 9999

SELECT employees.emp_no, last_name, first_name, dept_name
FROM employees
INNER JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
INNER JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE (dept_name = 'Sales' OR dept_name = 'Development') 
AND extract(year FROM dept_emp.to_date) = 9999;

-- 8) List frequency count of employee last names in descending order

SELECT last_name, COUNT(last_name)
FROM employees
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;

