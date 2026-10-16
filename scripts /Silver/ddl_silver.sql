/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
          Run this script to redefine the DDL structure of 'bronze' Tables
===============================================================================
*/

--Creating Loading table fom bronze layer to silver layer
DROP TABLE IF EXISTS silver.crm_prd_info;
Create Table Silver.crm_cust_info (
	cst_id Int,
	cst_key Nvarchar(50),
	cst_firstname NVarchar(50),
	cst_lastname NVarchar(50),
	cst_marital_status NVarchar(50),
	cst_gndr NVarchar(50),
	cst_create_date Date
);

DROP TABLE IF EXISTS silver.crm_prd_info;
Create Table Silver.crm_prd_info (
	prd_id Int,
	prd_key Nvarchar(50),
    cat_id Nvarchar(50),
	prd_nm NVarchar(50),
	prd_cost INT,
	prd_line NVarchar(50),
	prd_start_dt Date,
	prd_end_dt Date,
    dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);

DROP TABLE IF EXISTS silver.crm_sales_details;
Create Table Silver.crm_sales_details (
	sls_ord_num Nvarchar(50),
	sls_prd_key Nvarchar(50),
	sls_cust_id INT,
	sls_order_dt Date,
	sls_ship_dt Date,
	sls_due_dt Date,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);

DROP TABLE IF EXISTS silver.erp_CUST_AZ12;
Create Table Silver.erp_CUST_AZ12 (
	CID Nvarchar(50),
	BDATE Date,
	GEN Nvarchar(50),    
	dwh_create_date DATETIME2 DEFAULT SYSDATETIME()
);

DROP TABLE IF EXISTS silver.erp_LOC_A101;
Create Table Silver.erp_LOC_A101 (
	CID Nvarchar(50),
	CNTRY Nvarchar(50)
);

DROP TABLE IF EXISTS silver.erp_PX_CAT_G1V2;
Create Table Silver.erp_PX_CAT_G1V2 (
	ID Nvarchar(50),
	CAT Nvarchar(50),
    SUBCAT Nvarchar(50),
    MAINTENANCE Nvarchar(50)
);
