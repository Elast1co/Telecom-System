CREATE DATABASE Telecom_DWH;

-- ══════════════════════════════════════════════════════════════
-- DIMENSIONS
-- ══════════════════════════════════════════════════════════════

-- 1. DIM_DATE
CREATE TABLE Dim_Date (
    DateKey         INT PRIMARY KEY,  
    FullDate        DATE NOT NULL,
    Day             INT,
    DayName         VARCHAR(10),
    Week            INT,
    Month           INT,
    MonthName       VARCHAR(10),
    Quarter         INT,
    QuarterName     VARCHAR(10),
    Year            INT,
    IsWeekend       BIT,
    IsHoliday       BIT DEFAULT 0
);

-- 2. DIM_CUSTOMER
CREATE TABLE Dim_Customer (
    CustomerKey     INT PRIMARY KEY IDENTITY(1,1),
    CustomerID      INT,              -- source system ID
    FirstName       VARCHAR(40),
    LastName        VARCHAR(40),
    FullName        AS (FirstName + ' ' + LastName),
    Gender          VARCHAR(10),
    City            VARCHAR(50),
    AgeGroup        VARCHAR(20),      -- 18-25, 26-35, 36-50, 50+
    -- SCD Type 2
    StartDate       DATE,
    EndDate         DATE,
    IsCurrent       BIT DEFAULT 1
);

-- 3. DIM_PLAN
CREATE TABLE Dim_Plan (
    PlanKey         INT PRIMARY KEY IDENTITY(1,1),
    PlanID          INT,
    PlanName        VARCHAR(40),
    Monthly_Price   DECIMAL(10,2),
    Data_Limit_GB   DECIMAL(6,2),
    SMS_Limit       INT,
    PlanTier        VARCHAR(20),      -- Basic, Standard, Plus, Pro, Unlimited
    -- SCD Type 2
    StartDate       DATE,
    EndDate         DATE,
    IsCurrent       BIT DEFAULT 1
);

-- 4. DIM_PROMOTION
CREATE TABLE Dim_Promotion (
    PromotionKey    INT PRIMARY KEY IDENTITY(1,1),
    PromotionID     INT,
    PromotionName   VARCHAR(50),
    Discount_Percent INT,
    StartDate       DATE,
    EndDate         DATE
);

-- 5. DIM_CAMPAIGN
CREATE TABLE Dim_Campaign (
    CampaignKey     INT PRIMARY KEY IDENTITY(1,1),
    CampaignID      INT,
    CampaignName    VARCHAR(50),
    StartDate       DATE,
    EndDate         DATE,
    Notes           VARCHAR(255)
);

-- ══════════════════════════════════════════════════════════════
-- FACTS
-- ══════════════════════════════════════════════════════════════

-- 1. FACT_SUBSCRIPTION
CREATE TABLE Fact_Subscription (
    SubscriptionKey     INT PRIMARY KEY IDENTITY(1,1),
    SubscriptionID      INT,
    CustomerKey         INT FOREIGN KEY REFERENCES Dim_Customer(CustomerKey),
    PlanKey             INT FOREIGN KEY REFERENCES Dim_Plan(PlanKey),
    PromotionKey        INT FOREIGN KEY REFERENCES Dim_Promotion(PromotionKey),
    StartDateKey        INT FOREIGN KEY REFERENCES Dim_Date(DateKey),
    EndDateKey          INT FOREIGN KEY REFERENCES Dim_Date(DateKey),
    Subscription_Type   VARCHAR(15),
    SubStatus           VARCHAR(25),
    DurationDays        INT,          -- calculated: EndDate - StartDate
    IsChurned           BIT DEFAULT 0
);

-- 2. FACT_PAYMENT
CREATE TABLE Fact_Payment (
    PaymentKey          INT PRIMARY KEY IDENTITY(1,1),
    PaymentID           INT,
    SubscriptionKey     INT FOREIGN KEY REFERENCES Fact_Subscription(SubscriptionKey),
    CustomerKey         INT FOREIGN KEY REFERENCES Dim_Customer(CustomerKey),
    PlanKey             INT FOREIGN KEY REFERENCES Dim_Plan(PlanKey),
    DateKey             INT FOREIGN KEY REFERENCES Dim_Date(DateKey),
    Amount              DECIMAL(10,2),
    Payment_Status      VARCHAR(15),
    Payment_Method      VARCHAR(20)
);

-- 3. FACT_USAGE
CREATE TABLE Fact_Usage (
    UsageKey            INT PRIMARY KEY IDENTITY(1,1),
    UsageID             INT,
    SubscriptionKey     INT FOREIGN KEY REFERENCES Fact_Subscription(SubscriptionKey),
    CustomerKey         INT FOREIGN KEY REFERENCES Dim_Customer(CustomerKey),
    PlanKey             INT FOREIGN KEY REFERENCES Dim_Plan(PlanKey),
    DateKey             INT FOREIGN KEY REFERENCES Dim_Date(DateKey),
    Call_Minutes        INT,
    SMS_Count           INT,
    Data_GB             DECIMAL(6,2)
);

-- 4. FACT_CHURN
CREATE TABLE Fact_Churn (
    ChurnKey            INT PRIMARY KEY IDENTITY(1,1),
    ChurnID             INT,
    SubscriptionKey     INT FOREIGN KEY REFERENCES Fact_Subscription(SubscriptionKey),
    CustomerKey         INT FOREIGN KEY REFERENCES Dim_Customer(CustomerKey),
    PlanKey             INT FOREIGN KEY REFERENCES Dim_Plan(PlanKey),
    CampaignKey         INT FOREIGN KEY REFERENCES Dim_Campaign(CampaignKey),
    ChurnDateKey        INT FOREIGN KEY REFERENCES Dim_Date(DateKey),
    ComebackDateKey     INT FOREIGN KEY REFERENCES Dim_Date(DateKey),
    Churn_Reason        VARCHAR(50),
    IsRecovered         BIT DEFAULT 0  -- 1 if customer came back
);

-- 5. FACT_COMPLAINT
CREATE TABLE Fact_Complaint (
    ComplaintKey        INT PRIMARY KEY IDENTITY(1,1),
    ComplaintID         INT,
    CustomerKey         INT FOREIGN KEY REFERENCES Dim_Customer(CustomerKey),
    SubscriptionKey     INT FOREIGN KEY REFERENCES Fact_Subscription(SubscriptionKey),
    DateKey             INT FOREIGN KEY REFERENCES Dim_Date(DateKey),
    Complaint_Type      VARCHAR(30),
    Complaint_Status    VARCHAR(15)
);