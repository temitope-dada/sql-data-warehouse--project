--foreign key intergrity
Select
* From Gold.fact_sales f
Left join Gold.dim_customers c
on c.customer_key = f.customer_key
Where c.customer_key is null

--Checking for duplicates in product tables using prd_key
Select prd_key, count (*) From(
Select
  pn.prd_id,
  pn.cat_id,
  pn.prd_key,
  pn.prd_nm,
  pn.prd_cost,
  pn.prd_line,
  pn.prd_start_dt,
  pc.cat,
  pc.subcat,
  pc.maintenance
From gold.crm_prd_info as pn
Left join gold.erp_PX_CAT_G1V2 as pc
on pn.cat_id = pc.ID
Where pn.prd_end_dt is null --Filter out all historical data
)t Group by prd_key
Having count(*) > 1
