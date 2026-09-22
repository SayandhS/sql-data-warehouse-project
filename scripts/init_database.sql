/* -- Create database manually in pgAdmin
-- Database Name: DataWarehouse

-- Alternative:
-- CREATE DATABASE DataWarehouse;
--Additonally the three schemas, bronze, silver and gold are created.
WARNING: In Postgres a database has to be created manually inside pgAdmin, then the scripts for creating the schemas must 
          executed inside a query tool.
*/
--Create Schemas
CREATE SCHEMA IF NOT EXISTS bronze;

CREATE SCHEMA IF NOT EXISTS silver;

CREATE SCHEMA IF NOT EXISTS gold;
