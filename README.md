# Loan Default Analysis System

## Project Overview

This project presents a complete end-to-end data analytics pipeline for analyzing loan default risk using:

- Python → Data Cleaning & Feature Engineering  
- SQL Server → Data Analysis & Querying  
- Power BI → Visualization & Dashboard  

The system transforms raw financial data into actionable business insights through structured analysis and validation. :contentReference[oaicite:0]{index=0}


---

## Objectives

- Perform data cleaning and preprocessing using Python  
- Conduct Exploratory Data Analysis (EDA)  
- Build borrower risk segmentation models  
- Analyze default patterns and key drivers  
- Ensure data integrity and validation  


---

## Dataset Details

| Attribute | Value |
|----------|------|
| Total Records | ~255,347 |
| Total Features | 18 |
| Format | CSV |
| Type | Structured Financial Data |


### Key Features

- Demographic: Age, MaritalStatus  
- Financial: Income, LoanAmount, CreditScore, DTIRatio  
- Employment: EmploymentType, MonthsEmployed  
- Loan Info: LoanPurpose, LoanTerm  
- Target: Defaulter (1 = Default, 0 = Non-default)


---

## Data Challenges

- Data type issues (numbers stored as VARCHAR)  
- Missing values (LoanTerm)  
- Inconsistent formatting (NULL, spaces, etc.)  
- CSV structure issues (merged columns)  
- Critical issue: Defaulter column misinterpreted (showing 0 defaults)  


---

## System Architecture
Raw CSV → Python ETL → Clean CSV → SQL Server → Aggregation → Power BI Dashboard



### Layers

| Layer | Tool | Purpose |
|------|------|--------|
| Data Processing | Python | Cleaning & Transformation |
| Data Analysis | SQL Server | Querying & Aggregation |
| Visualization | Power BI | Dashboard & Reporting |


---

## Data Cleaning (Python)

### Key Steps

- Type conversion (string to numeric)  
- Missing value handling  
- Duplicate removal  
- Standardizing categorical values  


### Feature Engineering

- Income Groups → Low, Medium, High  
- Credit Score Categories → Poor, Fair, Good, Excellent  
- DTI Categories → Low Risk, Medium Risk, High Risk  


---

## SQL Analysis

### Critical Fix (Defaulter Issue)

sql
SUM(CASE 
    WHEN TRY_CAST(Defaulter AS FLOAT) = 1 THEN 1 
    ELSE 0 
END)

## SQL Analysis

- Fixed incorrect default count  
- Enabled accurate default rate calculation (~10–15%)  


### Key SQL Analysis

- Default rate by income group  
- Default rate by credit score  
- DTI vs default relationship  
- Defaulter vs Non-defaulter comparison  


---

## Power BI Dashboard

### 1. Portfolio Overview

- Total Borrowers  
- Total Defaulters  
- Default Rate  
- Trend Analysis  


### 2. Risk Analysis

- Default by Income Group  
- Default by Credit Score  
- Default by DTI  
- Scatter plots  


### 3. Data Validation

- Missing values  
- Data ranges  
- Defaulter distribution  


---

## KPIs (DAX)

DAX
Total Borrowers = COUNTROWS('LoanData')

Total Defaulters = SUM('LoanData'[Defaulter])

Default Rate = DIVIDE([Total Defaulters], [Total Borrowers], 0)

## Power BI Dashboard

### Live Dashboard

View the interactive dashboard here:  
https://app.powerbi.com/links/ifLzSJLWYw?ctid=1490b17d-5dc9-4cbf-aeba-a2e854f521b8&pbi_source=linkShare&bookmarkGuid=33add371-e044-42ec-859b-db8020795af0


---

### Dashboard Preview

#### Loan Overview & Borrower Insights
<img width="1670" height="941" alt="Screenshot 2026-04-15 144449" src="https://github.com/user-attachments/assets/bf253ed6-37bd-4642-98ac-db09d6b5ac3e" />


#### Borrower Risk & Financial Behaviour Analysis
<img width="1672" height="937" alt="Screenshot 2026-04-15 144417" src="https://github.com/user-attachments/assets/3c88544d-3226-47cd-b45a-92bcdb45aa05" />


#### Default Risk & Borrower Segmentation
<img width="1670" height="938" alt="Screenshot 2026-04-15 144515" src="https://github.com/user-attachments/assets/70d29e14-0e53-40d2-bc15-097008306915" />



---

## Key Insights

- Majority borrowers are high-income (>60%)  
- DTI ratio is the strongest risk indicator  
- Credit score alone is not sufficient for prediction  
- Default rate ≈ 10–15%  
- Default behavior is multi-factor dependent  


---

## Limitations

- No time-series data (payment history missing)  
- Low feature variability  
- Dataset may not represent real-world population  
- Weak correlations between variables  


---

## Future Scope

- Add Machine Learning models (Logistic Regression, XGBoost)  
- Include time-series data for better prediction  
- Perform advanced feature engineering  
- Use real-world financial datasets  


---

## Conclusion

This project successfully builds a robust data analytics pipeline and highlights the importance of:

- Data cleaning  
- Validation  
- Structured analysis  

The system is effective for risk analysis and segmentation, but future improvements can make it predictive and production-ready.


---

## Author

Deepanshu  
Data Analyst | Python | SQL | Power BI  | Tableau | Excel
