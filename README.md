
## 👋 Hi, I'm Akeem 
## I'm an aspiring Data Analyst passionate about transforming raw data into insights and real business impact

# Layoffs Data Cleaning & Feature Engineering
## 🧰 Tools Used
- SQL Server (SSMS)
- Power Query / Excel
- GitHub (for version control)

📊 **Project Overview**
This project focuses on cleaning and preparing a layoffs dataset for analysis and predictive modeling.  
It demonstrates key data cleaning techniques using SQL and Power Query — handling null values, removing duplicates, standardizing text, and creating engineered features (year, month, day).

🧼 **Key Steps**
- Created database and staging schema in SQL Server  
- Standardized categorical fields (company, location, industry, etc.)  
- Removed duplicates using `ROW_NUMBER()`  
- Handled missing data using `COALESCE` and `PERCENTILE_CONT` (median imputation)  
- Engineered date-based features for analysis readiness  
- Created final clean view `VW_Layoff`

📈 **Results**
✅ Clean, standardized dataset  
✅ Missing values imputed  
✅ Ready for Power BI or predictive modeling  
✅ Documented end-to-end workflow in both SQL and Excel Power Query  

🔗 **Related Project**
[Layoffs Data Cleaning – Power Query Version]

**Contents**
- `sql_scripts/` — SQL scripts for schema, exploration, cleaning, and view creation.
- `data/` — small sanitized sample CSVs (do not include PII).
- `docs/report.pdf` — project report with before/after screenshots.

**How to use**
1. Inspect `cleaned_layoff_Sql/vw_Layoff` to see the non-destructive cleaning view.
2. Run scripts in your SQL Server (SSMS) environment.
3. Open `docs/report.pdf` for the process summary and screenshots.

**Notes**
- Missing values are handled with medians for numeric, modes for categorical, and flags for missingness.
- Real datasets with PII were not uploaded to this repo.
