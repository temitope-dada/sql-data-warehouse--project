/*
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
================================================================================
*/


--Bulk inserting the datasets into table, telling SQL to recognise (,) as a delimiter and 2nd row as the starting point, using full load (truncate and insert)
EXEC Bronze.load_bronze;

GO
Create or Alter procedure Bronze.load_bronze as
BEGIN
   DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
  BEGIN TRY
  Set @batch_start_time = GETDATE();
		Print '===================================================';
		Print  'Loading the bronze layer';
		Print '===================================================';

		Print '---------------------------------------------------';
		Print 'Loading crm Tables';
		Print '---------------------------------------------------';

		Set @start_time = GETDATE();
		Print '>> truncating table: Bronze.crm_cust_info';
		Truncate Table Bronze.crm_cust_info;

		Print '>> inserting data into Bronze.crm_cust_info';
		Bulk Insert Bronze.crm_cust_info
		From 'C:\Users\Temitope Dada\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		With(
		  FirstRow = 2,
		  FieldTerminator = ',',
		  Tablock
		  );
		  Set @end_time = GETDATE();
          PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		  SET @end_time = GETDATE();
          PRINT '>> -----------------';

	    
		Set @start_time = GETDATE();
		Print '>> truncating table: Bronze.crm_prd_info';
		Truncate Table Bronze.crm_prd_info;

		Print '>> inserting data into Bronze.crm_prd_info';
		Bulk Insert Bronze.crm_prd_info
		From 'C:\Users\Temitope Dada\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		With(
		  FirstRow = 2,
		  FieldTerminator = ',',
		  Tablock
		  );
        Set @end_time = GETDATE();
          PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		  SET @end_time = GETDATE();
          PRINT '>> -----------------';


	    Set @start_time = GETDATE();
		Print '>> truncating table: Bronze.crm_sales_details';
		Truncate Table Bronze.crm_sales_details;

		Print '>> inserting data into Bronze.crm_sales_details';
		Bulk Insert Bronze.crm_sales_details
		From 'C:\Users\Temitope Dada\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		With (
		  FirstRow = 2,
		  FieldTerminator = ',',
		  Tablock
		  );
    Set @end_time = GETDATE();
          PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		  SET @end_time = GETDATE();
          PRINT '>> -----------------';


		Print '---------------------------------------------------';
		Print 'Loading erp Tables';
		Print '---------------------------------------------------';


	    Set @start_time = GETDATE();
		Print '>> truncating table: Bronze.erp_CUST_AZ12';
		Truncate Table Bronze.erp_CUST_AZ12;

		Print '>> inserting data into Bronze.erp_CUST_AZ12';
		Bulk Insert Bronze.erp_CUST_AZ12
		From 'C:\Users\Temitope Dada\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		With(
		  FirstRow = 2,
		  FieldTerminator = ',',
		  Tablock
		  );
       Set @end_time = GETDATE();
          PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		  SET @end_time = GETDATE();
          PRINT '>> -----------------';

        
	    Set @start_time = GETDATE();
		Print '>> truncating table: Bronze.erp_LOC_A101';
		Truncate Table Bronze.erp_LOC_A101;

		Print '>> inserting data into Bronze.erp_LOC_A101';
		Bulk Insert Bronze.erp_LOC_A101
		From 'C:\Users\Temitope Dada\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		With(
		  FirstRow = 2,
		  FieldTerminator = ',',
		  Tablock
		  );
		   Set @end_time = GETDATE();
          PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		  SET @end_time = GETDATE();
          PRINT '>> -----------------';


        Set @start_time = GETDATE();
		Print '>> truncating table: Bronze.erp_PX_CAT_G1V2';
		Truncate Table Bronze.erp_PX_CAT_G1V2;

		Print '>> inserting data into Bronze.erp_PX_CAT_G1V2';
		Bulk Insert Bronze.erp_PX_CAT_G1V2
		From 'C:\Users\Temitope Dada\Downloads\sql-data-warehouse-project (1)\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		With(
		  FirstRow = 2,
		  FieldTerminator = ',',
		  Tablock
		  );
		  Set @end_time = GETDATE();
          PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		  SET @end_time = GETDATE();
          PRINT '>> -----------------';

		  SET @batch_end_time = GETDATE();
			PRINT '========================================='
			PRINT 'Loading Bronze Layer is Completed';
			PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(10)) + ' seconds';
			PRINT '========================================='

   END TRY
   BEGIN CATCH
   PRINT ' ==============================================='
   PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Number:  ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
    PRINT 'Error State:   ' + CAST(ERROR_STATE() AS NVARCHAR(10));
    PRINT '========================================='
   END CATCH
END
;
