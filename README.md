# Layoffs Data Cleaning & Feature Engineering
## 🧰 Tools Used
- SQL Server (SSMS)
- Power Query / Excel
- GitHub (for version control)

**Objective:** Clean and prepare the Layoffs dataset for predictive modeling and analysis.

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
