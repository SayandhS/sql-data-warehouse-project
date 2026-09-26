/*=====================================================================================
Stored Procedure: Stored procedure query for truncate and loading data into SILVER Layer.
=====================================================================================
This script containes the stored procedure for truncating the tables and loading the transformed data
into the silver layers, it should then be followed by calling the stored procedure using the CALL command.
=====================================================================================
Usage Example: CALL silver.load_silver();
*/
CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
	BEGIN
		RAISE NOTICE 'Now truncating tables for initializing LOAD procedure in the silver layer';
		RAISE NOTICE '==============================================================';
		RAISE NOTICE 'First CRM tables, then ERP tables';
	    TRUNCATE TABLE silver.crm_cust_info;
	    TRUNCATE TABLE silver.crm_prd_info;
	    TRUNCATE TABLE silver.crm_sales_details;
	    TRUNCATE TABLE silver.erp_loc_a101;
	    TRUNCATE TABLE silver.erp_cust_az12;
	    TRUNCATE TABLE silver.erp_px_cat_g1v2;
		RAISE NOTICE '==============================================================';
		RAISE NOTICE 'Now loading data into tables for completing LOAD procedure in the silver layer';
		INSERT INTO silver.crm_cust_info(
						cst_id,
						cst_key,
						cst_firstname,
						cst_lastname,
						cst_material_status,
						cst_gndr,
						cst_create_date)
						SELECT 
							cst_id,
							cst_key,
							TRIM(cst_firstname) AS cst_firstname,
							TRIM(cst_lastname) AS cst_lastname,
							CASE WHEN UPPER(TRIM(cst_material_status))='S' THEN 'Single'
								 WHEN UPPER(TRIM(cst_material_status))='M' THEN 'Married'
								ELSE 'n/a'
							END cst_material_status,
							CASE WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
								 WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
								ELSE 'n/a'
							END cst_gndr,
							cst_create_date
						FROM(
						SELECT *,
						ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
						FROM bronze.crm_cust_info
						WHERE cst_id IS NOT NULL)
						WHERE flag_last=1;
		INSERT INTO silver.crm_prd_info(
						prd_id,
						cat_id,
						prd_key,
						prd_nm,
						prd_cost,
						prd_line,
						prd_start_dt,
						prd_end_dt)
						SELECT prd_id,
							   REPLACE (SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
							   REPLACE (SUBSTRING(prd_key,7,LENGTH(prd_key)),'-','_') AS prd_key,
							   prd_nm,
							   COALESCE(prd_cost, 0) AS prd_cost,
							   CASE WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
							   		WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
									WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
									WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
									ELSE 'n/a'
							  END AS prd_line,
							   (prd_start_dt)::DATE,
							   (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)- INTERVAL '1 day')::DATE AS prd_end_dt
					    FROM bronze.crm_prd_info;
		INSERT INTO silver.crm_sales_details(
				sls_ord_num,
				sls_prd_key,
				sls_cust_id,
				sls_order_dt,
				sls_ship_dt,
				sls_due_dt,
				sls_sales,
				sls_quantity,
				sls_price)
						SELECT sls_ord_num,	
							   sls_prd_key,
							   sls_cust_id,
							   CASE WHEN sls_order_dt = 0 OR LENGTH(CAST(sls_order_dt AS TEXT))!=8 THEN NULL
							   ELSE  CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
							   END AS sls_order_dt,
							   CASE WHEN sls_ship_dt = 0 OR LENGTH(CAST(sls_ship_dt AS TEXT))!=8 THEN NULL
							   ELSE  CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
							   END AS sls_ship_dt,
							   CASE WHEN sls_due_dt = 0 OR LENGTH(CAST(sls_due_dt AS TEXT))!=8 THEN NULL
							   ELSE  CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
							   END AS sls_due_dt,
							   CASE WHEN sls_sales IS NULL 
							   			OR sls_sales<=0 
									    OR sls_sales!=sls_quantity*ABS(sls_price)
										THEN sls_quantity*ABS(sls_price)
									ELSE sls_sales
							   END AS sls_sales,
							   sls_quantity,
							   CASE WHEN sls_price IS NULL OR sls_price<=0
							   			THEN sls_sales / NULLIF(sls_quantity,0)
									ELSE sls_price
								END AS sls_price
						FROM bronze.crm_sales_details;
		INSERT INTO silver.erp_cust_az12(
				cid,
				bdate,
				gen)
						SELECT
							   CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,LENGTH(cid))
							   		ELSE cid
							   END AS cid,
							   CASE WHEN bdate>CURRENT_TIMESTAMP THEN NULL
							   		ELSE bdate
							   END AS bdate,
							   CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
									WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
									ELSE 'n/a'
							   END AS gen
						FROM bronze.erp_cust_az12;
		INSERT INTO silver.erp_loc_a101 (
					cid, cntry)
						SELECT REPLACE(cid,'-','') cid,
							   CASE WHEN UPPER(TRIM(cntry)) IN ('US','UNITED STATES','USA') THEN 'United States'
									WHEN UPPER(TRIM(cntry)) IN ('GERMANY','DE') THEN 'Germany'
									WHEN TRIM(cntry)='' OR cntry IS NULL THEN 'n/a'
									ELSE TRIM(cntry)
									END AS cntry
						FROM bronze.erp_loc_a101;
		INSERT INTO silver.erp_px_cat_g1v2(id, cat, subcat, maintainence)
						SELECT id, cat, subcat, maintainence
						FROM bronze.erp_px_cat_g1v2;
	EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'silver Load Failed: %', SQLERRM;

	END;
$$;
