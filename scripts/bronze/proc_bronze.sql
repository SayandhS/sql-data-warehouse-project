/*=====================================================================================
Stored Procedure: Stored procedure query only for truncate because postgres does not support /copy in server.
=====================================================================================
This script containes the stored procedure for truncating the tables in the bronze layers, it should then be followed by directly running the 
psql script in the **load_bronze.sql** file using the /COPY command.
=====================================================================================
Parameters: Does not contain any parameters and returns no values.
=====================================================================================
Usage Example: CALL bronze.load_bronze();
*/
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
	BEGIN
		RAISE NOTICE 'Now truncating tables for initializing LOAD procedure';
		RAISE NOTICE '==============================================================';
		RAISE NOTICE 'Proceed to run \copy commands directly in psql';
		RAISE NOTICE 'First CRM tables, then ERP tables';
	    TRUNCATE TABLE bronze.crm_cust_info;
	    TRUNCATE TABLE bronze.crm_prd_info;
	    TRUNCATE TABLE bronze.crm_sales_details;
	    TRUNCATE TABLE bronze.erp_loc_a101;
	    TRUNCATE TABLE bronze.erp_cust_az12;
	    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Bronze Load Failed: %', SQLERRM;

	END;
$$;
