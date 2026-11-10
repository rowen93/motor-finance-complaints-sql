-- Motor Finance Complaints Analysis
-- 
-- SQL queries exploring finance agreements, customer information, 
-- complaint trends and resolution performance.
-- 
-- Database: MotorFinanceComplaints
-- Last Reviewed: Completed 10 November 2026


USE MotorFinanceComplaints
GO

--====================================================================================
--FINANCE AGREEMENT ANALYSIS
--====================================================================================

-- BUSINESS REQUEST:
-- Total finance amount across all agreements --
SELECT SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements;
-- ANALYSIS:
-- The aggregate summarises the selected records and any stated filters; NULL values are excluded by the aggregate.

-- BUSINESS REQUEST:
-- Total finance amount by finance type
SELECT FinanceType, 
       SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements
GROUP BY FinanceType;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Total finance amount by finance type for active agreements --
SELECT FinanceType, 
       SUM (FinanceAmount) AS TotalFinanceAmount
FROM FinanceAgreements
WHERE AgreementStatus = 'Active'
GROUP BY FinanceType
ORDER BY TotalFinanceAmount DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Total finance amount for active PCP agreements --
SELECT SUM (FinanceAmount) AS [Total PCP Finance Amount]
FROM FinanceAgreements
WHERE AgreementStatus = 'Active'
AND FinanceType = 'PCP';
-- ANALYSIS:
-- The aggregate summarises the selected records and any stated filters; NULL values are excluded by the aggregate.

-- BUSINESS REQUEST:
-- Total finance amount by agreement status --
SELECT AgreementStatus, 
       SUM (FinanceAmount) AS TotalAmount
FROM FinanceAgreements
GROUP BY AgreementStatus
ORDER BY TotalAmount DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Highest finance amount --
SELECT MAX (FinanceAmount) AS MaxFinanceAmount
FROM FinanceAgreements;
-- ANALYSIS:
-- The aggregate summarises the selected records and any stated filters; NULL values are excluded by the aggregate.

-- BUSINESS REQUEST:
-- Lowest finance amounts for active agreements --
SELECT MIN (FinanceAmount) AS MinFinanceAmount
FROM FinanceAgreements 
WHERE AgreementStatus = 'Active';
-- ANALYSIS:
-- The aggregate summarises the selected records and any stated filters; NULL values are excluded by the aggregate.

-- BUSINESS REQUEST:
-- Average, highest and lowest finance amount by finance type --
SELECT FinanceType, 
       AVG(CAST(FinanceAmount AS DECIMAL(19,4))) AS AverageAmount, 
       MAX (FinanceAmount) AS MaxAmount, 
       MIN (FinanceAmount) AS MinAmount
FROM FinanceAgreements
GROUP BY FinanceType;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Finance Agreements between £15,000 and £25,000
SELECT *
FROM FinanceAgreements
WHERE FinanceAmount BETWEEN 15000 AND 25000;
-- ANALYSIS:
-- The filters select the records described above; the result is a detail report rather than a grouped summary.

-- BUSINESS REQUEST:
-- Complaints received between June and Aug 2026, oldest first --
SELECT *
FROM Complaints
WHERE ComplaintDate >= '20260601' AND ComplaintDate < '20260901'
ORDER BY ComplaintDate ASC;
-- ANALYSIS:
-- The filters select the records described above; the result is a detail report rather than a grouped summary.

-- BUSINESS REQUEST:
-- All resolved complaints received between June and Aug 2026, oldest first --
SELECT *
FROM Complaints
WHERE ComplaintDate >= '20260601' AND ComplaintDate < '20260901'
AND Status = 'Resolved'
ORDER BY ComplaintDate ASC;
-- ANALYSIS:
-- The filters select the records described above; the result is a detail report rather than a grouped summary.

--=========================================================================================
--COMPLAINT ANALYSIS --
--=========================================================================================

-- BUSINESS REQUEST:
-- Total number of complaints --
SELECT COUNT (*) AS [Total Complaints]
FROM Complaints;
-- ANALYSIS:
-- The aggregate summarises the selected records and any stated filters; NULL values are excluded by the aggregate.

-- BUSINESS REQUEST:
-- Total number of open complaints --
SELECT COUNT (*) AS [Total Open Complaints]
FROM Complaints
WHERE Status = 'Open';
-- ANALYSIS:
-- The aggregate summarises the selected records and any stated filters; NULL values are excluded by the aggregate.

-- BUSINESS REQUEST:
-- Number of complaints by complaint type --
SELECT ComplaintType, COUNT(*) AS [Total Complaints]
FROM Complaints
GROUP BY ComplaintType
ORDER BY [Total Complaints] DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Resolved Complaints by outcome --
SELECT Outcome, COUNT(*) AS [Total Complaints]
FROM Complaints
WHERE Status = 'Resolved'
GROUP BY Outcome;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Number of upheld complaints by complaint type, highest first --

SELECT ComplaintType, COUNT (*) AS TotalUpheld
FROM Complaints 
WHERE Outcome = 'Upheld'
GROUP BY ComplaintType
ORDER BY TotalUpheld DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Resolved complaints for selected complaint types --
SELECT *
FROM Complaints
WHERE Status = 'Resolved' AND ComplaintType IN ('Affordability','Customer Service','Commission Disclosure')
-- ANALYSIS:
-- The filters select the records described above; the result is a detail report rather than a grouped summary.

-- BUSINESS REQUEST:
-- Open or Upheld Complaints --
SELECT * 
FROM Complaints
WHERE Status = 'Open' OR Outcome = 'Upheld';
-- ANALYSIS:
-- The filters select the records described above; the result is a detail report rather than a grouped summary.

--==============================================================================================================
--JOIN ANALYSIS
--==============================================================================================================

-- BUSINESS REQUEST:
-- Complaints with customer names --
SELECT comp.ComplaintID,
       comp.ComplaintType,
       comp.Status,
       cust.CustomerName
FROM Complaints AS comp
INNER JOIN Customers AS cust
     ON comp.CustomerID = cust.CustomerID;
-- ANALYSIS:
-- The joins return the matching records described above; a customer or agreement may appear for multiple complaints.

-- BUSINESS REQUEST:
-- Finance Agreements with Customer Names --
SELECT fin.AgreementID,   
       fin.FinanceType,
       fin.FinanceAmount,
       cust.CustomerName
FROM FinanceAgreements AS fin
INNER JOIN Customers AS cust
     ON fin.CustomerID = cust.CustomerID;
-- ANALYSIS:
-- The joins return the matching records described above; a customer or agreement may appear for multiple complaints.

-- BUSINESS REQUEST:
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
-- ANALYSIS:
-- The joins return the matching records described above; a customer or agreement may appear for multiple complaints.

-- BUSINESS REQUEST:
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
-- ANALYSIS:
-- The joins return the matching records described above; a customer or agreement may appear for multiple complaints.

-- BUSINESS REQUEST:
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
-- ANALYSIS:
-- The joins return the matching records described above; a customer or agreement may appear for multiple complaints.

-- BUSINESS REQUEST:
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
-- ANALYSIS:
-- The joins return the matching records described above; a customer or agreement may appear for multiple complaints.

-- BUSINESS REQUEST:
-- Open PCP complaints with customer, vehicle and finance agreement details, ordered by earliest SLA due date --
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
-- ANALYSIS:
-- The joins return the matching records described above; a customer or agreement may appear for multiple complaints.

-- BUSINESS REQUEST:
-- Number of open complaints by finance type, highest first --
SELECT fin.FinanceType, 
       COUNT (*) AS [Total Open Complaints]
FROM FinanceAgreements AS fin
INNER JOIN Complaints AS comp
      ON fin.AgreementID = comp.AgreementID
WHERE comp.Status = 'Open' 
GROUP BY fin.FinanceType
ORDER BY [Total Open Complaints] DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
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
-- ANALYSIS:
-- The joins return the matching records described above; a customer or agreement may appear for multiple complaints.

-- BUSINESS REQUEST:
-- Number of upheld complaints by finance type, highest first -- 
SELECT fin.FinanceType, 
       COUNT (*) AS [Total Upheld]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
      ON fin.AgreementID = comp.AgreementID
WHERE comp.Outcome = 'Upheld'
GROUP BY fin.FinanceType
ORDER BY [Total Upheld] DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Compare average agreement value by finance type for agreements with at least
-- one upheld complaint. Count each qualifying agreement once.
SELECT fin.FinanceType,
       CAST(AVG(CAST(fin.FinanceAmount AS DECIMAL(19,4))) AS DECIMAL(19,2))
           AS [Average Finance Amount]
FROM FinanceAgreements AS fin
WHERE EXISTS (
    SELECT 1 FROM Complaints AS comp
    WHERE comp.AgreementID = fin.AgreementID
      AND comp.Outcome = 'Upheld'
)
GROUP BY fin.FinanceType
ORDER BY [Average Finance Amount] DESC;
-- ANALYSIS:
-- EXISTS avoids weighting an agreement repeatedly when it has multiple upheld complaints.
-- Result values must be recorded after execution against the project database.

--===============================================================================================================
-- CASE ANALYSIS
--===============================================================================================================

-- BUSINESS REQUEST:
-- Categorise finance agreements into low, medium and high value bands --
SELECT AgreementID, 
       FinanceType, 
       FinanceAmount,
      CASE 
        WHEN FinanceAmount IS NULL THEN 'Unknown'
        WHEN FinanceAmount < 15000 
          THEN 'Low Value'
        WHEN FinanceAmount BETWEEN 15000 AND 25000 
          THEN 'Medium Value'
        ELSE 'High Value'
      END AS [Value Band]
FROM FinanceAgreements;
-- ANALYSIS:
-- The filters select the records described above; the result is a detail report rather than a grouped summary.

-- BUSINESS REQUEST:
-- Categorise finance agreements into lower, standard and high value band --
SELECT AgreementID,
       FinanceType,
       FinanceAmount,
       CASE 
         WHEN FinanceAmount IS NULL THEN 'Unknown'
         WHEN FinanceAmount < 20000 
           THEN 'Lower Value'
         WHEN FinanceAmount BETWEEN 20000 AND 30000 
           THEN 'Standard Value'
         ELSE 'Higher Value'
       END AS [Band Value]
FROM FinanceAgreements;
-- ANALYSIS:
-- The filters select the records described above; the result is a detail report rather than a grouped summary.

-- BUSINESS REQUEST:
-- Upheld complaints by finance type and APR Band, highest first --
SELECT fin.FinanceType,
       CASE 
         WHEN APR IS NULL THEN 'Unknown'
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
         WHEN APR IS NULL THEN 'Unknown'
         WHEN APR < 6 
           THEN 'Low APR'
         WHEN APR BETWEEN 6 AND 9 
           THEN 'Medium APR'
         ELSE 'High APR'
       END
ORDER BY [Total Upheld] DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Groups upheld complaints by finance type and finance amount band to identify which agreement value ranges have the highest number 
-- of upheld complaints.
SELECT fin.FinanceType,
       CASE 
         WHEN fin.FinanceAmount IS NULL THEN 'Unknown'
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
         WHEN fin.FinanceAmount IS NULL THEN 'Unknown'
         WHEN fin.FinanceAmount < 20000 
           THEN 'Lower Value'
         WHEN fin.FinanceAmount BETWEEN 20000 AND 30000 
           THEN 'Standard Value'
         ELSE 'Higher Value'
       END
ORDER BY [Total Upheld] DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Groups resolved complaints by finance type and term length to show how many resolved complaints fall into each term band.
SELECT fin.FinanceType,
       CASE  
         WHEN fin.TermMonths IS NULL THEN 'Unknown'
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
           WHEN fin.TermMonths IS NULL THEN 'Unknown'
           WHEN fin.TermMonths < 36 
             THEN 'Short Term'
           WHEN fin.TermMonths BETWEEN 36 AND 48 
             THEN 'Standard Term'
           ELSE 'Long Term'
         END
ORDER BY [Total Resolved] DESC;
-- ANALYSIS:
-- Grouped results compare the categories specified above using the measure and units named in the output.

-- BUSINESS REQUEST:
-- Resolved complaints by complaint type and APR band, highest first --
SELECT comp.ComplaintType,
       CASE 
         WHEN fin.APR IS NULL THEN 'Unknown'
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
           WHEN APR IS NULL THEN 'Unknown'
           WHEN APR < 6 
             THEN 'Low APR'
           WHEN APR BETWEEN 6 AND 9 
             THEN 'Medium APR'
           ELSE 'High APR'
         END 
ORDER BY [Total Resolved] DESC;
-- Analysis: Early settlement complaints at Low APR had the highest number of resolved complaints (3).
-- Commission Disclosure at medium APR AND Affordability at High APR with (2) each.

-- BUSINESS REQUEST:
-- Resolved complaints by finance type SLA performance, highest first --
SELECT FinanceType,
       CASE 
         WHEN ResolutionDate IS NULL OR SLADueDate IS NULL THEN 'Unknown'
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
           WHEN ResolutionDate IS NULL OR SLADueDate IS NULL THEN 'Unknown'
           WHEN ResolutionDate <= SLADueDate 
             THEN 'On Time'
           ELSE 'Late'
         END 
ORDER BY [Total Resolved] DESC; 
-- Analysis: PCP had the highest of resolved complaints completed on time (5) followed by HP (4). Late resolutions were lower
-- with (3) PCP complaints and (1) HP complaint.

-- BUSINESS REQUEST:
-- Complaints by finance type and APR Band, highest volume first --
SELECT fin.FinanceType, 
       COUNT (*) AS [Total Complaints],
       CASE 
         WHEN APR IS NULL THEN 'Unknown'
         WHEN APR < 6 
           THEN 'Low APR'
         WHEN APR BETWEEN 6 AND 9 
           THEN 'Medium APR'
         ELSE 'High APR'
       END AS [APR Banding]
FROM FinanceAgreements AS fin 
INNER JOIN Complaints AS comp
      ON fin.AgreementID = comp.AgreementID
GROUP BY fin.FinanceType,
        CASE 
          WHEN APR IS NULL THEN 'Unknown'
          WHEN APR < 6 
            THEN 'Low APR'
          WHEN APR BETWEEN 6 AND 9 
            THEN 'Medium APR'
          ELSE 'High APR'
        END
ORDER BY [Total Complaints] DESC;
--Analysis: Medium APR agreements had the highest complaint volume (8), 
-- followed by Low APR (7) and high APR (5).
-- Medium APR complaints consisted of (7) PCP and (1) HP complaint.

-- BUSINESS REQUEST:
-- Complaints by agreement term band, highest volume first --
SELECT 
    CASE 
      WHEN TermMonths IS NULL THEN 'Unknown'
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
      WHEN TermMonths IS NULL THEN 'Unknown'
      WHEN TermMonths < 36 
        THEN 'Short Term'
      WHEN TermMonths BETWEEN 36 AND 48 
        THEN 'Standard Term'
      ELSE 'Long Term'
    END 
ORDER BY [Total Complaints] DESC;
-- Analysis: Standard Term agreements had the highest complaint volume (11)
-- followed by Long Term agreements (7) and Short Term agreements (2).

-- BUSINESS REQUEST:
-- Resolved complaints by finance type and customer age band, highest first -- 
SELECT fin.FinanceType,
       CASE 
         WHEN Age IS NULL THEN 'Unknown'
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
           WHEN Age IS NULL THEN 'Unknown'
           WHEN Age < 30 
             THEN 'Under 30'
           WHEN Age BETWEEN 30 AND 49 
             THEN '30-49'
           ELSE '50+'
         END
ORDER BY [Total Resolved Complaints] DESC;
-- Analysis: The 30-49 age band had the highest volume of resolved complaints (9 Total), 
-- with PCP (5) marginally higher than HP (4).
-- Under 30 had 3 resolved complaints (2 PCP and 1 HP).
-- The age 50+ age band had the lowest volume, with 1 resolved PCP complaint.

-- BUSINESS REQUEST:
-- Resolved complaint SLA performance by complaint month, in chronological order --
SELECT
    CASE 
      WHEN ResolutionDate IS NULL OR SLADueDate IS NULL THEN 'Unknown'
      WHEN ResolutionDate <= SLADueDate 
        THEN 'On Time'
      ELSE 'Late'
    END AS [SLA Performance],
    DATEFROMPARTS(YEAR(ComplaintDate), MONTH(ComplaintDate), 1) AS [Complaint Month],
    COUNT (*) AS [Total Resolved Complaints]
FROM Complaints AS comp
WHERE Status = 'Resolved'
GROUP BY DATEFROMPARTS(YEAR(ComplaintDate), MONTH(ComplaintDate), 1),
    CASE 
      WHEN ResolutionDate IS NULL OR SLADueDate IS NULL THEN 'Unknown'
      WHEN ResolutionDate <= SLADueDate 
        THEN 'On Time'
      ELSE 'Late'
    END
ORDER BY [Complaint Month];
-- Analysis: 9 of the 13 resolved complaints were completed on time, with 4 completed late.
-- Previous month-level findings were contradictory and have been removed.
-- Rerun this query to document the on-time and late counts for each year-month.
-- Months represent when complaints were received, not when they were resolved.
-- July had the highest resolved complaint volume (5), with 3 completed on time and 2 late.

-- BUSINESS REQUEST:
-- Complaint volume by finance agreement value band, highest first --
SELECT 
    CASE 
      WHEN fin.FinanceAmount IS NULL THEN 'Unknown'
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
      WHEN fin.FinanceAmount IS NULL THEN 'Unknown'
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
-- Identify all finance agreements that never received a complaint,
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
       AVG(CAST(FinanceAmount AS DECIMAL(19,4))) AS [Average Finance Amount]
FROM FinanceAgreements
WHERE AgreementStatus = 'Active'
GROUP BY FinanceType
HAVING AVG(CAST(FinanceAmount AS DECIMAL(19,4))) > 20000;
-- Analysis:
-- PCP was the only finance type with an average finance amount greater than £20,000,
-- with an average value of approximately £23,043.
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


-- Business request:
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
      WHEN fin.FinanceAmount IS NULL THEN 'Unknown'
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
     WHEN fin.FinanceAmount IS NULL THEN 'Unknown'
     WHEN fin.FinanceAmount < 20000 THEN 'Lower Value'
    ELSE 'Higher Value'
   END
HAVING COUNT (comp.ComplaintID) > 5;
-- Analysis:
-- Both the Higher Value and Lower Value bands met the threshold of more than 5 complaints.
-- Higher Value Band had the highest complaint volume, with 14 complaints.
-- Lower Value Band had 6 complaints.


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
LEFT JOIN Customers AS cust
    ON fin.CustomerID = cust.CustomerID
LEFT JOIN Complaints AS comp
    ON fin.AgreementID = comp.AgreementID
LEFT JOIN Vehicles AS veh
  ON fin.VehicleID = veh.VehicleID;
-- Analysis:
-- The query returned 22 rows across 17 finance agreements.
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
-- Conditional aggregation using SUM and CASE separated open and resolved complaints.
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
-- Resolution times ranged from 33 to 63 days.
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
-- Casting inside AVG preserves fractional days; format the displayed
-- result to two decimal places in the reporting tool.
-- The average resolution time across 13 resolved complaints was approx 51.15 days.


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
-- Categories with only 1 complaint should be interpreted cautiously.
-- Only resolved complaints were included in the analysis.


-- Business request:
-- Identify complaint types with at least 3 resolved complaints.
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
-- This allows the comparison of categories with a minimum complaint volume,
-- although sizes remain small.


-- Business request:
-- Identify the five open complaints that have been awaiting resolution the  
-- longest,to help priorities outstanding cases.
SELECT TOP 5 ComplaintID,
           DATEDIFF (DAY, ComplaintDate, GETDATE ()) AS [Days Awaiting Resolution]
FROM Complaints
WHERE Status = 'Open'
ORDER BY [Days Awaiting Resolution] DESC, ComplaintID ASC;
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


--===================================================================================================
-- WINDOW FUNCTIONS
--===================================================================================================

-- BUSINESS REQUEST:
-- Report resolved complaints by SLA result, showing their share of all resolved
-- complaints and overall compliance among resolved cases with known dates.
;WITH ResolvedSLA AS (
    SELECT CASE
        WHEN ResolutionDate IS NULL OR SLADueDate IS NULL THEN 'Unknown'
        WHEN ResolutionDate <= SLADueDate THEN 'On Time'
        ELSE 'Late'
    END AS SLAResult
    FROM Complaints
    WHERE Status = 'Resolved'
), SLACounts AS (
    SELECT SLAResult, COUNT(*) AS TotalComplaints
    FROM ResolvedSLA
    GROUP BY SLAResult
)
SELECT SLAResult,
       TotalComplaints,
       CAST(TotalComplaints * 100.0 /
            NULLIF(SUM(TotalComplaints) OVER (), 0) AS DECIMAL(5,2))
           AS PercentageOfAllResolved,
       CAST(SUM(CASE WHEN SLAResult = 'On Time' THEN TotalComplaints ELSE 0 END) OVER () * 100.0 /
            NULLIF(SUM(CASE WHEN SLAResult <> 'Unknown' THEN TotalComplaints ELSE 0 END) OVER (), 0)
            AS DECIMAL(5,2)) AS OverallKnownDateSLACompliancePct
FROM SLACounts
ORDER BY TotalComplaints DESC, SLAResult;
-- ANALYSIS:
-- Unknown dates remain visible in the resolved population and its distribution.
-- The compliance percentage excludes Unknown dates; NULL means no assessable cases.
-- The overall compliance value repeats across rows and must not be summed.
-- Historical result: 9 on time and 4 late (69.23% compliant); rerun to verify.

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
         AVG(CAST(FinanceAmount AS DECIMAL(19,4))) OVER (PARTITION BY FinanceType) AS DECIMAL (10,2)
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
-- Customer 1 has raised 2 complaints, demonstrating 
-- how repeat complaints can be identified.

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
        AVG (CAST(DATEDIFF (DAY, ComplaintDate, ResolutionDate) AS DECIMAL(10,2))) 
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
         ORDER BY ComplaintDate ASC, ComplaintID ASC
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
-- ranking their complaints from newest to oldest.
-- Display all complaints with the most recent numbered 1.
SELECT CustomerID,
       ComplaintID,
       ComplaintDate,
       Status,
       ROW_NUMBER () OVER (
         PARTITION BY CustomerID 
         ORDER BY ComplaintDate DESC, ComplaintID DESC
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
-- Rank finance agreements by value within each finance type.
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
-- RANK () ranks agreements separately for HP and PCP.
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
       ) AS [Dense Finance Rank]
FROM FinanceAgreements 
ORDER BY FinanceType ASC,
        [Dense Finance Rank] ASC,
        AgreementID ASC;
-- Analysis:
-- DENSE_RANK () ranks finance agreements separately for HP and PCP, 
-- from highest to lowest finance amount.
-- Agreement 2 is the highest-value HP agreement at £24,000, while 
-- agreement 13 is the highest-value PCP agreement at £33,500.
-- HP agreements 6 and 17 both have a finance amount of £12,500 and 
-- therefore share rank 6, without any gaps in the sequence.
-- This allows the business to compare agreement values within each
-- finance type while recognising agreements with identical amounts.


--==========================================================================================
-- SUBQUERIES AND COMMON TABLE EXPRESSIONS (CTEs)
--==========================================================================================

-- Business request:
-- Identify all finance agreements where the finance amount exceeds the overall average finance amount, 
-- allowing the finance manager to identify higher-value agreements.
SELECT AgreementID,
       FinanceAmount
FROM FinanceAgreements
WHERE FinanceAmount > (
    SELECT AVG(CAST(FinanceAmount AS DECIMAL(19,4))) 
    FROM Financeagreements
);
-- Analysis:
-- Used a subquery within the WHERE clause to calculate the overall average finance amount. 
-- The outer query the filters individual agreements against the calculated value.
-- The average was £21,641.18, with 9 agreements exceeding it. 
-- The subquery ensures the comparison updates automatically when the underlying data changes.
    

-- Business request:
-- Identify all finance agreements where the finance amount is below the overall average,
-- allowing the finance manager to identify lower-value agreeements.
SELECT AgreementID,
       FinanceAmount
FROM FinanceAgreements
WHERE FinanceAmount < (
    SELECT AVG(CAST(FinanceAmount AS DECIMAL(19,4)))
    FROM FinanceAgreements
);
-- Analysis:
-- Used a subquery within the WHERE clause to calculate the overall average finance amount of £21,641.18.
-- The outer query identified 8 agreements below the this average.
-- The average was £21,641.18, with 9 agreements exceeding it.
-- The comparison updates automatically when the underlying data changes.


-- Business request:
-- Identify all PCP finance agreements where the finance amount exceeds the average finance amount of HP agreements,
-- allowing the finance manager to compare agreement values across finance types.
SELECT AgreementID,
       FinanceType,
       FinanceAmount
FROM FinanceAgreements
WHERE FinanceType = 'PCP' 
  AND FinanceAmount > (
     SELECT AVG(CAST(FinanceAmount AS DECIMAL(19,4)))
     FROM FinanceAgreements
     WHERE FinanceType = 'HP'
);
-- Analysis:
-- Used a subquery to calculate the average finance amount for HP agreements.
-- The outer query filtered for PCP agreements with finance amounts exceeding this average.
-- All 10 PCP agreements met the criteria, demonstrating that every PCP agreement in the dataset 
-- has a finance amount above the HP average.


-- Business request:
-- Identify all HP finance agreements where the finance amount is 
-- below the average finance amount of PCP agreements.
-- Display the agreement ID, finance type and finance amount,
-- ordered from highest to lowest finance amount.
SELECT AgreementID,
       FinanceType,
       FinanceAmount
FROM FinanceAgreements 
WHERE FinanceType = 'HP'
  AND FinanceAmount < (
    SELECT AVG(CAST(FinanceAmount AS DECIMAL(19,4)))
    FROM FinanceAgreements
    WHERE FinanceType = 'PCP'
    
)
ORDER BY FinanceAmount DESC;
-- Analysis:
-- Used a subquery to calculate the average finance amount for PCP agreements.
-- The outer query filtered HP agreements below this average and ordered results
-- by finance amount in descending order.
-- All 7 HP agreements met the criteria, with the highest matching finance amount being £24,000.
     

-- Business request:
-- Identify all customers who have submitted at least one complaint.
-- Display customer ID and customer name, ordered alphabetically by customer name.
SELECT CustomerID,
       CustomerName
FROM Customers AS cust
WHERE EXISTS (
    SELECT 1
    FROM Complaints AS comp
    WHERE comp.CustomerID = cust.CustomerID
)
ORDER BY CustomerName ASC;
-- Analysis: 
-- Used an EXISTS correlated subquery to identify customers with at least one matching record
-- in the complaints table.
-- The inner query compares customer ID between the customer and complaints tables.
-- The query returned 15 customers, confirming that every customer in the current dataset 
-- has submitted at least one complaint.


-- Business request:
-- Identify all customers who have never submitted a complaint. 
-- Display their customer ID, customer name, ordered alphabetically by customer name.
SELECT CustomerID,
       CustomerName
FROM Customers AS cust
WHERE NOT EXISTS (
    SELECT 1
    FROM Complaints AS comp 
    WHERE comp.CustomerID = cust.CustomerID
)
ORDER BY CustomerName ASC;
-- Analysis:
-- Used a NOT EXISTS correlated subquery to identify customers with no matching records
-- in the complaints table.
-- The inner query compares customer ID between the customer and complaints tables.
-- The query returned zero records, confirming that all 15 customers have submitted at least one complaint.


-- Business request:
-- Identify all customers who have submitted at least one upheld complaint.
-- Display customer ID and customer name, ordered alphabetically by customer name.
SELECT CustomerID,
       CustomerName
FROM Customers AS cust
WHERE EXISTS (
    SELECT 1
    FROM Complaints AS comp
    WHERE comp.CustomerID = cust.CustomerID
    AND Outcome = 'Upheld'
)
ORDER BY CustomerName ASC;
-- Analysis:
-- Used an EXISTS correlated subquery to identify customers with at least one upheld complaint.
-- Matched customer ID between the customers and complaints tables and filtered the inner
-- query to Outcome = 'Upheld'.
-- The query returned 6 customers, each customer appears only once, regardless of how many 
-- upheld complaints they have submitted.


-- Business request:
-- Identify customers who have submitted complaints but never had a complaint upheld.
-- Display customer ID and customer name, ordered alphabetically by customer name.
SELECT CustomerID,
       CustomerName
FROM Customers AS cust
WHERE EXISTS (
    SELECT 1
    FROM Complaints AS comp
    WHERE comp.CustomerID = cust.CustomerID
  )
  AND NOT EXISTS (
    SELECT 1
    FROM Complaints AS comp
    WHERE comp.CustomerID = cust.CustomerID
    AND Outcome = 'Upheld'
 )
 ORDER BY CustomerName ASC;
-- Analysis:
-- Used EXISTS to identify customers with at least one complaint and NOT EXISTS to exclude customers 
-- with any upheld complaints.
-- Both correlated subquerys match customer ID between the customers and complaints tables.
-- The query returned 9 customers who have submitted complaints but have no upheld outcomes recorded.


-- Business request:
-- Identify all finance agreements where finance amount is below the average 
-- finance amount for their own type.
-- Display agreement ID, finance type, and finance amount, ordered by finance amount
-- lowest to highest.
SELECT AgreementID,
       FinanceType,
       FinanceAmount
FROM FinanceAgreements AS fin
WHERE FinanceAmount < (
    SELECT AVG(CAST(avgfin.FinanceAmount AS DECIMAL(19,4)))
    FROM FinanceAgreements AS avgfin
    WHERE fin.FinanceType = avgfin.FinanceType
)
ORDER BY FinanceAmount ASC;
-- Analysis:
-- Used a correlated scalar subquery with AVG(CAST(FinanceAmount AS DECIMAL(19,4))) to calculate the 
-- average finance amount for each agreements own finance type.
-- Filtered agreements where finance amount is below the corresponding finance type average.
-- The query returned 9 agreements consisting of 5 PCP agreements and 4 HP agreements.


-- Business request:
-- Identify customers who have at least one financeagreement with a finance amount 
-- greater than £25,000.
-- Display customer ID and customer name, ordered alphabetically by customer name, 
-- with each customer appearing only once.
SELECT CustomerID,
       CustomerName
FROM Customers AS cust
WHERE EXISTS (
      SELECT CustomerID
      FROM FinanceAgreements AS fin
      WHERE cust.CustomerID = fin.CustomerID
      AND FinanceAmount > 25000.00
)
ORDER BY CustomerName ASC;
-- Analysis:
-- Used an EXISTS subquery to identify customers associated with finance agreements 
-- exceeding £25,000.
-- Matched CustomerID between the customers and financeagreements tables to ensure each 
-- agreement belongs to the customer being examined.
-- The query returned 5 customers, matching the results of the previous IN query.

-- Business request:
-- Identify customers with at least one active finance 
-- agreement who have never had an upheld complaint.
-- Display each customer once, ordered alphabetically.
SELECT cust.CustomerID,
       cust.CustomerName
FROM Customers AS cust
WHERE EXISTS (
    SELECT 1 
    FROM FinanceAgreements AS fin
    WHERE fin.CustomerID = cust.CustomerID
    AND AgreementStatus = 'Active'
)
  AND NOT EXISTS (
    SELECT 1 
    FROM Complaints AS comp
    WHERE comp.CustomerID = cust.CustomerID
    AND Outcome = 'Upheld'
)
ORDER BY cust.CustomerName ASC;
-- Analysis:
-- Used correlated EXISTS to identify customers with active agreements 
-- and correlated NOT EXISTS to exclude customers with upheld complaints.
-- Returned 5 qualifying customers, sorted alphabetically.


-- Business request:
-- Identify customers with at least one active finance agreement where the finance amount 
-- exceeds the average for its own finance type, including all agreement statuses in the
-- average calculation.
SELECT cust.CustomerID,
       cust.CustomerName
FROM Customers AS cust
WHERE cust.CustomerID IN (
    SELECT fin.CustomerID
    FROM FinanceAgreements AS fin
    WHERE AgreementStatus = 'Active'
  AND fin.FinanceAmount > (
    SELECT AVG(CAST(avgfin.FinanceAmount AS DECIMAL(19,4)))
    FROM FinanceAgreements AS avgfin
    WHERE fin.FinanceType = avgfin.FinanceType
 ))
ORDER BY cust.CustomerName ASC;
-- Analysis: Used IN to identify qualifying customers and a correlated AVG subquery to 
-- compare each active agreement against the average for its own finance type.
-- Returned 5 qualifying customers, sorted alphabetically.
-- Customers are sorted alphabetically.


-- Business request:
-- Identify customers who have at least one active finance agreement and whose every active finance
-- agreement has a finance amount strictly below the average for its own finance type.
-- Calculate each finance type's average using all agreements, including Active and Settled.
SELECT cust.CustomerID,
       cust.CustomerName
FROM Customers AS cust
WHERE EXISTS (
    SELECT 1
    FROM FinanceAgreements AS fin 
    WHERE fin.CustomerID = cust.CustomerID
      AND AgreementStatus = 'Active'
)
 AND NOT EXISTS (
    SELECT 1 
    FROM FinanceAgreements AS failfin
    WHERE cust.CustomerID =  failfin.CustomerID
 AND failfin.AgreementStatus = 'Active' 
 AND (failfin.FinanceAmount IS NULL OR failfin.FinanceType IS NULL
       OR failfin.FinanceAmount >= (
    SELECT AVG(CAST(avgfin.FinanceAmount AS DECIMAL(19,4)))
    FROM FinanceAgreements AS avgfin
    WHERE avgfin.FinanceType = failfin.FinanceType
  ))
)
ORDER BY CustomerName ASC;
-- Analysis:
-- Used a correlated EXISTS subquery to confirm that each customer has at least one active finance agreement.
-- Used a correlated NOT EXISTS subquery to exclude customers with any active agreement whose finance amount is
-- greater than or equal to the average for its finance type. A nested AVG () subquery calculates the average across
-- all agreements of the matching finance type, regardless of the agreement status. This ensures every active agreement
-- belonging to a qualifying customer is strictly below its respective average.
-- Customers with an active agreement of unknown amount or finance type are excluded. 


-- Business request:
-- Identify customers who have at least one finance agreement and whose every finance agreement
-- has a finance amount of £25,000 or less. Include all agreement statuses, return each customer 
-- once and sort alphabetically by customer name.
SELECT cust.CustomerID,
       cust.CustomerName
FROM Customers AS cust 
WHERE EXISTS (
    SELECT 1
    FROM FinanceAgreements AS fin
    WHERE fin.CustomerID = cust.CustomerID 
)
AND NOT EXISTS (
    SELECT 1
    FROM FinanceAgreements AS checkfin
    WHERE cust.CustomerID = checkfin.CustomerID 
      AND (checkfin.FinanceAmount IS NULL OR checkfin.FinanceAmount > 25000.00)
)
ORDER BY cust.CustomerName ASC;
-- Analysis:
-- Used a correlated EXISTS subquery to confirm that each customer has at least one finance agreement.
-- Used NOT EXISTS to exclude customers with any agreement amount
-- above £25,000, or with an unknown amount.
-- The query returned 10 customers, sorted alphabetically.


-- Business request:
-- Showing all resolved complaints where the outcome was Upheld.
-- Include all complaint details and be sorted by ResolutionDate, 
-- with the most recently resolved complaints appearing first.
;WITH ResolvedComplaints AS (
    SELECT *
    FROM Complaints 
    WHERE Status = 'Resolved'
)
SELECT *
FROM ResolvedComplaints
WHERE Outcome = 'Upheld'
ORDER BY ResolutionDate DESC;
-- Analysis:
-- Created a Common Table Expression (CTE) named ResolvedComplaints to retrieve all complaints with a status of Resolved.
-- Queried the CTE to filter the results further, returning only complaints with an outcome of Upheld.
-- Used ORDER BY ResolutionDate DESC to display the most recently resolved complaints first.
-- The query executed successfully and returned 7 upheld complaints, ordered from newest to oldest.


-- Business request:
-- Generate a report identifying customers
-- with active finance agreements worth more than £15,000.
-- The report should display CustomerName, FinanceType and
-- FinanceAmount, ordered by FinanceAmount from highest to lowest.
;WITH ActiveAgreements AS (
    SELECT fin.FinanceType,
           fin.FinanceAmount,
           fin.CustomerID
    FROM FinanceAgreements AS fin 
    WHERE AgreementStatus = 'Active'
)
SELECT cust.CustomerName,
       fin.FinanceType,
       fin.FinanceAmount
FROM ActiveAgreements AS fin
INNER JOIN Customers AS cust
   ON cust.CustomerID = fin.CustomerID
WHERE FinanceAmount > 15000
ORDER BY fin.FinanceAmount DESC;
-- Analysis:
-- Created a Common Table Expression (CTE) named ActiveAgreements
-- to retrieve active finance agreements, including CustomerID
-- for joining to the Customers table.
-- Used an INNER JOIN to retrieve the customer names associated
-- with each qualifying finance agreement.
-- Filtered the results to agreements exceeding £15,000.
-- Used ORDER BY FinanceAmount DESC to display the highest
-- finance amounts first.
-- The query executed successfully and returned 9 agreements.


-- Business request:
-- Generate a report showing the total number
-- of complaints submitted by each customer.
-- Only customers with at least 2 complaints should be included.
-- The report should display CustomerName and TotalComplaints,
-- ordered by TotalComplaints from highest to lowest.
;WITH CustomerComplaintCounts AS (
     SELECT COUNT (ComplaintID) AS TotalComplaints,
            CustomerID
     FROM Complaints AS comp
     GROUP BY CustomerID 
) 
SELECT CustomerName,
       TotalComplaints
FROM CustomerComplaintCounts AS ccc
INNER JOIN Customers AS cust 
    ON cust.CustomerID = ccc.CustomerID
WHERE TotalComplaints >= 2
ORDER BY TotalComplaints DESC;
-- Analysis:
-- Created a Common Table Expression (CTE) named CustomerComplaintCounts
-- to calculate the total number of complaints for each customer.
-- Used COUNT(ComplaintID) and GROUP BY CustomerID to aggregate
-- complaints at customer level.
-- Used an INNER JOIN to connect the CTE to the Customers table
-- and retrieve the corresponding customer names.
-- Applied WHERE TotalComplaints >= 2 to exclude customers
-- with fewer than 2 complaints.
-- Used ORDER BY TotalComplaints DESC to sort the results
-- from highest to lowest complaint count.
-- The query executed successfully and returned 5 customers,
-- each with 2 complaints.


-- Business request:
-- Generate a report identifying finance agreements worth more than the average 
-- agreement amount for their own FinanceType.
-- The report should display AgreementID, FinanceType,
-- FinanceAmount and AverageFinanceAmount.
-- Include both Active and Settled agreements.
-- Order the results by FinanceAmount from highest to lowest.
;WITH FinanceTypeAverages AS (
    SELECT FinanceType,
          AVG(CAST(FinanceAmount AS DECIMAL(19,4))) AS AverageFinanceAmount
    FROM FinanceAgreements AS avgfin
    GROUP BY FinanceType 
)
SELECT fin.AgreementID,
       avgfin.FinanceType,
       fin.FinanceAmount,
       avgfin.AverageFinanceAmount
FROM FinanceTypeAverages AS avgfin
INNER JOIN FinanceAgreements AS fin
    ON fin.FinanceType = avgfin.FinanceType
WHERE FinanceAmount > AverageFinanceAmount
ORDER BY FinanceAmount DESC;
-- Analysis:
-- Created a Common Table Expression (CTE) named FinanceTypeAverages
-- to calculate the average FinanceAmount for each FinanceType.
-- Used AVG(CAST(FinanceAmount AS DECIMAL(19,4))) and GROUP BY FinanceType to produce
-- separate average values for PCP and HP agreements.
-- Used an INNER JOIN to connect individual finance agreements
-- to their corresponding FinanceType averages.
-- Applied WHERE FinanceAmount > AverageFinanceAmount to
-- identify agreements exceeding their own FinanceType average.
-- Used ORDER BY FinanceAmount DESC to display the highest
-- finance amounts first.
-- The query executed successfully and returned 8 agreements:
-- 5 PCP agreements and 3 HP agreements.


-- Business Request:
-- The manager has requested a report showing the average
-- finance amount and total number of complaints for each
-- finance type (PCP and HP).
-- Include all finance agreements, regardless of whether
-- they are Active or Settled, and include agreements
-- that have no associated complaints.
-- Count all complaints regardless of status or outcome.
-- Ensure that agreements with multiple complaints do not
-- distort the average finance amount.
-- Display zero instead of NULL where no complaints exist.
-- Order the results by total complaints, highest first.
;WITH FinanceTypeAverages AS (
      SELECT avgfin.FinanceType,
             CAST (
               AVG(CAST(FinanceAmount AS DECIMAL(19,4))) AS DECIMAL (10,2)
             ) AS [AverageFinanceAmount]
      FROM FinanceAgreements AS avgfin
      GROUP BY FinanceType
),
    FinanceTypeComplaints AS (
     SELECT compfin.FinanceType,
            COUNT (ComplaintID) AS [TotalComplaints]
     FROM Complaints AS comp
     INNER JOIN FinanceAgreements AS compfin
       ON compfin.AgreementID = comp.AgreementID
     GROUP BY FinanceType
)
SELECT fta.FinanceType,
       fta.AverageFinanceAmount,
       COALESCE(ftc.TotalComplaints, 0) AS TotalComplaints
FROM FinanceTypeAverages AS fta
LEFT JOIN FinanceTypeComplaints  ftc
  ON fta.FinanceType = ftc.FinanceType
ORDER BY TotalComplaints DESC;
-- Analysis:
-- Created two Common Table Expressions (CTEs) to calculate
-- finance averages and complaint totals independently.
-- The first CTE, FinanceTypeAverages, calculates the average
-- FinanceAmount for each FinanceType using AVG and GROUP BY.
-- This prevents agreements with multiple complaints from
-- being counted more than once in the average.
-- Used CAST with DECIMAL(10,2) to display the average
-- finance amounts to two decimal places.
-- The second CTE, FinanceTypeComplaints, uses an INNER JOIN
-- between Complaints and FinanceAgreements to count the
-- total complaints associated with each finance type.
-- Used a LEFT JOIN in the main query to combine both CTEs,
-- retaining finance types even if they have no complaints.
-- Used COALESCE to replace NULL complaint totals with zero.
-- Ordered the results by TotalComplaints DESC.
-- Results:
-- PCP: Average finance amount = 24,580.00
--      Total complaints = 14
-- HP:  Average finance amount = 17,442.86
--      Total complaints = 6
-- This approach prevents duplicated finance agreements.
-- from distorting the average when joining to complaints.


--=====================================================================================================
-- DATA QUALITY & QUERY OPTIMISATION
-- Correcting Inflated Averages
-- ====================================================================================================

-- Original Query Reference: Average agreement value for agreements with resolved complaints
--
-- Issue Identified:
-- Joining FinanceAgreements to Complaints creates
-- duplicate agreement rows where an agreement has
-- multiple complaints.
--
-- This can distort AVG(CAST(FinanceAmount AS DECIMAL(19,4))), as some
-- agreements contribute to the average more than once.
--
-- Objective:
-- Rewrite the original query using CTEs to ensure
-- each finance agreement contributes only once
-- to the average calculation.
;WITH FinanceTypeAverage AS (
      SELECT fin.FinanceType,
             CAST(AVG(CAST(FinanceAmount AS DECIMAL(19,4))) AS DECIMAL (10,2)
             ) AS AverageFinanceAmount 
      FROM FinanceAgreements AS fin
        WHERE EXISTS (
        SELECT 1
        FROM Complaints AS comp
        WHERE comp.AgreementID = fin.AgreementID 
        AND Status = 'Resolved'
)
      GROUP BY FinanceType 
      HAVING AVG(CAST(FinanceAmount AS DECIMAL(19,4))) > 20000.00)

SELECT *
FROM FinanceTypeAverage
ORDER BY AverageFinanceAmount DESC;
-- Analysis:
-- Revisited the superseded joined-average query, which calculated
-- the average finance amount for agreements associated
-- with resolved complaints.
--
-- Issue Identified:
-- The original INNER JOIN between FinanceAgreements and
-- Complaints produced duplicate finance agreement rows
-- where an agreement had multiple resolved complaints.
--
-- This caused some FinanceAmount values to contribute
-- more than once to the AVG calculation, potentially
-- producing misleading results.
--
-- Corrective Action:
-- Created a CTE named FinanceTypeAverage to calculate
-- the average finance amount for each FinanceType.
--
-- Used a correlated EXISTS subquery to identify finance
-- agreements with at least one resolved complaint.
--
-- EXISTS checks whether a matching complaint exists
-- without duplicating the finance agreement rows.
--
-- Used GROUP BY FinanceType to calculate the averages
-- and HAVING to retain finance types with an average
-- finance amount greater than 20,000.
--
-- Used CAST with DECIMAL(10,2) to format the average
-- to two decimal places.
--
-- Ordered the final results by AverageFinanceAmount DESC.
--
-- Results:
-- Original PCP average: approximately 25,163.00
-- Corrected PCP average: 25,150.00
-- Difference: approximately 13.00
--
-- PCP remained the only finance type above the
-- 20,000 threshold.
--
-- Conclusion:
-- The original query ran successfully but produced
-- a slightly distorted average due to duplicate rows.
--
-- Using EXISTS ensured each qualifying finance agreement
-- contributed only once to the average calculation.
--
-- This demonstrates the importance of validating
-- aggregate calculations when using one-to-many joins.


-- Business Request:
-- Revisit the superseded joined-average query to compare the
-- average finance agreement amounts for agreements with
-- complaints against agreements without complaints.
--
-- Investigate whether the original LEFT JOIN caused
-- duplicate finance agreement rows and distorted the
-- calculated averages.
--
-- Correct the query so that each finance agreement
-- contributes only once to its group's average.
--
-- Display the average finance amount for both groups,
-- ordered from highest to lowest.
  ;WITH AverageAgreementAmount AS (
  SELECT fin.FinanceAmount,
          CASE 
              WHEN EXISTS (
              SELECT 1 
              FROM Complaints AS comp
              WHERE comp.AgreementID = fin.AgreementID 
           )
              THEN 'Has Complaint'
            ELSE 'No Complaint'
          END AS [Complaint Status]
  FROM FinanceAgreements AS fin
  )
SELECT [Complaint Status],
       CAST (AVG(CAST(FinanceAmount AS DECIMAL(19,4))) AS DECIMAL (10,2)) AS [Average Finance Amount]
FROM AverageAgreementAmount
GROUP BY [Complaint Status]
ORDER BY [Average Finance Amount] DESC;
-- Analysis:
-- Revisited the original query, which used a LEFT JOIN
-- between FinanceAgreements and Complaints.
--
-- Issue Identified:
-- Agreements with multiple complaints appeared more than
-- once in the joined results.
--
-- This caused some finance amounts to contribute multiple
-- times to the AVG calculation, distorting the average
-- for agreements with complaints.
--
-- Corrective Action:
-- Created a CTE named AverageAgreementAmount to classify
-- each finance agreement before calculating averages.
--
-- Used CASE WHEN EXISTS with a correlated subquery to
-- check whether each agreement had at least one complaint.
--
-- Agreements with matching complaints were classified
-- as 'Has Complaint', while all remaining agreements
-- were classified as 'No Complaint'.
--
-- EXISTS allowed the query to identify matching complaints
-- without duplicating finance agreement rows.
--
-- The main SELECT used AVG(CAST(FinanceAmount AS DECIMAL(19,4))) and GROUP BY
-- [Complaint Status] to calculate the average for each
-- group, ordering the results from highest to lowest.
--
-- Results:
-- Has Complaint:
-- Original average = 23,190.00
-- Corrected average = 22,493.33
-- Difference = 696.67
--
-- No Complaint:
-- Original average = 15,250.00
-- Corrected average = 15,250.00
-- Difference = 0.00
--
-- Conclusion:
-- The original query overstated the average finance
-- amount for agreements with complaints by approximately
-- 696.67 due to duplicate rows from the LEFT JOIN.
--
-- The corrected query ensures each finance agreement
-- contributes only once to the average.
--
-- This demonstrates the importance of validating
-- aggregate calculations when working with one-to-many
-- relationships.


-- Business Request:
-- Compare the average total finance agreement value for
-- customers who have made complaints against customers
-- who have never made a complaint.
--
-- Calculate each customer's total finance agreement value
-- before calculating the average for each complaint group.
--
-- Include customers without finance agreements, treating
-- their total finance value as zero.
--
-- Ensure each customer is counted only once, regardless
-- of how many finance agreements or complaints they have.
--
-- Display ComplaintStatus, AverageFinanceTotals and
-- TotalCustomers, ordered by the highest average first.
;WITH CustomersTotal AS (
    SELECT cust.CustomerID,
           COALESCE (SUM (FinanceAmount), 0) AS FinanceTotals
    FROM Customers AS cust
       LEFT JOIN FinanceAgreements AS fin
         ON fin.CustomerID = cust.CustomerID
    GROUP BY cust.CustomerID      
),
CustomerComplaintStatus AS (
    SELECT CustomerID,
           CustomerName,
      CASE 
         WHEN EXISTS (
              SELECT 1
              FROM Complaints AS comp
              WHERE comp.CustomerID = cust.CustomerID
     ) 
        THEN 'Has Complaint'
        ELSE 'No Complaint' 
    END AS ComplaintStatus 
    FROM Customers AS cust 
)

SELECT ComplaintStatus,
       CAST (AVG(CAST(fintotal.FinanceTotals AS DECIMAL(19,4))) AS DECIMAL (10,2)) AS AverageFinanceTotals,
       COUNT (custcomp.CustomerID) AS TotalCustomers 
FROM CustomerComplaintStatus AS custcomp
   LEFT JOIN CustomersTotal AS fintotal
         ON fintotal.CustomerID = custcomp.CustomerID
GROUP BY ComplaintStatus
ORDER BY AverageFinanceTotals DESC;

-- Analysis:
-- Created two CTEs to calculate average customer finance
-- totals based on complaint history.
--
-- The first CTE used a LEFT JOIN between Customers and
-- FinanceAgreements to calculate the total finance amount
-- for each customer using SUM and GROUP BY.
--
-- COALESCE was used to return zero for customers without
-- finance agreements.
--
-- The second CTE used CASE WHEN EXISTS with a correlated
-- subquery to identify whether each customer had made
-- at least one complaint.
--
-- Customers were classified as either 'Has Complaint'
-- or 'No Complaint'.
--
-- The main query joined both CTEs using CustomerID,
-- calculated AVG(FinanceTotals) for each complaint group,
-- and counted the customers within each group.
--
-- Results:
-- Has Complaint:
-- Average customer finance total = 24,526.67
-- Total customers = 15
--
-- No Complaint:
-- No results returned for this group.
--
-- The results indicate that all customers in the
-- current dataset have at least one complaint.
--
-- A separate validation query was performed to confirm
-- the number of unique customers with complaints.
-- Data Validation:
-- Verify the number of unique customers in the database
-- and compare this against the number of unique customers
-- who have submitted at least one complaint.
--
-- DISTINCT prevents customers with multiple complaints
-- from being counted more than once.

SELECT
    COUNT(DISTINCT cust.CustomerID) AS TotalCustomers,
    COUNT(DISTINCT comp.CustomerID) AS CustomersWithComplaints
FROM Customers AS cust
LEFT JOIN Complaints AS comp
    ON cust.CustomerID = comp.CustomerID;
-- Validation Results:
-- Total customers = 15
-- Customers with complaints = 15
--
-- All 15 customers have submitted at least one complaint.
-- This confirms why the main CTE query returned only
-- the 'Has Complaint' group.
--
-- The absence of a 'No Complaint' row is consistent
-- with the current sample data.


-- BUSINESS REQUEST:
-- Management requires a report showing the most recent complaint
-- submitted by each customer, alongside their total complaint count.
--
-- Include the customer's name, complaint reference, complaint date,
-- status, outcome and total number of complaints.
--
-- Where a customer has multiple complaints on the same date,
-- use the highest ComplaintID to identify the most recent.
--
-- Each customer should appear once, with the most recent
-- complaint dates appearing first.
USE MotorFinanceComplaints
GO
;WITH LatestComplaint AS (
    SELECT CustomerID,
           ComplaintID,
           ComplaintDate,
           Status,
           Outcome,
           ROW_NUMBER () OVER (
              PARTITION BY CustomerID
              ORDER BY ComplaintDate DESC, ComplaintID DESC
              ) AS ComplaintRank,
           COUNT (*) OVER (
              PARTITION BY CustomerID
              ) AS CustomerComplaintTotal 
     FROM Complaints 
     )

SELECT lc.CustomerID,
       cust.CustomerName,
       lc.ComplaintID,
       lc.ComplaintDate,
       lc.Status,
       lc.Outcome,
       lc.CustomerComplaintTotal
FROM LatestComplaint AS lc
INNER JOIN Customers AS cust
    ON lc.CustomerID = cust.CustomerID
WHERE lc.ComplaintRank = 1
ORDER BY lc.ComplaintDate DESC, lc.ComplaintID DESC;
-- ANALYSIS:
-- A CTE was used to calculate complaint rankings and totals
-- for each customer.
--
-- ROW_NUMBER() identifies the most recent complaint per customer,
-- ordering by ComplaintDate and then ComplaintID descending.
--
-- COUNT(*) OVER (PARTITION BY CustomerID) calculates each
-- customer's total complaints without grouping away individual rows.
--
-- The main query filters ComplaintRank = 1 to return only
-- the most recent complaint for each customer.
--
-- An INNER JOIN retrieves the customer's name.
--
-- This allows management to review recent complaint activity
-- alongside each customer's overall complaint volume.
