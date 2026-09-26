/*=====================================================================================
Validation:For validating whether all the data has been succesfully loaded to the database.
=====================================================================================
This script containes the validation queries for counting the number of rows affected to check if the data has been successfully loaded into the tables
=====================================================================================
Parameters: Returns the number of rows affected
====================================================================================
*/
SELECT COUNT(*) FROM silver.crm_cust_info;
SELECT COUNT(*) FROM silver.crm_prd_info;
SELECT COUNT(*) FROM silver.crm_sales_details;
SELECT COUNT(*) FROM silver.erp_loc_a101;
SELECT COUNT(*) FROM silver.erp_cust_az12;
SELECT COUNT(*) FROM silver.erp_px_cat_g1v2;
