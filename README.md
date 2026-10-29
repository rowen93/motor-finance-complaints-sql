###### motor-finance-complaints-SQL Portfolio Project

###### 

###### **Project Overview**

###### 

This project demonstrates the design and development of a fictional motor finance complaints database using Microsoft SQL Server and SQL Server Management Studio (SSMS).

The project focuses on relational database design, SQL querying and data analysis, using realistic business scenarios to investigate complaint trends, finance agreements and operational performance.

It is an ongoing portfolio project designed to develop practical SQL skills and demonstrate how data can support business decision-making and Management Information (MI) reporting.

###### 

###### Database Structure



The database contains four related tables:



**Customers** – Customer information

**Vehicles** – Vehicle details

**FinanceAgreements** – Motor finance agreement details

**Complaints** – Complaint records, including SLA tracking



The tables are connected using primary and foreign keys, allowing information to be combined for business analysis and reporting.

###### 

###### **SQL Skills Demonstrated**

###### 

* Database creation and relational table design
* Primary and foreign keys
* Data insertion and handling NULL values
* SELECT, WHERE and ORDER BY
* Aggregate functions including COUNT, SUM and AVG
* GROUP BY and HAVING
* INNER JOIN and LEFT JOIN
* CASE expressions and conditional analysis
* Date calculations using DATEDIFF
* SLA compliance and resolution-time analysis
* Window functions using OVER and PARTITION BY
* Windowed totals, counts and averages
* ROW\_NUMBER, RANK and DENSE\_RANK
* Subqueries, including correlated subqueries
* EXISTS, NOT EXISTS and IN
* Common Table Expressions (CTEs)
* Multiple CTEs within a single query
* Combining CTEs with joins and aggregate functions
* CASE WHEN EXISTS for conditional classification
* COALESCE for handling NULL results
* Identifying and correcting aggregate calculations affected by one-to-many joins

###### 

###### **Business Analysis Completed**



SQL queries have been developed to investigate:



* Complaint volumes, types and outcomes
* Open and resolved complaints
* Complaints associated with different finance types
* Finance agreement values and comparisons
* Agreements with and without complaints
* SLA compliance, including on-time and late resolutions
* Complaint resolution times and customer-level averages
* Customer complaint histories and latest complaints
* Finance agreement rankings, including tied values
* Average finance amounts by finance type
* Complaint totals and finance averages using multiple CTEs
* Finance agreements associated with resolved complaints
* Differences in average finance values between agreements with and without complaints

###### 

The queries include business requests and analysis comments to explain their purpose, approach and findings.

###### 

###### **Data Quality and Query Corrections**

###### 

As part of the project's ongoing development, earlier SQL queries were revisited to investigate potential inaccuracies in aggregate calculations.



Two queries were identified where joining FinanceAgreements to Complaints caused agreements with multiple complaints to appear more than once, potentially distorting average finance amounts.



**Correction 1** – Average Finance Amount by Finance Type

The original query calculated average finance amounts for agreements associated with resolved complaints.

A CTE and correlated EXISTS subquery were used to ensure each qualifying finance agreement contributed only once to the average.



**Correction 2** – Agreements With and Without Complaints

The original query compared average finance amounts between agreements with complaints and agreements without complaints.

The initial average for agreements with complaints was £23,190.00.

After correcting the calculation using a CTE and CASE WHEN EXISTS, the average was £22,493.33, a reduction of £696.67.

The average for agreements without complaints remained unchanged at £15,250.00.



These corrections demonstrate the importance of validating query results, understanding one-to-many relationships and ensuring aggregate calculations accurately represent the underlying data.

###### 

###### **Repository Files**



**MotorFinanceComplaints.sql** – Database structure and setup



**SampleData.sql** – Fictional sample data



**AnalysisQueries.sql** – SQL analysis queries, business requests and documented findings



**README.md** – Project overview and progress

###### 

###### **Current Progress**

###### 

Completed database design, sample data creation, core SQL querying, joins, conditional analysis, date-based SLA reporting and window functions.

Developed further querying skills using subqueries, correlated subqueries, EXISTS, NOT EXISTS and CTEs.

Completed initial data-quality investigations and corrected two earlier queries where one-to-many joins affected average finance calculations.

Further practice is ongoing to strengthen confidence in combining advanced SQL techniques.



###### **Planned Enhancements**

###### 

Further development of the project will focus on:

###### 

* Consolidating CTEs, correlated subqueries and conditional logic
* Combining CTEs with window functions for more complex reporting
* Further business-style analysis and MI reporting
* Reviewing and refining the SQL dataset for Power BI integration
* Developing a Power BI dashboard to present key complaint trends and performance metrics

###### 

###### **Tools Used**

###### 

* Microsoft SQL Server
* SQL Server Management Studio (SSMS)
* Git
* GitHub
* Project Status

###### 

**In progress** – Core SQL analysis, window functions, subqueries and initial CTE exercises completed. Continuing advanced query practice, data validation and preparation for Power BI reporting.

