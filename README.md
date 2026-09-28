# 🌟 SQL Data Warehouse Project

## 👋 Hello Everyone!

Welcome to my **SQL Data Warehouse Project**, where I designed and built a modern data warehouse from scratch using **PostgreSQL** and the **Medallion Architecture**.

This project demonstrates core **Data Engineering** concepts including:

✅ Data Warehousing  
✅ ETL Development  
✅ Data Cleaning & Transformation  
✅ Data Modeling  
✅ Star Schema Design  
✅ PostgreSQL Development  

---

# 🏗️ Project Overview

The objective of this project is to transform raw business data into an analytics-ready data warehouse using a layered architecture.

The warehouse follows the **Medallion Architecture**:

### 🥉 Bronze Layer (Raw Data)
- Stores raw source data without modifications.
- Acts as the ingestion layer.
- Preserves original data for auditing and recovery.

### 🥈 Silver Layer (Cleaned & Transformed Data)
- Cleans and standardizes raw data.
- Removes inconsistencies and duplicates.
- Applies business transformation rules.

### 🥇 Gold Layer (Business-Ready Data)
- Contains analytical models optimized for reporting.
- Implements a Star Schema design.
- Provides dimension and fact tables for business analysis.

---

# 🌐 Data Architecture

## Overall Architecture Diagram

> <<img width="800" height="452" alt="System Architecture main" src="https://github.com/user-attachments/assets/925386f2-5406-4a84-bf2d-b3ac4df5f20d" />



---

# 📊 Medallion Architecture

## Bronze Layer

### Purpose
- Ingest source files into PostgreSQL.
- Maintain data lineage.
- Store data exactly as received.

---

## Silver Layer

### Purpose
- Data cleansing
- Standardization
- Deduplication
- Data integration

---

## Gold Layer

### Purpose
- Business-ready analytical models
- Star schema implementation
- Optimized reporting structures

---

# ⭐ Data Modeling

The Gold Layer follows a **Star Schema** design.

## Star Schema Diagram

> <img width="921" height="428" alt="star schema main" src="https://github.com/user-attachments/assets/18aa6ce6-9f06-4b32-bcbb-1c6fe028bb5a" />



---

# 🛠️ Tech Stack

### Database
- PostgreSQL

### Development
- SQL
- PL/pgSQL

### Data Architecture
- Medallion Architecture
- Star Schema Modeling

### Documentation & Diagramming
- Draw.io
- Markdown

---
