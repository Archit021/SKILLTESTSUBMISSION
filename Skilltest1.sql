

CREATE TABLE Employee_Details (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    job_title VARCHAR(100),
    performance_score FLOAT
);


CREATE TABLE Project_Assignments (
    project_id INT PRIMARY KEY,
    employee_id INT,
    project_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    project_status VARCHAR(50),
    client_name VARCHAR(100),
    budget FLOAT,
    team_size INT,
    manager_id INT,
    technologies_used VARCHAR(255),
    location VARCHAR(100),
    hours_worked FLOAT,
    milestones_achieved INT,
    risks_identified TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employee_Details(employee_id)
);

CREATE TABLE Attendance_Records (
    record_id INT PRIMARY KEY,
    employee_id INT,
    date DATE,
    hours_worked FLOAT,
    leaves_taken INT,
    feedback TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employee_Details(employee_id)
);

CREATE TABLE Training_Programs (
    training_id INT PRIMARY KEY,
    employee_id INT,
    training_name VARCHAR(100),
    training_date DATE,
    feedback_score INT,
    technologies_learned VARCHAR(255),
    FOREIGN KEY (employee_id) REFERENCES Employee_Details(employee_id)
);
/*1.1 Employee Productivity analysis
*/
SELECT employee_id, 
       SUM(hours_worked) AS total_hours_worked, 
       SUM(CASE WHEN leaves_taken = 0 THEN 1 ELSE 0 END) AS attendance_score 
FROM Attendance_Records 
GROUP BY employee_id 
LIMIT 0, 1000;

/* 1.2 Departmental training impact:
*/

CREATE TABLE department (
    department_id INT PRIMARY KEY,     
    department_name VARCHAR(255)       
);

select database ();

Describe department;

SELECT d.department_id, 
       AVG(t.feedback_score) AS avg_training_score, 
       AVG(e.performance_score) AS avg_performance_score
FROM Employee_Details e
JOIN Training_Programs t ON e.employee_id = t.employee_id
JOIN Department d ON e.department_id = d.department_id
GROUP BY d.department_id
LIMIT 0, 1000;

/* 1.3 Project Budget efficency:
*/
SELECT 
    p.project_id, 
    p.project_name, 
    (p.budget / SUM(a.hours_worked)) AS cost_per_hour 
FROM 
    Project_Assignments p 
JOIN 
    Attendance_Records a 
ON 
    p.employee_id = a.employee_id 
GROUP BY 
    p.project_id 
LIMIT 0, 1000;

/* 1.4 Attendance Consistency:
*/
SELECT department_id, AVG(hours_worked) AS avg_hours_worked, 
       AVG(CASE WHEN leaves_taken > 0 THEN 1 ELSE 0 END) AS absenteeism
FROM Attendance_Records
JOIN Employee_Details e ON Attendance_Records.employee_id = e.employee_id
GROUP BY department_id;

/* 1.5 High-Impact Employees in Projects:
*/
SELECT p.employee_id, e.employee_name, SUM(p.budget) AS total_project_budget, e.performance_score
FROM Project_Assignments p
JOIN Employee_Details e ON p.employee_id = e.employee_id
GROUP BY p.employee_id
ORDER BY total_project_budget DESC, e.performance_score DESC;









