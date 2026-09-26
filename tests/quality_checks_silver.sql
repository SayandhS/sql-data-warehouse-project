/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/
-- --------------------------------------------------------------------------
--For CRM_CUST_INFO
-- --------------------------------------------------------------------------
--Check for Nulls or Duplicates in primary key
--Expectation: no result
SELECT cst_id,
		COUNT(*)
		FROM silver.crm_cust_info
		GROUP BY cst_id
		HAVING COUNT(*)>1 OR cst_id IS NULL;

--Check for unwanted spaces
--Expectation: no results

select
	   cst_firstname,
	   cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname!=TRIM(cst_firstname) OR cst_lastname!=TRIM(cst_lastname);

--Data standardization & consistency
SELECT DISTINCT cst_material_status
FROM silver.crm_cust_info;

SELECT * FROM silver.crm_cust_info;

-- ---------------------------------------------------------------------------
--For CRM_PRD_INFO
-- ---------------------------------------------------------------------------
--Check for unwanted spaces
--Expectation: no results

select
	   prd_nm
FROM silver.crm_prd_info
WHERE prd_nm!=TRIM(prd_nm);

--Check for nulls or negative numbers
--Expectation: No Result

SELECT
	   prd_id,
	   prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<0;

-- Check for invalid date orders

SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt<prd_start_dt;

--Data standardization & consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- ---------------------------------------------------------------------------
--For CRM_SALES_DETAILS
-- ---------------------------------------------------------------------------
-- Check for invalid dates
SELECT
NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 
	OR LENGTH(CAST(sls_order_dt AS TEXT))!=8 
	OR sls_order_dt > 20500101 
	OR sls_order_dt < 19000101;

-- Check for Invalid Orders 
SELECT * FROM bronze.crm_sales_details
WHERE sls_order_dt>sls_ship_dt OR sls_ship_dt>sls_due_dt;

-- Check for Sales Busines Validity
SELECT DISTINCT
	   sls_sales AS old_sls_sales,
	   sls_quantity,
	   sls_price AS old_sls_price,
	   CASE WHEN sls_sales IS NULL 
	   			OR sls_sales<=0 
			    OR sls_sales!=sls_quantity*ABS(sls_price)
				THEN sls_quantity*ABS(sls_price)
			ELSE sls_sales
	   END AS sls_sales,
	   CASE WHEN sls_price IS NULL OR sls_price<=0
	   			THEN sls_sales / NULLIF(sls_quantity,0)
			ELSE sls_price
		END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales!= sls_quantity * sls_price 
OR sls_sales IS NULL
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_sales <=0
OR sls_quantity <=0
OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price;


-- ---------------------------------------------------------------------------
--For ERP_CUST_AZ12
-- ---------------------------------------------------------------------------
-- Check out-of-range dates
SELECT DISTINCT bdate
	FROM bronze.erp_cust_az12
	WHERE bdate<='1924-01-01' OR bdate>CURRENT_TIMESTAMP;

-- Data standardization and Normalisation

SELECT gen,
	CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
		 ELSE 'n/a'
	END AS gen
	FROM bronze.erp_cust_az12;


-- ---------------------------------------------------------------------------
--For ERP_LOC_A101
-- ---------------------------------------------------------------------------
-- Data standardization & normalisation
SELECT DISTINCT cntry,
				CASE WHEN UPPER(TRIM(cntry)) IN ('US','United States','USA') THEN 'United States'
					 WHEN UPPER(TRIM(cntry)) IN ('Germany','DE') THEN 'Germany'
					 WHEN TRIM(cntry)='' OR cntry IS NULL THEN 'n/a'
					 ELSE TRIM(cntry)
				END AS cntry_new			
FROM bronze.erp_loc_a101
ORDER BY cntry;

-- ---------------------------------------------------------------------------
--For ERP_PX_CAT_G1V2
-- ---------------------------------------------------------------------------
-- Check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE TRIM(cat)!=cat OR TRIM(sub_cat)!=sub_cat OR TRIM(maintainence)!=maintainence;
