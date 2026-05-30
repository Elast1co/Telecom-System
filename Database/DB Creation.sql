CREATE TABLE Customer (
CustomerID INT PRIMARY KEY IDENTITY(1,1) ,
FirstName VARCHAR(40) NOT NULL,
LastName VARCHAR(40) NOT NULL,
Email VARCHAR(40) UNIQUE NOT NULL,
DOB DATE,
Gender VARCHAR(20) ,
Phone VARCHAR(25) UNIQUE NOT NULL,
Created_At DATETIME DEFAULT GETDATE(),
Updated_At DATETIME
);

CREATE TABLE Plans (
PlanID INT PRIMARY KEY IDENTITY(1,1),
PlanName VARCHAR(40) UNIQUE NOT NULL,
Monthly_Price INT,
Data_Limit_GB INT,
SMS_Limit INT,
Created_At DATETIME DEFAULT GETDATE(),
Updated_At DATETIME
);

CREATE TABLE Promotion (
PromotionID INT PRIMARY KEY IDENTITY(1,1),
PromtionName VARCHAR(25) UNIQUE NOT NULL,
StartDate Date,
EndDate Date,
Discount_Percent int,
Notes VARCHAR(70)
);

CREATE TABLE Reactivation_Campaign(
CampaignID INT PRIMARY KEY IDENTITY(1,1),
CampaignName VARCHAR(25) UNIQUE NOT NULL,
StartDate Date,
EndDate Date,
Notes VARCHAR(25)
);

CREATE TABLE Subscription(
SubscriptionID INT PRIMARY KEY IDENTITY(1,1),
Subscription_Type VARCHAR(15),
CustomerID INT,
PlanID INT,
SubStatus VARCHAR(25),
StartDate DATE,
EndDate DATE,
Created_At DATETIME DEFAULT GETDATE(),
Updated_At DATETIME,
CONSTRAINT FK_Subscription_Customer
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),

CONSTRAINT FK_Subscription_Plan
FOREIGN KEY (PlanID) REFERENCES Plans(PlanID)
);

CREATE TABLE Payment(
PaymentID INT PRIMARY KEY IDENTITY(1,1),
Payment_Date DATE,
Amount INT,
Payment_Status VARCHAR(15),
Payment_Methood VARCHAR(20),
SubscriptionID INT,
CONSTRAINT FK_Subscription_Payment
FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
);

CREATE TABLE Campaign_Target(
TargetID INT PRIMARY KEY IDENTITY(1,1),
Target_Date DATE,
Contact VARCHAR(20),
CampaignID INT,
CustomerID INT,
CONSTRAINT FK_Campaign_Target
FOREIGN KEY (CampaignID) REFERENCES Reactivation_Campaign(CampaignID),
CONSTRAINT FK_Customer_Target
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Usage_Daily(
UsageID INT PRIMARY KEY IDENTITY(1,1),
UsageDate DATE,
Call_Minutes INT,
SMS_COUNT INT,
Data_GB INT,
SubscriptionID INT,
CONSTRAINT FK_Usage_Subscription
FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
);

CREATE TABLE Complaint(
ComplaintID INT PRIMARY KEY IDENTITY(1,1),
Complaint_Date DATE,
Complaint_Type VARCHAR(15),
Complaint_Status VARCHAR(15),
Notes VARCHAR(15),
CustomerID INT,
SubscriptionID INT,
CONSTRAINT FK_Complaint_Customer
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
CONSTRAINT FK_Complaint_Subscription
FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
);

CREATE TABLE Customer_Promotion(
Customer_PromoID INT PRIMARY KEY IDENTITY(1,1),
Redeemed BIT,
Applied_Date DATETIME2 DEFAULT GETDATE(),
CustomerID INT,
PromotionID INT,
CONSTRAINT FK_CusPromotion_Customer
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
CONSTRAINT FK_CusPromotion_Promotion
FOREIGN KEY (PromotionID) REFERENCES Promotion(PromotionID)

);

CREATE TABLE Subscription_Event(
EventID INT PRIMARY KEY IDENTITY(1,1),
Event_Type VARCHAR(15),
Event_Date DATETIME2,
NOTES VARCHAR(15),
Old_PlanID INT,
New_PlanID INT,
SubscriptionID INT,
CONSTRAINT FK_SubEvent_OldPlan
FOREIGN KEY (Old_PlanID) REFERENCES Plans(PlanID),

CONSTRAINT FK_SubEvent_NewPlan
FOREIGN KEY (New_PlanID) REFERENCES Plans(PlanID),

CONSTRAINT FK_EVENT_Subscription
FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
);

CREATE TABLE Churn_Record (
    ChurnID        INT PRIMARY KEY IDENTITY(1,1),
    ChurnDate      DATE,
    Churn_Reason   VARCHAR(50), 
    Comeback_Date  DATE,         
    SubscriptionID INT,
    CampaignID     INT,          
    CONSTRAINT FK_Churn_Sub      FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID),
    CONSTRAINT FK_Churn_Campaign FOREIGN KEY (CampaignID)     REFERENCES Reactivation_Campaign(CampaignID)
);

