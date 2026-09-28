/*=====================================================================================
Validation:For validating whether the views in the gold layer have been succesfully created
=====================================================================================
This script containes the validation queries for counting the number of rows affected to check if the view has been created
=====================================================================================
Parameters: Returns the number of rows affected
====================================================================================
*/

SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products;
SELECT * FROM gold.fact_sales;
