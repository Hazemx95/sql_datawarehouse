-- Active: 1739013587682@@sql-server@1433@DATAWARE_HOUSE@Bronz

/*
    Store procedure 
    DDL Objects
    Schemas
    Tracbility and debugenig
*/

--CODE (DATA INGEST) --
CREATE OR ALTER PROCEDURE Bronz.sp_crmcust_info AS
BEGIN
-- In this case in bronz layer Extract data (Full Loaded)
-- Extract Method (Pull extraction)
-- Extract Type (Full loaded) ---> TRUNCATE & INSERT
    IF OBJECT_ID('Bronz.crm_cust_info', 'U') IS NOT NULL
        DROP TABLE Bronz.crm_cust_info;
    CREATE TABLE Bronz.crm_cust_info
    (
        cst_id INT ,
        cst_key NVARCHAR(50),
        cst_firstname NVARCHAR(50) ,
        cst_lastname NVARCHAR(50) ,
        cst_marital_status NVARCHAR(10) ,
        cst_gndr CHAR(5),
        cst_create_date DATE
    );

DECLARE @set_begin_time DATETIME ;
DECLARE @set_end_time DATETIME ;
BEGIN TRY
    SET @set_begin_time = GETDATE();
    PRINT '======================================='
    PRINT 'LOADING THE DATE FROM Customer_INFO_CRM'
    PRINT 'LOADING THE DATA NOW BEFORE TRUNCATE THE TABLE' + CAST(@set_begin_time AS NVARCHAR)
    TRUNCATE TABLE Bronz.crm_cust_info;
    BULK INSERT Bronz.crm_cust_info 
    FROM '/usr/database/datasets/source_crm/cust_info.csv'
    WITH
    (
        FIRSTROW = 2 ,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
    SET @set_end_time = GETDATE()

    PRINT 'The Time Differene between the date before and after full inseration' + CAST(DATEDIFF(SECOND ,@set_begin_time,@set_end_time) AS NVARCHAR) 

    -- CREATE TABLE IN BRONZ SCHEMA (Bronz.crm_prd_info) --
    PRINT 'NOW LOADED THE DATA IN BRONZ.crm_prd_info' + 'AND THE TIME NOW BEFORE CREATED THIS TABLE ' ;
    SET @set_begin_time = GETDATE();
    IF OBJECT_ID('Bronz.crm_prd_info','U') IS NOT NULL 
        DROP TABLE Bronz.crm_prd_info;
    CREATE TABLE Bronz.crm_prd_info
    (
        prd_id INT DEFAULT NULL ,
        prd_key NVARCHAR(30) ,
        prd_nm NVARCHAR(50) ,
        prd_cost NVARCHAR(30) ,
        prd_line NVARCHAR(30),
        prd_start_dt DATETIME2,
        prd_end_dt DATETIME2
    );

    BULK INSERT Bronz.crm_prd_info
    FROM '/usr/database/datasets/source_crm/prd_info.csv'
    WITH
    (
        FIRSTROW = 2 ,
        FIELDTERMINATOR = ',',
        TABLOCK  
    );
    SET @set_end_time = GETDATE()
    PRINT 'The Time Differene between the date before and after full inseration' + CAST(DATEDIFF(SECOND ,@set_begin_time,@set_end_time) AS NVARCHAR) 
END TRY
BEGIN CATCH
    PRINT 'ERROR OCCURED IN MY FINCTION '
    PRINT CONCAT('ERROR MESSAGE ' , CAST(ERROR_MESSAGE() AS VARCHAR));
    PRINT CONCAT('ERROR MESSAGE ' , CAST(ERROR_NUMBER() AS VARCHAR));
END CATCH
END

EXEC Bronz.sp_crmcust_info ;
SELECT * FROM Bronz.crm_prd_info;
DROP PROCEDURE Bronz.sp_crmcust_info;




