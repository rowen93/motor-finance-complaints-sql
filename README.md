### **Motor Finance Complaints – SQL Portfolio Project**



##### **Project Overview** 

###### I built this project to practise SQL using a fictional motor finance complaints database. I wanted to work with data that was similar to the information used in financial services and see how SQL could answer everyday reporting questions.

###### 

###### I created the database in SQL Server, added sample data and wrote queries in SQL Server Management Studio (SSMS). The SQL work is now ready for me to use as the starting point for a Power BI dashboard.



##### **Database**

###### The database has four linked tables:

###### \- Customers – customer details

###### \- Vehicles – vehicle information

###### \- FinanceAgreements – finance types, agreement values and dates

###### \- Complaints – complaint details, outcomes, statuses and SLA dates



###### The tables use primary and foreign keys to link the data together.



##### **What I've worked on**

###### I started with basic queries and gradually moved on to more involved reporting. The project includes:

###### \- Filtering, sorting and grouping data

###### \- COUNT, SUM, AVG and HAVING

###### \- INNER JOIN and LEFT JOIN

###### \- CASE statements and date calculations

###### \- Subqueries, EXISTS and NOT EXISTS

###### \- Common Table Expressions (CTEs)

###### \- Window functions including ROW\_NUMBER, RANK and DENSE\_RANK

###### \- Checking calculations where joins could cause duplicate rows



##### **Examples of the analysis**

###### I've used the data to look at complaint volumes, open and resolved complaints, outcomes, SLA performance and finance agreement values. I've also written queries to identify repeat complainants and each customer's most recent complaint.

###### 

###### One useful thing I learned was that joining finance agreements to complaints can give misleading averages when an agreement has more than one complaint. I went back through those queries and changed the approach so each agreement was only counted once where needed.

###### 

###### The queries include comments explaining the business question and what the results show.



##### **Files**

###### \- MotorFinanceComplaints.sql – database tables and relationships

###### \- SampleData.sql – fictional data used in the project

###### \- AnalysisQueries.sql – analysis queries and notes

###### \- README.md – project overview



##### **Next step**

###### I'm moving on to Power BI to turn the data into a dashboard showing complaint trends and performance. I'll continue improving my SQL as I work through that stage.



##### **Tools**

###### SQL Server · SSMS · Git · GitHub

