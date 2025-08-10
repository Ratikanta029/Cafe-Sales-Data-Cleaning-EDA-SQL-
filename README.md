# Cafe Sales Data Cleaning & Exploratory Data Analysis (SQL)
# Project Overview
This project demonstrates data cleaning and exploratory data analysis (EDA) using SQL on a dirty cafe sales dataset containing 10,000 rows of synthetic transaction data.
The dataset is intentionally messy — with missing values, inconsistent entries, and incorrect data types — to replicate real-world data challenges faced by data analysts.

The objective was to clean the dataset, ensure accuracy, and prepare it for further analysis, enabling meaningful business insights.

# Dataset Details
File Name: dirty_cafe_sales.csv
Rows: 10,000
Columns: 8

# Column Name	Description	Example Values
Transaction ID	Unique ID for each transaction	TXN_1234567
Item	Item purchased (may contain invalid values)	Coffee, Sandwich
Quantity	Quantity purchased (may have missing/invalid values)	1, 3, UNKNOWN
Price Per Unit	Price of each item	2.00, 4.00
Total Spent	Quantity × Price Per Unit	8.00, 12.00
Payment Method	Mode of payment	Cash, Credit Card
Location	Transaction location	In-store, Takeaway
Transaction Date	Date of transaction	2023-01-01

# Data Challenges
Missing Values: Fields like Item, Payment Method, Location had NULL or empty cells.

Invalid Entries: Incorrect values like "ERROR", "UNKNOWN".

Data Type Mismatches: Numeric fields stored as text.

Price Inconsistency: Incorrect or missing price values.

Date Format Issues: Inconsistent transaction date formats.

# SQL Data Cleaning Steps
Removed duplicates based on Transaction ID.

Handled missing values using appropriate strategies:

Mode imputation for categorical columns

Median or calculated values for numeric fields

Standardized text formats (case normalization, trimming spaces).

Corrected invalid values by replacing "ERROR" / "UNKNOWN" with NULL and imputing.

Fixed data types for numeric and date fields.

Ensured price consistency by recalculating Total Spent = Quantity × Price Per Unit.

# EDA Insights (Post-Cleaning)
Top-selling items in terms of revenue.

Peak transaction times during the day.

Most preferred payment methods.

Location-based sales performance.


# Outcome
The cleaned dataset is now:
✅ Accurate – No duplicates or invalid values.
✅ Consistent – Standardized formats and corrected data types.
✅ Analysis-Ready – Suitable for further BI reporting and advanced analytics.

Tech Stack
Database: MySQL / PostgreSQL (SQL queries can be adapted)

Language: SQL

Tools: MySQL Workbench / pgAdmin, Excel (for initial inspection)
