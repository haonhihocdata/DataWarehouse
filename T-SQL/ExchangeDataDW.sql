--DROP DATABASE IF EXISTS ExchangeAnalysisDW;

--CREATE DATABASE ExchangeAnalysisDW
--GO

--USE ExchangeAnalysisDW


CREATE TABLE stgStockData (
	[id] INT IDENTITY PRIMARY KEY,
	[stock_date] NVARCHAR(100),
	[symbol] NVARCHAR(5),
	[open] VARCHAR(100),
	[high] VARCHAR(100),
	[low] VARCHAR(100),
	[close] VARCHAR(100),
	[volume] VARCHAR(100),
	[divident_amount] VARCHAR(100)
);

--drop table CompanyOverview
CREATE TABLE [dbo].[stgCompanyOverview](
	[id] INT IDENTITY PRIMARY KEY,
	[symbol] [varchar](100) NULL,
	[company_id] INT,
	[name] [varchar](100) NULL,
	[currency] [varchar](100) NULL,
	[country] [varchar](100) NULL,
	[sector] [varchar](100) NULL,
	[address] [varchar](200) NULL,
	[latest_quarter_date] [date] NULL,
	[full_time_employees] INT,
	[market_capitalization] [float] NULL,
	[dividend_per_share] [float] NULL,
	[dividend_yield] [float] NULL,
	[quarterly_earnings_growth] [float] NULL,
	[quarterly_revenue_growth] [float] NULL,
	[start_date] [date] NULL
) ON [PRIMARY]



CREATE TABLE stgQuarterlyEarnings (
	[id] INT IDENTITY PRIMARY KEY,
	[symbol] VARCHAR(100),
	[fiscal_date_ending] VARCHAR(100),
	[reported_date] VARCHAR(100),
	[reported_EPS] VARCHAR(100),
	[estimated_EPS] VARCHAR(100),
	[surprise_EPS] VARCHAR(100),
	[surprise_percentage] VARCHAR(100)
);
CREATE TABLE stgIncomeStatement (
	[id] INT IDENTITY PRIMARY KEY,
	[symbol] VARCHAR(100),
	[fiscal_date_ending] VARCHAR(100),
	[reportedCurrency] VARCHAR(100),
	[total_revenue] VARCHAR(100),
	[gross_profit] VARCHAR(100),
	[net_income] VARCHAR(100),
	[total_operating_expense] VARCHAR(100),
	[research_and_development_cost] VARCHAR(100)
);

CREATE TABLE [dbo].[stgCurrency](
	[id] INT IDENTITY PRIMARY KEY,
	[Country] [varchar](50) NULL,
	[CurrencyName] [varchar](50) NULL,
	[Currency] [varchar](50) NULL
) ON [PRIMARY]




--/***temp stg stock table***/
--CREATE TABLE [dbo].[stgDailyStockData](
--	[stock_date] [varchar](100) NULL,
--	[symbol] [varchar](100) NULL,
--	[open] [varchar](100) NULL,
--	[high] [varchar](100) NULL,
--	[low] [varchar](100) NULL,
--	[close] [varchar](100) NULL,
--	[volume] [varchar](100) NULL,
--	[divident_amount] [varchar](100) NULL
--) ON [PRIMARY]
--GO





CREATE TABLE stgQuarterlyFacts (
	[company_id] INT,
	[date_id] INT,
	[sector_id] INT,
	[currency_id] INT,
	[symbol] VARCHAR(5),
	[name] VARCHAR(100),
	[address] VARCHAR(200),
	[sector] VARCHAR(30),
	[currency] VARCHAR(30),
	[full_time_employees] INT,
	[market_capitalization] FLOAT,
	[dividend_per_share] FLOAT,
	[dividend_yield] FLOAT,
	[reported_EPS] FLOAT,
	[estimated_EPS] FLOAT,
	[surprise_EPS] FLOAT,
	[fiscal_date_ending] date
)

/***daily temp fact table***/
CREATE TABLE stgDayFacts (
	[company_id] INT,
	[date_id] INT,
	sector_id INT,
	currency_id INT,
	[open] FLOAT,
	[high] FLOAT,
	[low] FLOAT,
	[close] FLOAT,
	[volume] FLOAT,
	[Daily_Date] date
);



CREATE TABLE DimCompanyInfo (
	[company_key] INT IDENTITY PRIMARY KEY,
	[symbol] VARCHAR(10),
	[name] VARCHAR(50),
	[sector] VARCHAR(50),
	[address] VARCHAR(200),
	[current] BIT,
	[start_date] DATE,
	[end_date] DATE,
	[updated_date] DATE
);

CREATE TABLE DimCompanyOverview (
	[overview_key] INT IDENTITY PRIMARY KEY,
	[overview_id] INT,
	[company_id] INT FOREIGN KEY REFERENCES DimCompanyInfo([company_key]),
	[latest_quarter_date] DATE,
	[full_time_employees] INT,
	[market_capitalization] FLOAT,
	[dividend_per_share] FLOAT,
	[dividend_yield] FLOAT,
	[quarterly_earnings_growth] FLOAT,
	[quarterly_revenue_growth] FLOAT,
	[current] BIT DEFAULT 1,
	[start_date] DATE DEFAULT GETDATE(),
	[end_date] DATE DEFAULT GETDATE(),
);

CREATE TABLE DimStockPrice (
	[price_key] INT IDENTITY PRIMARY KEY,
	[price_id] INT,
	[company_id] INT FOREIGN KEY REFERENCES DimCompanyInfo([company_key]),
	[open] FLOAT,
	[high] FLOAT,
	[low] FLOAT,
	[close] FLOAT,
	[volume] INT,
	[divident_amount] FLOAT,
	[stock_date] DATE,
	[recorded_date] DATE,
	[current] BIT DEFAULT 1,
	[start_date] DATE DEFAULT GETDATE(),
	[end_date] DATE DEFAULT GETDATE(),
);

CREATE TABLE DimQuarterlyEarnings (
	[earn_key] INT IDENTITY PRIMARY KEY,
	[earn_id] INT,
	[company_id] INT FOREIGN KEY REFERENCES DimCompanyInfo([company_key]),
	[fiscal_date_ending] DATE,
	[reported_EPS] FLOAT,
	[estimated_EPS] FLOAT,
	[surprise_EPS] FLOAT,
	[surprise_percentage] FLOAT,
	[recorded_date] DATE,
	[current] BIT DEFAULT 1,
	[start_date] DATE DEFAULT GETDATE(),
	[end_date] DATE DEFAULT GETDATE(),
);

CREATE TABLE DimIncomeStatement (
	[statement_key] INT IDENTITY PRIMARY KEY,
	[statement_id] INT,
	[company_id] INT FOREIGN KEY REFERENCES DimCompanyInfo([company_key]),
	[fiscal_date_ending] DATE,
	[reportedCurrency] VARCHAR(30),
	[total_revenue] FLOAT,
	[gross_profit] FLOAT,
	[net_income] FLOAT,
	[total_operating_expense] FLOAT,
	[research_and_development_cost] FLOAT,
	[recorded_date] DATE,
	[current] BIT DEFAULT 1,
	[start_date] DATE DEFAULT GETDATE(),
	[end_date] DATE DEFAULT GETDATE(),
);

CREATE TABLE  DimSector(
	[sector_key] INT IDENTITY PRIMARY KEY,
	[sector] VARCHAR(30)
);

CREATE TABLE DimDate (
	[date_key] INT IDENTITY PRIMARY KEY,
	[TheDate] DATE,
	[TheDay] INT,
	[TheDayName] VARCHAR(30),
	[TheWeek] INT,
	[TheDayOfWeek] INT,
	[TheMonth] INT,
	[TheMonthName] VARCHAR(30),
	[TheQuarter] INT,
	[TheYear] INT
);



CREATE TABLE DimCurrency (
	[currency_key] INT IDENTITY PRIMARY KEY,
	[currency] VARCHAR(30),
	[currencyName] [varchar](50) NULL,
	[current] BIT DEFAULT 1,
	[start_date] DATE DEFAULT GETDATE(),
	[end_date] DATE DEFAULT GETDATE(),
);

/***facts tables***/
CREATE TABLE FactStockDaily (
	[factSD_id] INT IDENTITY PRIMARY KEY,
	[company_key] INT FOREIGN KEY REFERENCES DimCompanyInfo([company_key]),
	[date_key] INT FOREIGN KEY REFERENCES DimDate([date_key]),
	[sector_key] INT FOREIGN KEY REFERENCES DimSector([sector_key]),
	[currency_key] INT FOREIGN KEY REFERENCES DimCurrency([currency_key]),
	[open] FLOAT,
	[high] FLOAT,
	[low] FLOAT,
	[close] FLOAT,
	[volume] FLOAT,
);


CREATE TABLE FactStockQuarter (
	[factSQ_id] INT IDENTITY PRIMARY KEY,
	[company_key] INT FOREIGN KEY REFERENCES DimCompanyInfo([company_key]),
	[date_key] INT FOREIGN KEY REFERENCES DimDate([date_key]),
	[sector_key] INT FOREIGN KEY REFERENCES DimSector([sector_key]),
	[currency_key] INT FOREIGN KEY REFERENCES DimCurrency([currency_key]),
	[full_time_employees] INT,
	[market_capitalization] FLOAT,
	[dividend_per_share] FLOAT,
	[dividend_yield] FLOAT,
	[reported_EPS] FLOAT,
	[estimated_EPS] FLOAT,
	[surprise_EPS] FLOAT
);


--UPDATE DimIncomeStatement
--SET    DimIncomeStatement.[company_id] = DimCompanyInfo.company_id
--FROM     DimCompanyInfo INNER JOIN
--         stgIncomeStatement ON DimCompanyInfo.symbol = stgIncomeStatement.symbol
--WHERE DimIncomeStatement.statement_id = stgIncomeStatement.id

--UPDATE  stgDayFacts
--SET stgDayFacts.[date_id] = DimDate.[date_key]
--FROM stgDayFacts
--JOIN DimDate
--ON stgDayFacts.[Daily_Date] = DimDate.[TheDate]


--SET DATEFIRST  7, -- 1 = Monday, 7 = Sunday
--    DATEFORMAT mdy, 
--    LANGUAGE   US_ENGLISH

--DECLARE @StartDate  date = '19800101';

--DECLARE @CutoffDate date = DATEADD(DAY, -1, DATEADD(YEAR, 60, @StartDate));

--WITH seq(n) AS 
-- (
--   SELECT 0 UNION ALL SELECT n + 1 FROM seq
--   WHERE n < DATEDIFF(DAY, @StartDate, @CutoffDate)
-- ),
--d(d) AS 
--(
--  SELECT DATEADD(DAY, n, @StartDate) FROM seq
--),
--src AS
--(
--  SELECT
--    TheDate         = CONVERT(date, d),
--    TheDay          = DATEPART(DAY,       d),
--    TheDayName      = DATENAME(WEEKDAY,   d),
--    TheWeek         = DATEPART(WEEK,      d),
--    TheDayOfWeek    = DATEPART(WEEKDAY,   d),
--    TheMonth        = DATEPART(MONTH,     d),
--    TheMonthName    = DATENAME(MONTH,     d),
--    TheQuarter      = DATEPART(Quarter,   d),
--    TheYear         = DATEPART(YEAR,      d)
--  FROM d
--)

--INSERT INTO DimDate
--  SELECT * FROM src
--  ORDER BY TheDate
--  OPTION (MAXRECURSION 0);


--  INSERT INTO
--    stgDayFacts
--(
--[company_id],
--[open],
--[high],
--[low],
--[close],
--[volume],
--[Daily_Date])
-- SELECT
-- [company_id],
-- [open],
-- [high],
-- [low],
-- [close],
-- [volume],
-- [stock_date]
-- From DimStockPrice
delete from DimDate

--UPDATE DimStockPrice
--SET    DimStockPrice.[company_id] = DimCompanyInfo.company_key
--FROM     DimCompanyInfo INNER JOIN
--         stgStockData ON DimCompanyInfo.symbol = stgStockData.symbol
--WHERE DimStockPrice.price_id = stgStockData.id

--UPDATE stgCompanyOverview
--SET ExchangeAnalysisDW.dbo.stgCompanyOverview.company_id = ExchangeAnalysisDW.dbo.DimCompanyInfo.company_key

--FROM ExchangeAnalysisDW.dbo.stgCompanyOverview
--INNER JOIN ExchangeAnalysisDW.dbo.DimCompanyInfo
--ON ExchangeAnalysisDW.dbo.stgCompanyOverview.[symbol] = ExchangeAnalysisDW.dbo.DimCompanyInfo.[symbol]