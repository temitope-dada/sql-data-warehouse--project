/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================

Script Purpose:
    This script creates views for the data warehouse's Gold layer.
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/


-- ===============================================================================
-- Create Dimension: gold.dim_customers
-- ===============================================================================

Create View Gold.dim_customers as
select
    Row_number() Over(order by cst_id) as Customer_key,
    ci.cst_id as customer_id,
    ci.cst_key as customer_number,
    ci.cst_firstname as first_name,
    ci.cst_lastname as last_name,
    la.CNTRY as country,
    ci.cst_marital_status as marital_status,
case when ci.cst_gndr !='n/a'  then ci.cst_gndr --Crm is the master gender
    else coalesce(ca.GEN, 'n/a')
    end as gender,  
    ca.BDATE as birthdate,
    ci.cst_create_date as create_date
from silver.crm_cust_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 AS ca
    on ci.cst_key = ca.CID
LEFT JOIN silver.erp_LOC_A101 AS la
    on ci.cst_key= la.CID;


-- ===============================================================================
-- Create Dimension: gold.dim_product
-- ===============================================================================

Create view Gold.dim_product as
Select
Row_number() Over(order by pn.prd_start_dt, pn.prd_key) as product_key,
  pn.prd_id as product_id,
  pn.prd_key as product_number,
  pn.prd_nm as product_name,
  pn.cat_id as category_id,
  pc.cat as category,
  pc.subcat as subcategory,
  pc.maintenance,
  pn.prd_cost as cost,
  pn.prd_line as line,
  pn.prd_start_dt as start_date
From silver.crm_prd_info as pn
Left join Silver.erp_PX_CAT_G1V2 as pc
on pn.cat_id = pc.ID
Where pn.prd_end_dt is null --Filter out all historical data

  
-- ===============================================================================
-- Create Dimension: gold.fact_sales
-- ===============================================================================
  
Create view Gold.fact_sales as
Select
  sd.sls_ord_num as order_number,
  pr.product_key,
  cu.Customer_key,
  sd.sls_order_dt as order_date,
  sd.sls_ship_dt as shipping_date,
  sd.sls_due_dt as due_date,
  sd.sls_sales as sales_amount,
  sd.sls_quantity as quantity,
  sd.sls_price as price
From silver.crm_sales_details as sd
Left join gold.dim_product as pr
on sd.sls_prd_key = pr.product_number
Left join gold.dim_customers as cu
on sd.sls_cust_id = cu.customer_id
