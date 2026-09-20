USE MotorFinanceComplaints
GO

-- ==========================================================================================
-- FICTIONAL SAMPLE DATA
-- Motor Finance Complaints SQL Portfolio Project
-- ==========================================================================================

-- Customers

INSERT INTO Customers
(CustomerID, CustomerName, Age,Address, Postcode)
VALUES
(1,'Emma Carter',34,'12 Willow Steet','M1 4AB'),
(2,'Daniel Hughes',41,'8 Oak Avenue','OL67DF'),
(3,'Sophie Bennett',29,'24 Park Road','SK15 2AA'),
(4,'Michael Jones',52,'7 Church Lane','M34 5PL'),
(5,'Aisha Patel',38,'16 Meadow Close','OL7 9BGX'),
(6,'James Wilson',45,'31 King Street','M2 6AW'),
(7,'Olivia Taylor',26,'5 Rose Crescent','SK14 3DE'),
(8,'Mohammed Khan',33,'42 Market Street','OL6 6BH'),
(9,'Charlotte Evans',47,'19 Green Lane','M43 7NP'),
(10,'Thomas Walker',56,'63 High Street','SK16 4JQ'),
(11,'Emily Roberts',31,'11 Victoria Road','OL5 0HT'),
(12,'Ryan Cooper',24,'28 Mill Lane','M35 9DX'),
(13,'Priya Shah',42,'9 Birch Avenue','SK15 1PL'),
(14,'Benjamin Clarke',36,'54 Queens Road','OL8 2HG'),
(15,'Lucy Thompson',50,'17 Brook Steet','M34 3WT');


-- Vehicles

INSERT INTO Vehicles
(VehicleID,CustomerID,RegistrationPlate,Make,Model)
VALUES
(1,1,'AB21 CDE','Volkswagen','Golf'),
(2,2,'DK20 HJU','BMW','3 Series'),
(3,3,'SP22 KLM','Audi','A3'),
(4,4,'MJ19 RTE','Ford','Focus'),
(5,5,'AP21 NVC','Mercedes-Benz','A-Class'),
(6,6,'JW18 BGT','Vauxhall','Astra'),
(7,7,'OT23 LPK','Toyota','Yaris'),
(8,8,'MK20 ZXR','Volkswagen','Tiguan'),
(9,9,'CE21 FGH','Nissan','Qashqai'),
(10,10,'TW19 JKL','BMW','X1'),
(11,11,'ER22 MNP','Audi','Q3'),
(12,12,'RC23 STU','Ford','Fiesta'),
(13,13,'RC20 VWX','Mercedes-Benz','C-Class'),
(14,14,'BC21 YZA','Kia','Sportage'),
(15,15,'LT19 DEF','Hyundai','Tuscon');


-- Finance Agreements

INSERT INTO FinanceAgreements
(AgreementID,CustomerID,VehicleID,FinanceType,FinanceAmount,AgreementDate,AgreementStatus)
VALUES
(1,1,1,'PCP',18500.00,'2024-03-15','Active'),
(2,2,2,'HP',24000.00,'2023-06-10','Active'),
(3,3,3,'PCP',21500.00,'2024-09-12','Active'),
(4,4,4,'HP',14200.00,'2022-11-18','Active'),
(5,5,5,'PCP',26500.00,'2024-01-22','Settled'),
(6,6,6,'HP',12500.00,'2021-07-05','Settled'),
(7,7,7,'PCP',17900.00,'2025-02-14','Active'),
(8,8,8,'PCP',28900.00,'2023-10-30','Active'),
(9,9,9,'HP',22100.00,'2022-04-12','Settled'),
(10,10,10,'PCP',25500.00,'2024-05-08','Active'),
(11,11,11,'PCP',31000.00,'2025-01-16','Active'),
(12,12,12,'HP',13800.00,'2023-08-21','Active'),
(13,13,13,'PCP',33500.00,'2022-12-03','Settled'),
(14,14,14,'HP',23000.00,'2024-07-19','Active'),
(15,15,15,'PCP',24500.00,'2023-03-27','Settled');


-- Complaints

INSERT INTO Complaints
(ComplaintID,CustomerID,AgreementID,ComplaintType,ComplaintDate,SLADueDate,Status,Outcome,ResolutionDate)
VALUES
(1,1,1,'Commission Disclosure','2026-07-01','2026-08-26','Resolved','Upheld','2026-08-15'),
(2,2,2,'Affordability','2026-06-10','2026-08-05','Resolved','Not Upheld','2026-07-28'),
(3,3,3,'Commission Disclosure','2026-07-15','2026-09-09','Resolved','Upheld','2026-09-14'),
(4,4,4,'Customer Service','2026-08-02','2026-09-27','Open',NULL,NULL),
(5,5,5,'Early Settlement','2026-05-20','2026-07-15','Resolved','Upheld','2026-07-10'),
(6,6,6,'Affordability','2026-06-25','2026-08-20','Resolved','Not Upheld','2026-08-25'),
(7,7,7,'Vehicle Quality','2026-08-12','2026-10-07','Open',NULL,NULL),
(8,8,8,'Commission Disclosure','2026-04-05','2026-05-31','Resolved','Upheld','2026-05-20'),
(9,9,9,'Customer Service','2026-07-30','2026-09-24','Resolved','Not Upheld','2026-09-01'),
(10,10,10,'Affordability','2026-08-18','2026-10-13','Open',NULL,NULL),
(11,11,11,'Early Settlement','2026-03-10','2026-05-05','Resolved','Upheld','2026-05-12'),
(12,12,12,'Vehicle Quality','2026-06-14','2026-08-09','Resolved','Not Upheld','2026-08-02'),
(13,13,13,'Commission Disclosure','2026-08-25','2026-10-20','Open',NULL,NULL),
(14,14,14,'Customer Service','2026-05-03','2026-06-28','Resolved','Upheld','2026-06-21'),
(15,15,15,'Affordability','2026-07-09','2026-09-03','Resolved','Not Upheld','2026-08-30'),
(16,1,1,'Customer Service','2026-09-01','2026-10-27','Open',NULL,NULL),
(17,3,3,'Vehicle','2026-05-11','2026-07-06','Resolved','Upheld','2026-06-29'),
(18,5,5,'Customer Service','2026-08-29','2026-10-24','Open',NULL,NULL),
(19,8,8,'Early Settlement','2026-07-21','2026-09-15','Resolved','Not Upheld','2026-09-18'),
(20,11,11,'Affordability','2026-09-05','2026-10-31','Open',NULL,NULL);
