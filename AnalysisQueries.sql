USE MotorFinanceComplaints
GO

--====================================================================================
--FINANCE AGREEMENT ANALYSIS
--====================================================================================

-- Total finance amount across all agreements --
SELECT SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements;


-- Total finance amount by finance type
SELECT FinanceType, 
       SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements
GROUP BY FinanceType;


-- Toal finance amount by finance type for active agreements --
SELECT FinanceType, 
       SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements
WHERE AgreementStatus = 'Active'
GROUP BY FinanceType
ORDER BY TotalFinanceAmount DESC;


-- Toal finance amount for active PCP agreements --
SELECT SUM (FinanceAmount) AS [Total PCP Finance Amount]
FROM FinanceAgreements
WHERE AgreementStatus = 'Active'
AND FinanceType = 'PCP';


-- Total finance amount by agreement status --
SELECT AgreementStatus, 
       SUM (FinanceAmount) AS TotalAmount
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
SELECT FinanceType, 
       MAX (FinanceAmount) AS MaxAmount, 
       MIN (FinanceAmount) AS MinAmount
FROM FinanceAgreements
GROUP BY FinanceType;


-- Average, highest and lowest finance amount by finance type --
SELECT FinanceType, 
       AVG (FinanceAmount) AS AverageAmount, 
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
FROM Complaints
WHERE ComplaintDate BETWEEN '2026-06-01' AND '2026-08-31'
ORDER BY ComplaintDate ASC;


-- All resolved complaints received between June and Aug 2026, oldest first --
SELECT *
FROM Complaints
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
SELECT fin.FinanceType, 
       COUNT (*) AS [Total Open Complaints]
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
SELECT ComplaintType, 
       COUNT (*) AS TotalUpheld
FROM Complaints 
WHERE Outcome = 'Upheld'
GROUP BY ComplaintType
ORDER BY TotalUpheld DESC;


-- Number of upheld complaints by finance type, highest first -- 
SELECT fin.FinanceType, 
       COUNT (*) AS [Total Upheld]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
      ON fin.AgreementID = comp.AgreementID
WHERE comp.Outcome = 'Upheld'
GROUP BY fin.FinanceType
ORDER BY [Total Upheld] DESC;


-- Average finance amount for agreements with upheld complaints, highest first -- 
SELECT fin.FinanceType, 
       AVG (fin.FinanceAmount) AS [Average Finance Amount]
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
        WHEN FinanceAmount < 15000 
          THEN 'Low Value'
        WHEN FinanceAmount BETWEEN 15000 AND 25000 
          THEN 'Medium Value'
        ELSE 'High Value'
      END AS [Value Band]
FROM FinanceAgreements;


-- Catagorise finance agreements into lower, standard and high value band --
SELECT AgreementID,
       FinanceType,
       FinanceAmount,
       CASE 
         WHEN FinanceAmount < 20000 
           THEN 'Lower Value'
         WHEN FinanceAmount BETWEEN 20000 AND 30000 
           THEN 'Standard Value'
         ELSE 'Higher Value'
       END AS [Band Value]
FROM FinanceAgreements;


-- Upheld complaints by finance type and APR Band, highest first --
SELECT fin.FinanceType,
       CASE 
         WHEN APR < 6 
           THEN 'Low APR'
         WHEN APR BETWEEN 6 AND 9 
           THEN 'Medium APR'
         ELSE 'High APR'
       END AS [APR Band],
       COUNT (*) AS [Total Upheld]
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS [fin]
        ON fin.AgreementID = comp.AgreementID
WHERE Outcome = 'Upheld'
GROUP BY fin.FinanceType,
CASE 
         WHEN APR < 6 
           THEN 'Low APR'
         WHEN APR BETWEEN 6 AND 9 
           THEN 'Medium APR'
         ELSE 'High APR'
       END
ORDER BY [Total Upheld] DESC;


-- Groups upheld complaints by finance type and finance amount band to identify which agreement value ranges have the highest number 
-- of upheld complaints.
SELECT fin.FinanceType,
       CASE 
         WHEN fin.FinanceAmount < 20000 
           THEN 'Lower Value'
         WHEN fin.FinanceAmount BETWEEN 20000 AND 30000 
           THEN 'Standard Value'
         ELSE 'Higher Value'
       END AS [Band Value],
       COUNT (*) AS [Total Upheld]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
       ON fin.AgreementID = comp.AgreementID
WHERE Outcome = 'Upheld'
GROUP BY fin.FinanceType,
         CASE 
         WHEN fin.FinanceAmount < 20000 
           THEN 'Lower Value'
         WHEN fin.FinanceAmount BETWEEN 20000 AND 30000 
           THEN 'Standard Value'
         ELSE 'Higher Value'
       END
ORDER BY [Total Upheld] DESC;


-- Groups resolved complaints by finance type and term length to show how many resolved complaints fall into each term band.
SELECT fin.FinanceType,
       CASE  
         WHEN fin.TermMonths < 36 
           THEN 'Short Term'
         WHEN fin.TermMonths BETWEEN 36 AND 48 
           THEN 'Standard Term'
          ELSE 'Long Term'
        END AS [Term Band],
        COUNT (*) AS [Total Resolved]
FROM FinanceAgreements AS fin
INNER JOIN Complaints AS comp
       ON fin.AgreementID = comp.AgreementID
WHERE Status = 'Resolved'
GROUP BY FinanceType,
         CASE  
           WHEN fin.TermMonths < 36 
             THEN 'Short Term'
           WHEN fin.TermMonths BETWEEN 36 AND 48 
             THEN 'Standard Term'
           ELSE 'Long Term'
         END
ORDER BY [Total Resolved] DESC;


-- Resolved complaints by complaint type and APR band, highest first --
SELECT comp.ComplaintType,
       CASE 
         WHEN fin.APR < 6 
           THEN 'Low APR'
         WHEN fin.APR BETWEEN 6 AND 9 
           THEN 'Medium APR'
         ELSE 'High APR'
       END AS [APR Band],
       COUNT (*) AS [Total Resolved]
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS fin 
       ON comp.AgreementID = fin.AgreementID
WHERE comp.Status = 'Resolved'
GROUP BY comp.ComplaintType,
         CASE 
           WHEN APR < 6 
             THEN 'Low APR'
           WHEN APR BETWEEN 6 AND 9 
             THEN 'Medium APR'
           ELSE 'High APR'
         END 
ORDER BY [Total Resolved] DESC;
-- Analysis: Early settlement complaints at Low APR had the highest number of resolved complaints (3).
-- Commission Disclosure at medium APR AND Affordability at High APR with (2) each.


-- Resolved complaints by finance type SLA performance, highest first --
SELECT FinanceType,
       CASE 
         WHEN ResolutionDate <= SLADueDate 
           THEN 'On Time'
         ELSE 'Late'
       END AS [SLA Performance],
       COUNT (*) AS [Total Resolved]
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS fin
       ON fin.AgreementID = comp.AgreementID
WHERE Status = 'Resolved'
GROUP BY fin.FinanceType,
         CASE 
           WHEN ResolutionDate <= SLADueDate 
             THEN 'On Time'
           ELSE 'Late'
         END 
ORDER BY [Total Resolved] DESC; 
-- Analysis: PCP had the highest of resolved complaints completed on time (5) followed by HP (4). Late resolutions were lower
-- with (3) PCP complaints and (1) HP complaint.


-- Complaints by finance typeand APR Band, highest volume first --
SELECT fin.FinanceType, 
       COUNT (*) AS [Total Complaints],
       CASE 
         WHEN APR < 6 
           THEN 'Low APR'
         WHEN APR BETWEEN 6 AND 9 
           THEN 'Standard APR'
         ELSE 'High APR'
       END AS [APR Banding]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
      ON fin.AgreementID = comp.AgreementID
GROUP BY fin.FinanceType,
        CASE 
          WHEN APR < 6 
            THEN 'Low APR'
          WHEN APR BETWEEN 6 AND 9 
            THEN 'Standard APR'
          ELSE 'High APR'
        END
ORDER BY [Total Complaints] DESC;
--Analysis: Standard APR agreements had the highest complaint volume (8), 
-- followed by Low APR (7) and high APR (5).
-- Standard APR complaints consisted of (7) PCP and (1) HP complaint.


-- Complaints by agreement term band, highest volume first --
SELECT 
    CASE 
      WHEN TermMonths < 36 
        THEN 'Short Term'
      WHEN TermMonths BETWEEN 36 AND 48 
        THEN 'Standard Term'
      ELSE 'Long Term'
    END AS [Term Band],
    COUNT (*) AS [Total Complaints]
FROM FinanceAgreements AS fin
INNER JOIN Complaints AS comp 
    ON fin.AgreementID = comp.AgreementID
GROUP BY 
    CASE 
      WHEN TermMonths < 36 
        THEN 'Short Term'
      WHEN TermMonths BETWEEN 36 AND 48 
        THEN 'Standard Term'
      ELSE 'Long Term'
    END 
ORDER BY [Total Complaints] DESC;
-- Analysis: Standard Term agreements had the highest complaint volume (11)
-- followed by Long Term agreements (7) and Short Term agreements (2).


-- Resolved complaints by finance type and customer age band, highest first -- 
SELECT fin.FinanceType,
       CASE 
         WHEN Age < 30 
           THEN 'Under 30'
         WHEN Age BETWEEN 30 AND 49 
           THEN '30-49'
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
           WHEN Age < 30 
             THEN 'Under 30'
           WHEN Age BETWEEN 30 AND 49 
             THEN '30-49'
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
      WHEN ResolutionDate <= SLADueDate 
        THEN 'On Time'
      ELSE 'Late'
    END AS [SLA Performance],
    DATENAME (MONTH,ComplaintDate) AS [Complaint Month],
    COUNT (*) AS [Total Resolved Complaints]
FROM Complaints AS comp
WHERE Status = 'Resolved'
GROUP BY DATENAME (MONTH, ComplaintDate), MONTH(ComplaintDate),
    CASE 
      WHEN ResolutionDate <= SLADueDate 
        THEN 'On Time'
      ELSE 'Late'
    END
ORDER BY MONTH(ComplaintDate);
-- Analysis: 9 of the 13 resolved complaints were completed on time, with 4 completed late.
-- April and June had no late resolved complaints, while late complaints appeared in March (1), June (1) and July (2).
-- July had the highest resolved complaint volume (5), with 3 completed on timeand 2 late.

-- Complaint volume by finance agreement value band, highest first --
SELECT 
    CASE 
      WHEN fin.FinanceAmount < 15000 
        THEN 'Low Value'
      WHEN fin.FinanceAmount BETWEEN 15000 AND 25000 
        THEN 'Medium Value'
      ELSE 'High Value'
    END AS [Value Band],
    COUNT (*) AS [Total Complaints]
FROM FinanceAgreements AS fin
JOIN Complaints AS comp
  ON fin.AgreementID = comp.AgreementID
GROUP BY 
    CASE 
      WHEN fin.FinanceAmount < 15000 
        THEN 'Low Value'
      WHEN fin.FinanceAmount BETWEEN 15000 AND 25000 
        THEN 'Medium Value'
      ELSE 'High Value'
    END
ORDER BY [Total Complaints] DESC;
-- Analysis: medium value agreements had the highest complaint volume (9),
-- followed closely by high value agreements (8).
-- Low value agreements had the lowest complaint volume (3)


-- Business request: 
-- Show all finance agreements and any associated complaints,
-- including agreements that have never received a complaint.
SELECT fin.AgreementID,
       fin.FinanceType,
       comp.ComplaintID
FROM FinanceAgreements AS fin 
LEFT JOIN Complaints AS comp 
  ON fin.AgreementID = comp.AgreementID;
-- Analysis:
-- The LEFT JOIN returned all finance agreements, including those without a matching complaint.
-- Agreements 16 and 17 have no associated complaint and therefore return NULL for ComplaintID.
-- Agreements with multiple complaints appear more than once, with one row returned for each associated complaint.

-- Business request:
-- Show all finance agreements that have no associated complaint.
SELECT fin.AgreementID,
       fin.FinanceType,
       comp.ComplaintID
FROM FinanceAgreements AS fin 
LEFT JOIN Complaints AS comp 
  ON fin.AgreementID = comp.AgreementID
WHERE ComplaintID IS NULL;
-- Analysis:
-- Two finance agreements have no associated complaint:
-- One PCP agreement and one HP agreement.

-- Business Request:
-- Show all customers and their registered vehicle,
-- including customers who don't have a vehicle recorded.
SELECT cust.CustomerID,
       cust.CustomerName,
       veh.RegistrationPlate
FROM Customers AS cust
LEFT JOIN Vehicles AS veh
  ON cust.CustomerID = veh.CustomerID;
-- Analysis:
-- All 15 customers currently have a registered vehicle.
-- No customers returned a NULL RegistrationPlate. 

-- Business request:
-- Show the number of complaints associated with each finance type,
-- While including all finance agreements in the analysis.
SELECT fin.FinanceType,
       COUNT (comp.ComplaintID) AS [Total Complaints]
FROM FinanceAgreements AS fin 
LEFT JOIN Complaints AS comp
  ON fin.AgreementID = comp.AgreementID
GROUP BY FinanceType;
-- Analysis
-- PCP agreements had the highest complaint volume with 14 complaints,
-- compared with 6 complaints associated with HP agreements.


-- Business request:
-- Identify all finance agreements that never recieved a complaint,
-- including the finance type, amount and current agreement status.
SELECT fin.AgreementID,
       fin.FinanceType,
       fin.FinanceAmount,
       fin.AgreementStatus
FROM FinanceAgreements AS fin
LEFT JOIN Complaints AS comp
     ON fin.AgreementID = comp.AgreementID
WHERE comp.ComplaintID IS NULL;


-- Analysis:
-- Two finance agreements have no associated complaint.
-- Agreement 16 is an active PCP agreement for £18,000.
-- Agreement 17 is a settled HP agreement for £12,500.

-- Business request:
-- Compare the average value of finance agreements that have received 
-- complaints with those that have not recieved a complaint.
SELECT 
    CASE 
      WHEN comp.ComplaintID IS NOT NULL 
       THEN 'Has Complaint'
      ELSE 'No Complaint'
    END AS [Complaint Status],
    AVG (fin.FinanceAmount) AS [Average Finance Amount]
FROM FinanceAgreements AS fin
LEFT JOIN Complaints AS comp 
    ON fin.AgreementID = comp.AgreementID
GROUP BY 
    CASE 
      WHEN comp.ComplaintID IS NOT NULL 
       THEN 'Has Complaint'
      ELSE 'No Complaint'
    END
ORDER BY [Average Finance Amount] DESC;
-- Analysis:
--Agreements with no complaint had an average finance amount of £15,250.
-- The initial average for agreements with complaints was £23,190.
-- However, agreements with multiple complaints appear more tha once 
-- following the JOIN, which can affect the calculated average.
-- Further analysis is required to calculate the average using each 
-- finance agreement only once.

--======================================================================================================================
-- HAVING AND JOINS 
--======================================================================================================================

-- Business request:
-- Identify complaint types with more than 4 complaints.
SELECT ComplaintType,
       COUNT (*) AS [Total Complaints]
FROM Complaints
GROUP BY ComplaintType
HAVING COUNT (*) > 4;
-- Analysis:
-- Affordability and Customer Service had the highest number of complaint volumes,
-- with 5 complaints each
-- No other complaint types had more than 4 complaints.


-- Business request:
-- Identify complaint types with more than 2 resolved complaints.
SELECT ComplaintType,
       COUNT (*) AS [Resolved Complaints]
FROM Complaints 
WHERE Status = 'Resolved'
GROUP BY ComplaintType 
HAVING COUNT (*) > 2;
-- Analysis:
-- Affordability, Commission Disclosure and Early Settlement
-- each had 3 resolved complaints.
-- No other complaint types had more than 2 resolved complaints.


-- Business request:
-- Review active finance agreements by finance type and show the average amount,
-- including only finance types where the average value is greater than £20,000.
SELECT FinanceType,
       AVG (FinanceAmount) AS [Average Finance Amount]
FROM FinanceAgreements
WHERE AgreementStatus = 'Active'
GROUP BY FinanceType
HAVING AVG (FinanceAmount) > 20000;
-- Analysis:
-- PCP was the only finance type with an average finance amount greater than £20,000,
-- with an average value of approximatley £23,043.
-- HP had an average finance amount below £20,000 and therefore excluded from the results.


-- Business request:
-- Review settled finance agreements by finance type and show the total amount,
-- including only finance types where the total value is greater than £40,000.
SELECT FinanceType,
       SUM (FinanceAmount) AS [Total Finance Amount]
FROM FinanceAgreements
WHERE AgreementStatus = 'Settled'
GROUP BY FinanceType
HAVING SUM (FinanceAmount) > 40000;
-- Analysis:
-- Both PCP and HP had a Total Finance Amount above 40,000
-- PCP had the highest total finance amount at £84,500.
-- HP had a total finance amount of £47,100


-- Business request:
-- Compare complaint volumes by finance type and show the number of complaints associated
-- with each type, including only finance types with more than 10 complaints
SELECT fin.FinanceType, 
       COUNT (*) AS [Total Complaints]
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS fin
      ON comp.AgreementID = fin.AgreementID
GROUP BY fin.FinanceType
HAVING COUNT (*) > 10;
-- Analysis:
-- PCP was the only finance type with more than 10 complaints,
-- with a total of 14 complaints.
-- HP did not meet the threshold and was therefore excluded from the results.


-- Business request:
-- Review complaints by finance type and show the number of resolved complaints 
-- associated with each type, including only finance types with more than 3 resolved complaints.
SELECT fin.FinanceType,
       COUNT (*) AS [Total Resolved Complaints]
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS fin 
      ON comp.AgreementID = fin.AgreementID 
WHERE comp.Status = 'Resolved'
GROUP BY fin.FinanceType
HAVING COUNT (*) >3;
-- Analysis:
-- PCP and HP both are over the threshold of 3 resolved complaints.
-- PCP has the highest volume of complaints (8).
-- HP has 5 complaints.


-- Business reqiest:
-- Review all finance agreements by finance type and show the number of 
-- complaints associated with each type, including agreements with no complaint.
-- Only include finance types with more than 5 complaints.
SELECT fin.FinanceType,
       COUNT (comp.ComplaintID) AS [Total Complaints]
FROM FinanceAgreements AS fin 
LEFT JOIN Complaints AS comp
     ON fin.AgreementID = comp.AgreementID
GROUP BY fin.FinanceType
HAVING COUNT (comp.ComplaintID) > 5;
-- Analysis:
-- Both HP and PCP have more than 5 associated complaints. 
-- PCP had the highest complaint volume, with 14 complaints.
-- HP had 6 complaints.


-- Business request:
-- Group complaints by the value of the associated finance agreement.
-- Agreements below £20,000 are classed as Lower Value and agreements
-- of £20,000 or more are classed as Higher Value.
-- Only include value bands with more than 5 complaints.
SELECT
    CASE 
      WHEN fin.FinanceAmount < 20000 
       THEN 'Lower Value'
      ELSE 'Higher Value'
    END AS [Value Band],
    COUNT (comp.ComplaintID) AS [Total Complaints]
FROM FinanceAgreements AS fin 
LEFT JOIN Complaints AS comp
     ON fin.AgreementID = comp.AgreementID 
GROUP BY 
   CASE 
     WHEN fin.FinanceAmount < 20000 THEN 'Lower Value'
    ELSE 'Higher Value'
   END
HAVING COUNT (comp.ComplaintID) > 5;
-- Analysis:
-- Both the Higher Value and Lower Value bands met the threshold of more than 5 complaints.
-- Higher Value Band had the highest complaint volume, with 14 complaints.
-- Lower Value Band had 6 complaints.


-- Business request:
-- Review resolved complaints by finance type. Show the average finance amount 
-- associated with resolved complaints for each finance type.
-- Include only finance types where the average is greater than £20,000.
SELECT fin.FinanceType,
        AVG (fin.FinanceAmount) AS [Average Finance Amount]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
    ON fin.AgreementID = comp.AgreementID
WHERE comp.Status = 'Resolved'
GROUP BY fin.FinanceType 
HAVING AVG (fin.FinanceAmount) > 20000;
-- Analysis:
-- PCP was the only finance type with an average finance amount greater than £20,000.
-- PCP had an average finance amount of approximatley £25,163.
-- HP had an average value below the £20,000 threshold and therefore was excluded from the results.
-- Further analysis is required to calculate the average without finance agreements being duplicated by 
-- multiple resolved complaints.


--========================================================================================================
-- MULTI-TABLE JOINS
--========================================================================================================

-- Business request:
-- Show each complaint alongside the customer's name and the 
-- finance type of the associated finance agreement.
SELECT comp.ComplaintID,
       cust.CustomerName,
       fin.FinanceType
FROM Complaints AS comp
INNER JOIN Customers AS cust
    ON comp.CustomerID = cust.CustomerID
INNER JOIN FinanceAgreements AS fin 
    ON comp.AgreementID = fin.AgreementID;
-- Analysis:
-- The query returned all 20 complaints with the associated 
-- customer name and finance type.

-- Business request:
-- Review resolved complaints and show the customer's name, complaint type,
-- and the make and model of the vehicle associated with the finance agreement.
SELECT cust.CustomerName,
       comp.ComplaintType,
       veh.Model,
       veh.Make
FROM Complaints AS comp
INNER JOIN FinanceAgreements AS fin
    ON comp.AgreementID = fin.AgreementID
INNER JOIN Vehicles AS veh
    ON fin.VehicleID = veh.VehicleID
INNER JOIN Customers AS cust
    ON comp.CustomerID = cust.CustomerID
WHERE comp.Status = 'Resolved';
-- Analysis:
-- The query returned all 13 resolved complaints with the associated
-- customer's name, complaint type and the make and model of the vehicle
-- linked to the relevant finance agreement.


-- Business Request:
-- Identify all resolved motor finance complaints, Showing the complaint ID, 
-- customer name, finance type and the make and model of the vehicle involved.
SELECT cust.CustomerName,
       comp.ComplaintID,
       fin.FinanceType,
       veh.Make,
       veh.Model
FROM Complaints AS comp
INNER JOIN Customers AS cust 
    ON comp.CustomerID = cust.CustomerID
INNER JOIN FinanceAgreements AS fin
    ON comp.AgreementID = fin.AgreementID 
INNER JOIN Vehicles AS veh
    ON fin.VehicleID = veh.VehicleID 
WHERE comp.Status = 'Resolved';
-- Analysis:
-- The query returned 13 resolved complaints. By joining four tables, we can identify the customer,
-- finance type and specific vehicles linked to each complaint. Customers may appear more than once 
-- where they have multiple resolved complaints.


-- Business request:
-- Display all finance agreements, including the customer name, 
-- vehicle make and model, and associated complaint ID. 
-- Include agreements that have not received any complaints.
SELECT cust.CustomerName,
       fin.AgreementID,
       veh.Make,
       veh.Model,
       comp.ComplaintID
FROM FinanceAgreements AS fin
INNER JOIN Customers AS cust
    ON fin.CustomerID = cust.CustomerID
LEFT JOIN Complaints AS comp
    ON fin.AgreementID = comp.AgreementID
INNER JOIN Vehicles AS veh 
  ON fin.VehicleID = veh.VehicleID;
-- Analysis:
-- The query returned 22 rows across 17 finanace agreements.
-- Some agreements appear multiple times because they have 
-- more than one associated complaint.
-- Agreements 16 and 17 have NULL complaint ID values,
-- confirming that no complaints have been recorded against them.
-- The LEFT JOIN ensures these agreements remain in the results.

-- Business request:
-- Report the total number of complaints by vehicle make
-- and finance type, including vehicles with no complaints.
SELECT veh.Make,
       fin.FinanceType,
       COUNT (comp.ComplaintID) AS [Total Complaints]
FROM Vehicles AS veh
LEFT JOIN FinanceAgreements AS fin
     ON veh.VehicleID = fin.VehicleID
LEFT JOIN Complaints AS comp 
     ON fin.AgreementID = comp.AgreementID
GROUP BY veh.Make,
       fin.FinanceType;
-- Analysis:
-- The query returned 11 vehicle make and finance type combinations,
-- representing 20 complaints. 
-- PCP accounts for 14 complaints and HP accounts for 6.
-- LEFT JOINs preserve vehicles without complaints, while 
-- COUNT (ComplaintID) ensures only actual complaints are counted.
-- No zero-complaint groups appear in the current dataset.

-- Business request:
-- Report the number of complaints associated with each finance agreement,
-- including the customer name, finance type and vehicle make.
-- Include agreements with no recorded complaints.
SELECT cust.CustomerName,
       fin.FinanceType,
       veh.Make,
       fin.AgreementID,
       COUNT (comp.ComplaintID) AS [Total Complaints]
FROM FinanceAgreements AS fin 
LEFT JOIN Complaints AS comp
     ON fin.AgreementID = comp.AgreementID
INNER JOIN Vehicles AS veh 
     ON fin.VehicleID = veh. VehicleID
LEFT JOIN Customers AS cust
     ON fin.CustomerID = cust.CustomerID
GROUP BY cust.CustomerName,
         cust.CustomerID,
         fin.FinanceType,
         veh.Make,
         fin.AgreementID;
--Analysis:
-- The query returned 17 rows representing all 17 finance agreements.
-- Agreements 16 and 17 have zero recorded complaints.
-- Grouping by agreement ID ensures each agreeement is reported seporatley, 
-- even when a customer has multiple agreements with the same finance type and vehicle make.
-- The LEFT JOIN preserves agreements without complaints, while COUNT (comp.ComplaintID) excludes null values.

-- Business request
-- Report all finance agreements, including the customer name, finance type and vehicle make.
-- Show the number of open and resolved complaints separately, 
-- including agreements with no complaints.
SELECT cust.CustomerName,
       fin.FinanceType,
       veh.Make,
       fin.AgreementID,
     SUM(
       CASE 
         WHEN comp.Status = 'Open' 
          THEN 1
         ELSE 0
       END) AS [Open],
     SUM(
       CASE 
         WHEN comp.Status = 'Resolved' 
          THEN 1
         ELSE 0
       END) AS [Resolved],
       COUNT (comp.ComplaintID) AS [Total Complaints]
FROM FinanceAgreements AS fin 
LEFT JOIN Customers AS cust
    ON fin.CustomerID = cust.CustomerID
LEFT JOIN Complaints AS comp
    ON fin.AgreementID = comp.AgreementID
LEFT JOIN Vehicles AS veh
    ON fin.VehicleID = veh.VehicleID 
GROUP BY fin.AgreementID,cust.CustomerName,veh.Make,fin.FinanceType;
-- Analysis:
-- The query returned 17 finance agreements, with 20 complaints 
-- recorded in total: 7 open and 13 resolved. 
-- Agreements 16 and 17 have no recorded complaints.
-- Conditional aggregation using SUM and CASE seporated open and resolved complaints.
-- The LEFT JOIN preserves agreements without complaints, while grouping agreement ID 
-- keeps each agreement separate.

--====================================================================================================
-- DATE FUNCTIONS
--====================================================================================================

-- Business request:
-- Calculate the longest number of days taken to resolve each complaint.
-- Display the longest resolution times first
SELECT ComplaintID,
       DATEDIFF (DAY, ComplaintDate, ResolutionDate) AS [Total Days to Resolution]
FROM Complaints
WHERE Status = 'Resolved'
ORDER BY [Total Days to Resolution] DESC;
-- Analysis:
-- The query returned 13 resolved complaints.
-- Resolution times renged from 33 to 63 days.
-- Open complaints were excluded using the WHERE filter.


-- Business request:
-- Calculate the average number of days taken to resolve
-- complaints to assess overall complaint handling performance. 
SELECT 
    AVG (CAST(DATEDIFF (DAY, ComplaintDate, ResolutionDate) AS DECIMAL (10,2))) AS [Average Resolution Days]
FROM Complaints 
WHERE Status = 'Resolved';
-- Analysis:
-- The query calculates the average resolution time across
-- resolved complaints only, excluding open complaints.
-- DATEDIFF calculates the resolution time in days.
-- CAST converts the result to a decimal, allowing AVG
-- to return a more precise average with two decimal places.
-- The average resoltion time across 13 resolved complaints was approx 51.15 days.


-- Business request:
-- Calculate the average resolution time for each complaint type.
-- Include the number of resolved complaints in each category.
-- Show complaint types from longest to shortest resolution time.
SELECT ComplaintType,
       AVG (CAST (DATEDIFF (DAY, ComplaintDate, ResolutionDate) AS DECIMAL (10,2))) AS [Average Resolution Days],
       COUNT (ComplaintID) AS [Total Resolved Complaints]
FROM Complaints
WHERE Status = 'Resolved'
GROUP BY ComplaintType
ORDER BY [Average Resolution Days] DESC;
-- Analysis:
-- The query returned 6 complaint types.
-- Complaint volumes were included alongside average resolution times 
-- to provide context when comparing complaint types.
-- Early settlement had the longest average resolution time at approx 57.67 days,
-- based on 3 resolved complaints.
-- Customer service had the shortest at 41 days.
-- Catagories with only 1 complaint should be interpreted cautiously.
-- Only resolved complaints were included in the analysis.


-- Business request:
-- Identify complaint types with atleast 3 resolved complaints.
-- Compare their average resolution times, ranking the longest resolution times first.
SELECT ComplaintType,
       AVG (CAST (DATEDIFF (DAY, ComplaintDate, ResolutionDate) AS DECIMAL (10,2))) AS [Average Resolution Days],
       COUNT (ComplaintID) AS [Total Resolved Complaints]
FROM Complaints
WHERE Status = 'Resolved'
GROUP BY ComplaintType
HAVING COUNT (ComplaintID) >= 3
ORDER BY [Average Resolution Days] DESC;
-- Analysis:
-- Three complaint types met the minimum threshold of 3 resolved complaints.
-- Early settlement had the longest average resolution time at approx 57.67 days.
-- HAVING excluded complaint types with fewer than 3 resolved complaints.
-- This allows the comparison of catagories with a minimum complaint volume,
-- although sizes remain small.


-- Business request:
-- Identify the five open complaints that have been awaiting resolution the  
-- longest,to help priorities outstanding cases.
SELECT TOP 5 ComplaintID,
           DATEDIFF (DAY, ComplaintDate, GETDATE ()) AS [Days Awaiting Resolution]
FROM Complaints
WHERE Status = 'Open'
ORDER BY [Days Awaiting Resolution] DESC;
-- Analysis:
-- The query returned 5 longest outstanding open complaints.
-- Complaint 4 had the longest waiting time at 79 days.
-- TOP 5 and ORDER BY DESC were used to identify the 
-- complaints with the longest waiting times.
-- DATEDIFF and GETDATE Calculate how long each complaint 
-- has been awaiting resolution as of the execution date.
-- Only open complaints were included in the results.

-- Business request:
-- Identify all open complaints that are passed their SLA deadline.
SELECT ComplaintID, 
       ComplaintDate, 
       SLADueDate,
       DATEDIFF (DAY, SLADueDate, GETDATE ()) AS [Days Overdue]
FROM Complaints
WHERE Status = 'Open' AND SLADueDate < CAST (GETDATE () AS DATE)
ORDER BY [Days Overdue] DESC;
-- The query returned 3 complaints that are now overdue.
-- Complaint 4 has been overdue the longest at 23 days.
-- Complaint 10 has been overdue the shortest time at 7 days.


-- Business request:
-- Identify how many complaints have been resolved on or before their SLA deadline
-- and how many were resolved after their SLA deadline.
SELECT 
  COUNT (ComplaintID) AS [Total Complaints],
  CASE 
   WHEN ResolutionDate <= SLADueDate 
    THEN 'On Time'
   ELSE 'Late'
  END AS [SLA Deadline]
FROM Complaints
WHERE Status = 'Resolved'
GROUP BY 
  CASE 
   WHEN ResolutionDate <= SLADueDate 
    THEN 'On Time'
   ELSE 'Late'
  END
ORDER BY [Total Complaints] DESC;
-- Analysis:
-- The query identified 13 resolved complaints.
-- 9 complaints were resolved on or before their SLA deadline.
-- 4 complaints were resolved after thier SLA deadline.
-- CASE catagorised complaints as on time or late by comparing
-- Resolution date and SLA due date.
-- COUNT and GROUP BY Calculated the total in each catagory 


--===================================================================================================
-- WINDOW FUNCTIONS
--===================================================================================================

-- Business request:
-- Report the number and percentage of resolved complaints
-- completed on time verses late, rounded to two deciamal places 
-- and ordered by highest complaint count first.
SELECT 
  CASE 
    WHEN ResolutionDate <= SLADueDate 
     THEN 'On Time' 
    ELSE 'Late'
  END AS [SLA Deadline],
    COUNT (ComplaintID) AS [Total Complaints], 
    CAST
      (COUNT (ComplaintID)* 100.0
       /
       SUM (COUNT (ComplaintID)) OVER () AS DECIMAL (5,2)
     ) AS [Percentage]
FROM Complaints
WHERE Status = 'Resolved'
GROUP BY 
  CASE 
    WHEN ResolutionDate <= SLADueDate 
     THEN 'On Time' 
    ELSE 'Late'
  END
ORDER BY [Total Complaints] DESC;
-- Analysis:
-- Of 13 resolved complaints, 9 (69.23%) were completed 
-- on time and 4 (30.77%) were completed late.
-- The overall SLA complicance rate was 69.23%.


-- Business request:
-- Report the total number and percentages of complaints.
-- by complaint type, including all complaint statuses.
-- Display percentages to two decimal places and
-- order by highest complaint count first.
SELECT ComplaintType,
      COUNT (ComplaintID) AS [Total Complaints],
     CAST (
       COUNT (ComplaintID) * 100.0
       /
       SUM (COUNT (ComplaintID)) OVER () AS DECIMAL (5,2)
    )AS [Percentage]
FROM Complaints 
GROUP BY ComplaintType
ORDER BY [Total Complaints] DESC;
-- Analysis:
-- There are 20 complaints across six complaint types.
-- Affordability and customer service are the most common,
-- with 5 complaints each (25% each).
-- Vehicle has the fewest complaints,with 1 (5%).


-- Business request:
-- Report the number and percentage of finance agreements
-- by finance type, including both active and settled agreements.
-- Display percentages to two decimal places and
-- order them by highest agreement count first.
SELECT FinanceType,
       COUNT (AgreementID) AS [Total Finance Agreements],
       CAST (
         COUNT (AgreementID) * 100.0
         /
         SUM (COUNT (AgreementID)) OVER () AS DECIMAL (5,2)
       ) AS [Percentage]
FROM FinanceAgreements 
GROUP BY FinanceType
ORDER BY [Total Finance Agreements] DESC;
-- There are 17 finance agreements in total.
-- PCP accounts for 10 agreements (58.82%),
-- while HP accounts for 7 agreements (41.18%).
-- PCP is the most common finance type.


-- Business request:
-- Show each finance agreement, its finance type and amount,
-- alongside the average finance amount for the same finance type.
-- Include active and settles agreements, display the averages to 
-- two decimal places, and order by finance type and highest finance amount first.
SELECT AgreementID,
       FinanceType,
       FinanceAmount,
       CAST (
         AVG (FinanceAmount) OVER (PARTITION BY FinanceType) AS DECIMAL (10,2)
       ) AS [Average Finance Amount]
FROM FinanceAgreements
ORDER BY FinanceType,
         FinanceAmount DESC;
-- Analysis:
-- The average PCP finance amount is £24,580.00
-- compared with £17,442.86 for HP agreements.
-- Agreement 13 has a finance amount  of £33,500,
-- which is £8,920 above the PCP average.


-- Business request:
-- Show every complaint, its complaintID and complaint type,
-- alongside the total number of complaints raised by 
-- the same customer, including all complaint statuses.
-- Order by CustomerID and then ComplaintID ascending. 
SELECT ComplaintID,
       CustomerID,
       ComplaintType,
       COUNT (ComplaintID) OVER (PARTITION BY CustomerID) AS [Total Complaints]
FROM Complaints
ORDER BY CustomerID ASC,
         ComplaintID ASC;
-- Analysis:
-- The report retains individual complaint records while 
-- showing each customer's overall complaint count.
-- Customer 1 has raised 2 commplaints, demonstrating 
-- how repeat complaints can be indentified.

-- Business request:
-- Show each resolved complaint, including complaintID,
-- customerID, complaint type and resolution days.
-- Display the average resolution time for each customer to 2 decimal places.
-- Order by customerID and complaintID ascending. 
SELECT ComplaintID,
       CustomerID,
       ComplaintType,
      DATEDIFF (DAY, ComplaintDate, ResolutionDate) AS [Resolution Days],
      CAST (
        AVG (DATEDIFF (DAY, ComplaintDate, ResolutionDate)) 
        OVER (PARTITION BY CustomerID) AS DECIMAL (10,2)
       ) AS [Customer Average Resolution Days]
FROM Complaints 
WHERE Status = 'Resolved'
ORDER BY CustomerID ASC,
         ComplaintID ASC;
-- Analysis
-- Customer 3 had two resolved complaints taking 61 and 49 days,
-- with and average resolution time of 55 days.
-- Customer 8 had two resolved complaints taking 45 and 59 days, averaging 52 days.
-- This allows individual resolution times to be compared against each customer average.

-- Business request:
-- Produce a chronological complaint history for each customer.
-- Number complaints from oldest to newest, restarting at 1 for each customer.
SELECT CustomerID,
       ComplaintID,
       ComplaintDate,
       ROW_NUMBER() OVER (
         PARTITION BY CustomerID 
         ORDER BY ComplaintDate ASC
       ) AS [Complaint Number]
FROM Complaints
ORDER BY CustomerID ASC,
         ComplaintDate ASC;
-- Analysis:
-- ROW_NUMBER () successfully numbers complaints chronologically for each customer.
-- Customer 3's complaint dated 11 May 2026 is numbered 1,
-- followed by their complaint dated 15 July 2026, numbered 2.
-- This helps identify the sequence of repeat complaints.


-- Business request:
-- Produce a report showing each customer's complaint history,
-- ranking their complaints from ewest to oldest.
-- Display all complaints with the most recent numbered 1.
SELECT CustomerID,
       ComplaintID,
       ComplaintDate,
       Status,
       ROW_NUMBER () OVER (
         PARTITION BY CustomerID 
         ORDER BY ComplaintDate DESC
       ) AS [Complaint Rank]
FROM Complaints
ORDER BY CustomerID ASC,
         [Complaint Rank] ASC;
-- Analysis:
-- ROW_NUMBER() Ranks complaints by date for each customer,
-- restarting at 1 for every customerID.
-- Customer 1's most recent complaint is complaintID 16,
-- dated 1 September 2026, which is currently open.
-- This allows the business to identify each customer's
-- latest complaint while retaining their full history.


-- Business request:
-- Rank finanace agreements by value within each finance type.
-- The highest value agreements should rank first, with
-- identical finance amounts sharing the same rank.
SELECT AgreementID,
       FinanceType,
       FinanceAmount,
       RANK () OVER (
         PARTITION BY FinanceType
         ORDER BY FinanceAmount DESC
       ) AS [Finance Rank] 
FROM FinanceAgreements
ORDER BY FinanceType ASC,
        [Finance Rank] ASC,
         AgreementID ASC
-- Analysis:
-- RANK () ranks agreements seporatley for HP and PCP.
-- Agreement 2 is the highest-value HP agreement at £24,000, 
-- while agreement 13 is the highest-value PCP agreement at £33,500.
-- HP agreements 6 and 17 both have a finance amount of £12,500 and 
-- therefore share rank 6. This allows the buisness to identify
-- the highest-value agreements within each finance type while 
-- accounting for tied amounts.


-- Business request:
-- Rank finance agreements by value within each finance type, with the 
-- highest amounts ranked first. Agreements with identical values should 
-- share the same rank, without gaps in the ranking sequence.
SELECT AgreementID,
       FinanceType,
       FinanceAmount,
       DENSE_RANK () OVER (
         PARTITION BY FinanceType
         ORDER BY FinanceAmount DESC
       ) AS [Dense Finanace Rank]
FROM FinanceAgreements 
ORDER BY FinanceType ASC,
        [Dense Finanace Rank] ASC,
        AgreementID ASC;
-- Analysis:
-- DENSE_RANK () ranks finance agreements seporatley for HP and PCP, 
-- from highest to lowest finance amount.
-- Agreement 2 is the highest-value HP agreement at £24,000, while 
-- agreement 13 is the highest-value PCP agreement at £33,500.
-- HP agreements 6 and 17 both have a finance amount of £12,500 and 
-- therefore share rank 6, without any gaps in the sequence.
-- This allows the business to compare agreement values within each
-- finance type while recognising agreements with identical amounts.
























































