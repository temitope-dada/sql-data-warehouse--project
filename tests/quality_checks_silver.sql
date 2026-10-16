/*
================================================================================
Quality Checks
================================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
     - Null or duplicate primary keys.
     - Unwanted spaces in string fields.
     - Data standardization and consistency.
     - Invalid date ranges and orders.
     - Data consistency between related fields.

Usage Notes:
     - Run these checks after data loading Silver Layer.
     - Investigate and resolve any discrepancies found during the checks.
================================================================================
*/

-- ============================================================================
-- Checking 'silver.crm_cust_info'
-- ============================================================================


--checking for outliers, and non-unique values
Select
cst_id,
Count(*)
From Silver.crm_cust_info
Group by cst_id
Having count(*) > 1 or cst_id is null

---Check for un wanted spaces
--Expectation: No result
Select
cst_firstname
From Silver.crm_cust_info
where cst_firstname != Trim(cst_firstname)

Select
cst_lastname
From Silver.crm_cust_info
where cst_lastname != Trim(cst_lastname)

Select
cst_gndr
From Silver.crm_cust_info
where cst_gndr != Trim(cst_gndr)

Select
cst_marital_status
From Silver.crm_cust_info
where cst_marital_status != Trim(cst_marital_status)

----Checking data standardization & consistency
Select Distinct cst_gndr
From Silver.crm_cust_info

Select Distinct cst_marital_status
From Silver.crm_cust_info

Select *
From Silver.crm_cust_info

-----Exploring the Silver.crm_prd_info table
Select 
prd_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
From Silver.crm_prd_info

--Checking for Null or duplicates in the primary key
--Expections; No result

Select
prd_id,
Count(*)
From Silver.crm_prd_info
Group by prd_id
Having count(*) > 1 or prd_id is null

--Check for unwanted spaces
--Expectation: No result
Select
prd_nm
From Silver.crm_prd_info
where prd_nm != Trim(prd_nm)

--Check for Null or negative values  (that is very common with cost
--Expectation: No result
Select
prd_cost
From Silver.crm_prd_info
where prd_cost < 0 or prd_cost is null 

---Checking data standardization & consistency
Select Distinct prd_line
From Silver.crm_prd_info

---Checking invalid date order
Select *
From Silver.crm_prd_info
Where prd_end_dt < prd_start_dt 

-----Exploring the Bronze.crm_sales_detailes table
Select 
[sls_ord_num],
[sls_prd_key],
[sls_cust_id]
[sls_order_dt],
[sls_ship_dt],
[sls_due_dt],
[sls_sales],
[sls_quantity],
[sls_price]
From Bronze.crm_sales_details
Where sls_cust_id Not in ( Select cst_id From silver.crm_cust_info)
--Where sls_prd_key Not in ( Select Prd_key From silver.crm_prd_info) -- To check if sales prd key values exist prd key from prd info
--Where sls_ord_num != Trim(sls_ord_num)-- To check for white spaces

--Checking for invalid dates
Select
Nullif(sls_order_dt,0) as sls_order_dt--- to replace zero dates to null as null in dates is better than zero
From Bronze.crm_sales_details
Where sls_order_dt > 205000101 
or sls_order_dt < 19000101 -- checking for date outliers by validating the boundary of the date range
or sls_order_dt <= 0 -- to check for negative values and zero dates  
or Len (sls_order_dt) != 8-- to check if the length of dates is not 8  

--Checking if the order date is higher than ship and due date
   SELECT *
FROM Bronze.crm_sales_details
WHERE
    CASE
        WHEN sls_order_dt <= 0
          OR LEN(CAST(sls_order_dt AS VARCHAR(8))) <> 8
        THEN NULL
        ELSE TRY_CONVERT(DATE, CAST(sls_order_dt AS VARCHAR(8)), 112)
    END > sls_ship_dt

    OR
    CASE
        WHEN sls_order_dt <= 0
          OR LEN(CAST(sls_order_dt AS VARCHAR(8))) <> 8
        THEN NULL
        ELSE TRY_CONVERT(DATE, CAST(sls_order_dt AS VARCHAR(8)), 112)
    END > sls_due_dt;


-- Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative.
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != (sls_quantity * sls_price)
Or sls_sales is null or sls_quantity is null or sls_price is null
Or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
ORDER BY sls_sales,
    sls_quantity,
    sls_price

/* Since negative values and inconsistent relationships exist btw sales, qty and price. Here are the rules I followed
Rules
--If Sales is negative, zero, or null, derive it using Quantity
--If Price is zero or null, calculate it using Sales and Quantity
--If Price is negative, convert it to a positive value*/
SELECT DISTINCT
    sls_sales as old_sls_sales,
    sls_price as old_sls_price,
     sls_quantity,
    Case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
          Then sls_quantity * abs(sls_price)
          Else sls_sales
          End sls_sales,
    Case when sls_price is null or sls_price <=0 
          Then sls_sales /Nullif (sls_quantity,0) 
          Else sls_price
          End sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != (sls_quantity * sls_price)
Or sls_sales is null or sls_quantity is null or sls_price is null
Or sls_sales <= 0 or sls_quantity <= 0 or sls_price <= 0
ORDER BY sls_sales,
    sls_quantity,
    sls_price

-----Exploring the Bronze.[erp_CUST_AZ12] table
Select
CID,
BDATE,
GEN
From Silver.erp_cust_az12

-----Identify out of range dates 
Select Distinct
   BDATE
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' or BDATE> getdate() ---and BDATE> getdate()(to check if bdate is higher than current date)

---Data standardization and consistency
SELECT Distinct
    gen
FROM silver.erp_cust_az12


---Data standardization and consistency
SELECT Distinct
    cntry
FROM silver.erp_LOC_A101


-- Check for unwanted Spaces
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

---Data standardization and consistency
SELECT Distinct
    CAT,
    SUBCAT,
    MAINTENANCE
FROM silver.erp_px_cat_g1v2
