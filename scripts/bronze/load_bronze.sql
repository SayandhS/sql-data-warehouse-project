/*=====================================================================================
Load Procedure: loading query directly to be run one by one in the psql tool interface using /COPY command.
=====================================================================================
This script contains the commands for loading the data directly into the database using the psql tool. Directly running the 
psql script in the **load_bronze.sql** file using the /COPY command.
=====================================================================================
Usage Example: \copy bronze.crm_cust_info FROM 'C:/Users/sayan/Desktop/Bara sql/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' WITH (FORMAT csv, HEADER true);
*/

\copy bronze.crm_cust_info FROM 'C:/Users/sayan/Desktop/Bara sql/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' WITH (FORMAT csv, HEADER true);

\copy bronze.crm_prd_info FROM 'C:/Users/sayan/Desktop/Bara sql/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' WITH (FORMAT csv, HEADER true);

\copy bronze.crm_sales_details FROM 'C:/Users/sayan/Desktop/Bara sql/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' WITH (FORMAT csv, HEADER true);

\copy bronze.erp_loc_a101 FROM 'C:/Users/sayan/Desktop/Bara sql/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv' WITH (FORMAT csv, HEADER true);

\copy bronze.erp_cust_az12 FROM 'C:/Users/sayan/Desktop/Bara sql/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' WITH (FORMAT csv, HEADER true);

\copy bronze.erp_px_cat_g1v2 FROM 'C:/Users/sayan/Desktop/Bara sql/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv' WITH (FORMAT csv, HEADER true);
