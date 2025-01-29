-- Active: 1738161270598@@sql-server@1433@Datawarehouses@bronz
IF OBJECT_ID('bronz.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronz.crm_cust_info;
CREATE TABLE bronz.crm_cust_info
(
    cst_id INT ,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50) ,
    cst_lastname NVARCHAR(50) ,
    cst_marital_status NVARCHAR(10) ,
    cst_gndr CHAR(5),
    cst_create_date DATE
);

CREATE OR ALTER PROCEDURE sp_crmcust AS
BEGIN
DECLARE @set_begin_time DATETIME ;
BEGIN TRY
    SET @set_begin_time = GETDATE();
    PRINT '======================================='
    PRINT 'LOADING THE DATE FROM Customer_CRM'

    PRINT 'LOADING THE DATA NOW BEFORE TRUNCATE THE TABLE'
    TRUNCATE TABLE bronz.crm_cust_info;

    BULK INSERT bronz.crm_cust_info 
    FROM '/usr/database/datasets/source_crm/cust_info.csv'
    WITH
    (
        FIRSTROW = 2 ,
        FIELDTERMINATOR = ',',
        TABLOCK
    );
END TRY
BEGIN CATCH
PRINT 'ERROR OCCURED IN MY FINCTION '
PRINT CONCAT('ERROR MESSAGE ' , CAST(ERROR_MESSAGE() AS VARCHAR));
PRINT CONCAT('ERROR MESSAGE ' , CAST(ERROR_NUMBER() AS VARCHAR));
END CATCH
END;

EXEC sp_crmcust ;

SELECT * FROM bronz.crm_cust_info;