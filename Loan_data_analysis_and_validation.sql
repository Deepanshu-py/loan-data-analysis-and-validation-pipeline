CREATE DATABASE  Loan_Data;
USE Loan_Data;

DROP TABLE IF EXISTS loan_default;

CREATE TABLE loan_default (
    LoanID VARCHAR(MAX),
    Age VARCHAR(MAX),
    Income VARCHAR(MAX),
    LoanAmount VARCHAR(MAX),
    CreditScore VARCHAR(MAX),
    MonthsEmployed VARCHAR(MAX),
    NumCreditLines VARCHAR(MAX),
    InterestRate VARCHAR(MAX),
    LoanTerm VARCHAR(MAX),
    DTIRatio VARCHAR(MAX),
    Education VARCHAR(MAX),
    EmploymentType VARCHAR(MAX),
    MaritalStatus VARCHAR(MAX),
    HasMortgage VARCHAR(MAX),
    HasDependents VARCHAR(MAX),
    LoanPurpose VARCHAR(MAX),
    HasCoSigner VARCHAR(MAX),
    Defaulter VARCHAR(MAX)
);
BULK INSERT loan_default
FROM 'C:\Users\deepk\OneDrive\Desktop\capstone projects\loan default prediction dataset\clean data\loanclean_data.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    TABLOCK
);

SELECT TOP 10 *
FROM loan_default
ORDER BY NEWID();
USE loan_data;

-- LOAN DEFAULT ANALYSIS (SQL EDA PROJECT)
-- Description: Clean EDA without percentage metrics

UPDATE loan_default
SET Defaulter =
    CASE 
        WHEN Defaulter IN ('Yes','True','1') THEN 1
        WHEN Defaulter IN ('No','False','0') THEN 0
        ELSE NULL
    END;

ALTER TABLE loan_default
ALTER COLUMN Defaulter INT;

-- 1. BORROWERS BY EMPLOYMENT TYPE

SELECT 
    EmploymentType,
    COUNT(*) AS total_borrowers,
    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters
FROM loan_default
GROUP BY EmploymentType
ORDER BY defaulters DESC;




-- 2. BORROWERS BY LOAN PURPOSE

SELECT 
    LoanPurpose,
    COUNT(*) AS total_borrowers,
    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters
FROM loan_default
GROUP BY LoanPurpose
ORDER BY defaulters DESC;




-- 3. DEFAULTERS VS NON-DEFAULTERS ANALYSIS

SELECT 
    CASE 
        WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 'Defaulter'
        ELSE 'Non-Defaulter'
    END AS borrower_status,

    COUNT(*) AS total_borrowers,

    ROUND(AVG(TRY_CAST(Income AS FLOAT)), 2) AS avg_income,
    ROUND(AVG(TRY_CAST(CreditScore AS FLOAT)), 2) AS avg_credit_score,
    ROUND(AVG(TRY_CAST(DTIRatio AS FLOAT)), 2) AS avg_dti

FROM loan_default

WHERE TRY_CAST(Defaulter AS INT) IS NOT NULL

GROUP BY 
    CASE 
        WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 'Defaulter'
        ELSE 'Non-Defaulter'
    END;




-- 4. CREDIT SCORE SEGMENTATION

SELECT 	
    CASE
        WHEN TRY_CAST(CreditScore AS FLOAT) < 580 THEN 'Poor'
        WHEN TRY_CAST(CreditScore AS FLOAT) BETWEEN 580 AND 669 THEN 'Fair'
        WHEN TRY_CAST(CreditScore AS FLOAT) BETWEEN 670 AND 739 THEN 'Good'
        ELSE 'Excellent'
    END AS credit_category,

    COUNT(*) AS total_borrowers,

    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters

FROM loan_default

GROUP BY 	
    CASE
        WHEN TRY_CAST(CreditScore AS FLOAT) < 580 THEN 'Poor'
        WHEN TRY_CAST(CreditScore AS FLOAT) BETWEEN 580 AND 669 THEN 'Fair'
        WHEN TRY_CAST(CreditScore AS FLOAT) BETWEEN 670 AND 739 THEN 'Good'
        ELSE 'Excellent'
    END

ORDER BY defaulters DESC;




-- 5. AGE GROUP ANALYSIS

SELECT 
    CASE 
        WHEN TRY_CAST(Age AS INT) < 25 THEN '18-24'
        WHEN TRY_CAST(Age AS INT) BETWEEN 25 AND 34 THEN '25-34'
        WHEN TRY_CAST(Age AS INT) BETWEEN 35 AND 44 THEN '35-44'
        WHEN TRY_CAST(Age AS INT) BETWEEN 45 AND 54 THEN '45-54'
        WHEN TRY_CAST(Age AS INT) BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,

    COUNT(*) AS total_borrowers,

    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters

FROM loan_default

GROUP BY 
    CASE 
        WHEN TRY_CAST(Age AS INT) < 25 THEN '18-24'
        WHEN TRY_CAST(Age AS INT) BETWEEN 25 AND 34 THEN '25-34'
        WHEN TRY_CAST(Age AS INT) BETWEEN 35 AND 44 THEN '35-44'
        WHEN TRY_CAST(Age AS INT) BETWEEN 45 AND 54 THEN '45-54'
        WHEN TRY_CAST(Age AS INT) BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END

ORDER BY defaulters DESC;




-- 6. CO-SIGNER IMPACT

SELECT 
    HasCoSigner,
    COUNT(*) AS total_borrowers,

    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters

FROM loan_default

GROUP BY HasCoSigner;




-- 7. LOAN TERM ANALYSIS

SELECT 
    TRY_CAST(LoanTerm AS INT) AS loan_term,

    COUNT(*) AS total_borrowers,

    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters

FROM loan_default

GROUP BY TRY_CAST(LoanTerm AS INT)

ORDER BY defaulters DESC;




-- 8. INCOME SEGMENTATION

SELECT 
    CASE 
        WHEN TRY_CAST(Income AS FLOAT) < 40000 THEN 'Low Income'
        WHEN TRY_CAST(Income AS FLOAT) BETWEEN 40000 AND 80000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_category,

    COUNT(*) AS total_borrowers,

    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters

FROM loan_default

GROUP BY 
    CASE 
        WHEN TRY_CAST(Income AS FLOAT) < 40000 THEN 'Low Income'
        WHEN TRY_CAST(Income AS FLOAT) BETWEEN 40000 AND 80000 THEN 'Middle Income'
        ELSE 'High Income'
    END

ORDER BY defaulters DESC;




-- 9. DTI RATIO ANALYSIS

SELECT 
    CASE 
        WHEN TRY_CAST(DTIRatio AS FLOAT) < 0.2 THEN 'Low Risk'
        WHEN TRY_CAST(DTIRatio AS FLOAT) BETWEEN 0.2 AND 0.4 THEN 'Medium Risk'
        ELSE 'High Risk'
    END AS dti_category,

    COUNT(*) AS total_borrowers,

    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters

FROM loan_default

GROUP BY 
    CASE 
        WHEN TRY_CAST(DTIRatio AS FLOAT) < 0.2 THEN 'Low Risk'
        WHEN TRY_CAST(DTIRatio AS FLOAT) BETWEEN 0.2 AND 0.4 THEN 'Medium Risk'
        ELSE 'High Risk'
    END

ORDER BY defaulters DESC;




-- 10. MULTI-FACTOR RISK ANALYSIS

SELECT 
    EmploymentType,
    LoanPurpose,

    COUNT(*) AS total_borrowers,

    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters

FROM loan_default

GROUP BY EmploymentType, LoanPurpose

ORDER BY defaulters DESC;




-- 11. TOP 10 HIGH RISK CUSTOMERS

SELECT TOP 10 *
FROM loan_default
WHERE TRY_CAST(Defaulter AS INT) = 1
ORDER BY 
    TRY_CAST(CreditScore AS FLOAT) ASC,
    TRY_CAST(DTIRatio AS FLOAT) DESC;




-- 12. RISK RANKING (BASED ON DEFAULTERS)

SELECT 
    LoanPurpose,

    COUNT(*) AS total_borrowers,

    SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) AS defaulters,

    RANK() OVER (
        ORDER BY 
        SUM(CASE WHEN TRY_CAST(Defaulter AS INT) = 1 THEN 1 ELSE 0 END) DESC
    ) AS risk_rank

FROM loan_default

GROUP BY LoanPurpose;