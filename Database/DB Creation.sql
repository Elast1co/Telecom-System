CREATE TABLE Customer (
Customer_Id INT IDENTITY (1,1) PRIMARY KEY,
First_Name NVARCHAR(100),
Last_Name NVARCHAR(100),
Email NVARCHAR(150),
Phone NVARCHAR(50),
Date_Of_Birth DATE,
Gender NVARCHAR,
create_at DATETIME2,
updated_at DATETIME2
)

CREATE TABLE Plans (
Plan_Id INT IDENTITY (1,1) PRIMARY KEY,
Plan_Names NVARCHAR(100) ,
Monthly_Prices INT ,