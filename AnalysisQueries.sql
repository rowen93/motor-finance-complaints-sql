USE MotorFinanceComplaints
GO

--====================================================================================
--FINANCE AGREEMENT ANALYSIS
--====================================================================================

-- Total finance amount across all agreements --
SELECT SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements;


-- Total finance amount by finance type
SELECT FinanceType, SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements
GROUP BY FinanceType;


-- Toal finance amount by finance type for active agreements --
SELECT FinanceType, SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements
WHERE AgreementStatus = 'Active'
GROUP BY FinanceType
ORDER BY TotalFinanceAmount DESC;


-- Toal finance amount for active PCP agreements --
SELECT SUM (FinanceAmount) AS [Total PCP Finance Amount]
FROM FinanceAgreements
WHERE AgreementStatus = 'Active'
AND FinanceType = 'PCP';


-- Toal finance amount by agreement status --
SELECT AgreementStatus, SUM (FinanceAmount) AS TotalAmount
FROM FinanceAgreements
GROUP BY AgreementStatus
ORDER BY TotalAmount DESC;


-- Highest finance amount --
SELECT MAX (FinanceAmount) AS MaxFinanceAmount
FROM FinanceAgreements;


-- Lowest finance amounts for active agreements --
SELECT MIN (FinanceAmount) AS MinFinanceAmount
FROM FinanceAgreements 
WHERE AgreementStatus = 'Active';


-- Highest and lowest finance amount by finance type --
SELECT FinanceType, MAX (FinanceAmount) AS MaxAmount, 
MIN (FinanceAmount) AS MinAmount
FROM FinanceAgreements
GROUP BY FinanceType;


-- Average, highest and lowest finance amount by finance type --
SELECT FinanceType, AVG (FinanceAmount) AS AverageAmount, 
MAX (FinanceAmount) AS MaxAmount, 
MIN (FinanceAmount) AS MinAmount
FROM FinanceAgreements
GROUP BY FinanceType;


-- Finance Agreements between £15,000 and £25,000
SELECT *
FROM FinanceAgreements
WHERE FinanceAmount BETWEEN 15000 AND 25000;


-- Complaints received between June and Aug 2026, oldest first --
SELECT *
From Complaints
WHERE ComplaintDate BETWEEN '2026-06-01' AND '2026-08-31'
ORDER BY ComplaintDate ASC;


-- All resolved complaints received between June and Aug 2026, oldest first --
SELECT *
From Complaints
WHERE ComplaintDate BETWEEN '2026-06-01' AND '2026-08-31'
AND Status = 'Resolved'
ORDER BY ComplaintDate ASC;

--=========================================================================================
--COMPLAINT ANALYSIS --
--=========================================================================================

-- Total number of complaints --
SELECT COUNT (*) AS [Total Complaints]
FROM Complaints;


-- Total number of open complaints --
SELECT COUNT (*) AS [Total Open Complaints]
FROM Complaints
WHERE Status = 'Open';


-- Number of complaints by complaint type --
SELECT ComplaintType, COUNT (ComplaintType) AS [Total Complaints]
FROM Complaints
GROUP BY ComplaintType
ORDER BY [Total Complaints] DESC;


-- Resolved Complaints by outcome --
SELECT Outcome, COUNT (Outcome) AS [Total Complaints]
FROM Complaints
WHERE Status = 'Resolved'
GROUP BY Outcome;


-- Number of upheld complaints by complaint type, highest first --

SELECT ComplaintType, COUNT (*) AS TotalUpheld
FROM Complaints 
WHERE Outcome = 'Upheld'
GROUP BY ComplaintType
ORDER BY TotalUpheld DESC;


-- Resolved complaints for selected complaint types --
SELECT *
FROM Complaints
WHERE Status = 'Resolved' AND ComplaintType IN ('Affordability','Customer Service','Commission Disclosure')


-- Open or Upheld Complaints --
SELECT * 
FROM Complaints
WHERE Status = 'Open' OR Outcome = 'Upheld';

--==============================================================================================================
--JOIN ANALYSIS
--==============================================================================================================

-- Complaints with customers --
SELECT *
FROM Complaints
INNER JOIN Customers
ON Complaints.CustomerID = Customers.CustomerID;


-- Complaints with customer names --
SELECT comp.ComplaintID,
       comp.ComplaintType,
       comp.Status,
       cust.CustomerName
FROM Complaints AS comp
INNER JOIN Customers AS cust
ON comp.CustomerID = cust.CustomerID;


-- Finance Agreements with Customer Names --
SELECT fin.AgreementID,   
       fin.FinanceType,
       fin.FinanceAmount,
       cust.CustomerName
FROM FinanceAgreements AS fin
INNER JOIN Customers AS cust
ON fin.CustomerID = cust.CustomerID;


-- Complaint with associated finance agreements details --
SELECT fin.AgreementID,
       fin.FinanceType,
       fin.FinanceAmount,
       comp.ComplaintType,
       comp.Status,
       comp.ResolutionDate,
       comp.SLADueDate,
       comp.Outcome,
       comp.ComplaintDate
FROM FinanceAgreements AS fin
INNER JOIN Complaints AS comp
ON fin.AgreementID = comp.AgreementID;


-- Complaints with customer and finance agreement details 
SELECT fin.FinanceType,
       fin.FinanceAmount, 
       comp.ComplaintType,
       cust.CustomerName
FROM Customers AS cust
INNER JOIN FinanceAgreements AS fin
ON cust.CustomerID = fin.CustomerID
INNER JOIN Complaints AS comp
ON fin.AgreementID = comp.AgreementID;


-- Open complaints with customer and finance details -- 
SELECT fin.FinanceType,
       fin.FinanceAmount, 
       comp.ComplaintType,
       comp.Status,
       comp.SLADueDate,
       comp.ResolutionDate,
       comp.Outcome,
       cust.CustomerName
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS fin
ON fin.AgreementID = comp.AgreementID
INNER JOIN Customers AS Cust
ON fin.CustomerID = cust.CustomerID
WHERE comp.Status = 'Open';


-- Complaints with customer, vehicle and finance agreement details --
SELECT cust.CustomerName,
       veh.RegistrationPlate,
       fin.FinanceType,
       comp.ComplaintType,
       comp.Status,
       comp.SLADueDate,
       comp.Outcome
FROM Customers AS cust
INNER JOIN FinanceAgreements AS fin
ON cust.CustomerID = fin.CustomerID
INNER JOIN Complaints AS comp
ON fin.AgreementID = comp.AgreementID
INNER JOIN Vehicles AS veh
ON fin.VehicleID = veh.VehicleID;


-- Open PCP omplaints with customer, vehicle and finance agreement details, ordered by earliest SLA due date --
SELECT cust.CustomerName,
       veh.RegistrationPlate,
       fin.FinanceType,
       comp.ComplaintType,
       comp.Status,
       comp.SLADueDate,
       comp.Outcome
FROM Customers AS cust
INNER JOIN FinanceAgreements AS fin
ON cust.CustomerID = fin.CustomerID
INNER JOIN Complaints AS comp
ON fin.AgreementID = comp.AgreementID
INNER JOIN Vehicles AS veh
ON fin.VehicleID = veh.VehicleID
WHERE comp.Status = 'Open' AND fin.FinanceType = 'PCP'
ORDER BY comp.SLADueDate ASC;


-- Number of open complaints by finance type, highest first --
SELECT fin.FinanceType, COUNT (*) AS [Total Open Complaints]
FROM Customers AS cust
INNER JOIN FinanceAgreements AS fin
ON cust.CustomerID = fin.CustomerID
INNER JOIN Complaints AS comp
ON fin.AgreementID = comp.AgreementID
INNER JOIN Vehicles AS veh
ON fin.VehicleID = veh.VehicleID
WHERE comp.Status = 'Open' 
GROUP BY fin.FinanceType
ORDER BY [Total Open Complaints] DESC;


-- Resolved complaints with customer and finance details, newest first --
SELECT cust.CustomerName,
       fin.FinanceType,
       comp.ComplaintType,
       comp.Outcome,
       comp.ComplaintDate
FROM Customers AS cust
INNER JOIN FinanceAgreements AS fin
ON cust.CustomerID = fin.CustomerID
INNER JOIN Complaints AS comp
ON fin.AgreementID = comp.AgreementID
WHERE Status = 'Resolved'
ORDER BY ComplaintDate DESC;


-- Number of upheld complaints by complaint type, highest first --
SELECT ComplaintType, COUNT (*) AS TotalUpheld
FROM Complaints 
WHERE Outcome = 'Upheld'
GROUP BY ComplaintType
ORDER BY TotalUpheld DESC;


-- Number of upheld complaints by finance type, highest first -- 
SELECT fin.FinanceType, COUNT (*) AS [Total Upheld]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
ON fin.AgreementID = comp.AgreementID
WHERE comp.Outcome = 'Upheld'
GROUP BY fin.FinanceType
ORDER BY [Total Upheld] DESC;


-- Average finance amount for agreements with upheld complaints, highest first -- 
SELECT fin.FinanceType, AVG (fin.FinanceAmount) AS [Average Finance Amount]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
ON fin.AgreementID = comp.AgreementID
WHERE comp.Outcome = 'Upheld'
GROUP BY fin.FinanceType 
ORDER BY [Average Finance Amount] DESC;


--===============================================================================================================
-- CASE ANALYSIS
--===============================================================================================================

-- Catagorise finance agreements into low, medium and high value bands --
SELECT AgreementID, 
       FinanceType, 
       FinanceAmount,
CASE 
     WHEN FinanceAmount < 15000 THEN 'Low Value'
     WHEN FinanceAmount BETWEEN 15000 AND 25000 THEN 'Medium Value'
     ELSE 'High Value'
   END AS [Value Band]
FROM FinanceAgreements;


-- Catagorise finance agreements into lower, standard and high value band --
SELECT AgreementID,
       FinanceType,
       FinanceAmount,
  CASE 
     WHEN FinanceAmount < 20000 THEN 'Lower Value'
     WHEN FinanceAmount BETWEEN 20000 AND 30000 THEN 'Standard Value'
     ELSE 'Higher Value'
  END AS [Band Value]
FROM FinanceAgreements;


-- Upheld complaints by finance type and APR Band, highest first --
SELECT fin.FinanceType,
CASE 
    WHEN APR < 6 THEN 'Low APR'
    WHEN APR BETWEEN 6 AND 9 THEN 'Medium APR'
    ELSE 'High APR'
END AS [APR Band],
COUNT (*) AS [Total Upheld]
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS [fin]
        ON fin.AgreementID = comp.AgreementID
WHERE Outcome = 'Upheld'
GROUP BY fin.FinanceType,
CASE 
    WHEN fin.APR < 6 THEN 'Low APR'
    WHEN fin.APR BETWEEN 6 AND 9 THEN 'Medium APR'
    ELSE 'High APR'
END
ORDER BY [Total Upheld] DESC;


-- Groups upheld complaints by finance type and finance amount band to identify which agreement value ranges have the highest number 
-- of upheld complaints.

SELECT fin.FinanceType,
CASE 
   WHEN fin.FinanceAmount < 20000 THEN 'Lower Value'
   WHEN fin.FinanceAmount BETWEEN 20000 AND 30000 THEN 'Standard Value'
   ELSE 'Higher Value'
END AS [Band Value],
COUNT (*) AS [Total Upheld]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
   ON fin.AgreementID = comp.AgreementID
WHERE Outcome = 'Upheld'
GROUP BY fin.FinanceType,
CASE 
   WHEN fin.FinanceAmount < 20000 THEN 'Lower Value'
   WHEN fin.FinanceAmount BETWEEN 20000 AND 30000 THEN 'Standard Value'
   ELSE 'Higher Value'
END
ORDER BY [Total Upheld] DESC;


-- Groups resolved complaints by finance type and term length to show how many resolved complaints fall into each term band.
SELECT fin.FinanceType,
CASE  
   WHEN fin.TermMonths < 36 THEN 'Short Term'
   WHEN fin.TermMonths BETWEEN 36 AND 48 THEN 'Standard Term'
   ELSE 'Long Term'
END AS [Term Band],
COUNT (*) AS [Total Resolved]
FROM FinanceAgreements AS fin
INNER JOIN Complaints AS comp
   ON fin.AgreementID = comp.AgreementID
WHERE Status = 'Resolved'
GROUP BY FinanceType,
CASE  
   WHEN fin.TermMonths < 36 THEN 'Short Term'
   WHEN fin.TermMonths BETWEEN 36 AND 48 THEN 'Standard Term'
   ELSE 'Long Term'
END
ORDER BY [Total Resolved] DESC;


-- Resolved complaints by complaint type and APR band, highest first --
SELECT comp.ComplaintType,
CASE 
   WHEN fin.APR < 6 THEN 'Low APR'
   WHEN fin.APR BETWEEN 6 AND 9 THEN 'Medium APR'
   ELSE 'High APR'
END AS [APR Band],
COUNT (*) AS [Total Resolved]
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS fin 
   ON comp.AgreementID = fin.AgreementID
WHERE comp.Status = 'Resolved'
GROUP BY comp.ComplaintType,
CASE 
   WHEN APR < 6 THEN 'Low APR'
   WHEN APR BETWEEN 6 AND 9 THEN 'Medium APR'
   ELSE 'High APR'
END 
ORDER BY [Total Resolved] DESC;
-- Analysis: Early settlement complaints at Low APR had the highest number of resolved complaints (3).
-- Commission Disclosure at medium APR AND Affordability at High APR with (2) each.


-- Resolved complaints by finance type SLA performance, highest first --
SELECT FinanceType,
CASE 
   WHEN ResolutionDate <= SLADueDate THEN 'On Time'
   ELSE 'Late'
END AS [SLA Performance],
COUNT (*) AS [Total Resolved]
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS fin
   ON fin.AgreementID = comp.AgreementID
WHERE Status = 'Resolved'
GROUP BY fin.FinanceType,
CASE 
   WHEN ResolutionDate <= SLADueDate THEN 'On Time'
   ELSE 'Late'
END 
ORDER BY [Total Resolved] DESC; 
-- Analysis: PCP had the highest of resolved complaints completed on time (5) followed by HP (4). Late resolutions were lower
-- with (3) PCP complaints and (1) HP complaint.


-- Complaints by finance typeand APR Band, highest volume first --
SELECT fin.FinanceType, COUNT (*) AS [Total Complaints],
CASE 
  WHEN APR < 6 THEN 'Low APR'
  WHEN APR BETWEEN 6 AND 9 THEN 'Standard APR'
  ELSE 'High APR'
END AS [APR Banding]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
  ON fin.AgreementID = comp.AgreementID
GROUP BY fin.FinanceType,
CASE 
  WHEN APR < 6 THEN 'Low APR'
  WHEN APR BETWEEN 6 AND 9 THEN 'Standard APR'
  ELSE 'High APR'
END
ORDER BY [Total Complaints] DESC;
--Analysis: Standard APR agreements had the highest complaint volume (8), 
-- followed by Low APR (7) and high APR (5).
-- Standard APR complaints consisted of (7) PCP and (1) HP complaint.


-- Complaints by agreement term band, highest volume first --
SELECT 
CASE 
  WHEN TermMonths < 36 THEN 'Short Term'
  WHEN TermMonths BETWEEN 36 AND 48 THEN 'Standard Term'
  ELSE 'Long Term'
END AS [Term Band],
COUNT (*) AS [Total Complaints]
FROM FinanceAgreements AS fin
INNER JOIN Complaints AS comp 
  ON fin.AgreementID = comp.AgreementID
GROUP BY 
CASE 
  WHEN TermMonths < 36 THEN 'Short Term'
  WHEN TermMonths BETWEEN 36 AND 48 THEN 'Standard Term'
  ELSE 'Long Term'
END 
ORDER BY [Total Complaints] DESC;
-- Analysis: Standard Term agreements had the highest complaint volume (11)
-- followed by Long Term agreements (7) and Short Term agreements (2).


-- Resolved complaints by finance type and customer age band, highest first -- 
SELECT fin.FinanceType,
CASE 
   WHEN Age < 30 THEN 'Under 30'
   WHEN Age BETWEEN 30 AND 49 THEN '30-49'
   ELSE '50+'
END AS [Age Band],
COUNT (*) AS [Total Resolved Complaints]
FROM Customers AS cust 
INNER JOIN FinanceAgreements AS fin 
  ON cust.CustomerID = fin.CustomerID
INNER JOIN Complaints AS comp
  ON fin.AgreementID = comp.AgreementID
WHERE Status = 'Resolved'
GROUP BY fin.FinanceType,
CASE 
   WHEN Age < 30 THEN 'Under 30'
   WHEN Age BETWEEN 30 AND 49 THEN '30-49'
   ELSE '50+'
END
ORDER BY [Total Resolved Complaints] DESC;
-- Analysis: The 39-40 age band had the highest volume of resolved complaints (9 Total), 
-- with PCP (5) marginally higher than HP (4).
-- Under 30 had 3 resolved complaints (2 PCP and 1 HP).
-- The age 50+ age band had the lowest volume, with 1 resolved PCP complaint.


-- Resolved complaint SLA performance by complaint month, in chronological order --
SELECT 
CASE 
  WHEN ResolutionDate <= SLADueDate THEN 'On Time'
  ELSE 'Late'
END AS [SLA Performance],
DATENAME (MONTH,ComplaintDate) AS [Complaint Month],
COUNT (*) AS [Total Resolved Complaints]
FROM Complaints AS comp
WHERE Status = 'Resolved'
GROUP BY DATENAME (MONTH, ComplaintDate), MONTH(ComplaintDate),
CASE 
  WHEN ResolutionDate <= SLADueDate THEN 'On Time'
  ELSE 'Late'
END
ORDER BY MONTH(ComplaintDate);
-- Analysis: 9 of the 13 resolved complaints were completed on time, with 4 completed late.
-- April and June had no late resolved complaints, while late complaints appeared in March (1), June (1) and July (2).
-- July had the highest resolved complaint volume (5), with 3 completed on timeand 2 late.

-- Complaint volume by finance agreement value band, highest first --
SELECT 
CASE 
  WHEN fin.FinanceAmount < 15000 THEN 'Low Value'
  WHEN fin.FinanceAmount BETWEEN 15000 AND 25000 THEN 'Medium Value'
  ELSE 'High Value'
END AS [Value Band],
COUNT (*) AS [Total Complaints]
FROM FinanceAgreements AS fin
JOIN Complaints AS comp
  ON fin.AgreementID = comp.AgreementID
GROUP BY CASE 
  WHEN fin.FinanceAmount < 15000 THEN 'Low Value'
  WHEN fin.FinanceAmount BETWEEN 15000 AND 25000 THEN 'Medium Value'
  ELSE 'High Value'
END
ORDER BY [Total Complaints] DESC;
-- Analysis: medium value agreements had the highest complaint volume (9),
-- followed closely by high value agreements (8).
-- Low value agreements had the lowest complaint volume (3)
























