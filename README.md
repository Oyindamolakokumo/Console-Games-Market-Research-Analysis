# Console-Games-Market-Research-Analysis
This project involves conducting deep-market research for a console games company by analyzing historical hardware and software data. The goal is to bridge the gap between console release lifecycles and game sales performance to identify strategic release windows and regional market trends.

### **Project Overview**
As an analytics consultant, I was tasked with integrating disparate datasets—`p9-consolegames` (software sales) and `p9-consoledates` (hardware lifecycle)—to identify key market drivers. This analysis specifically evaluates how console launch timing impacts regional sales performance, particularly during high-volume retail windows.

### **Project Scope**
* **Relational Integrity:** Implementing Primary/Foreign key constraints to bridge software and hardware data.
* **Data Cleansing:** Standardizing platform nomenclature and rectifying orphan records.
* **Business Intelligence:** Analyzing "Holiday Season" launches to determine if Q4 releases yield higher North American (NA) market share.
* **Schema Evolution:** Transforming legacy data types into optimized formats (`YEAR`, `DATE`) for temporal accuracy.

### **Methodology & Technical Stack**
* **Tools:** MySQL Workbench, DDL/DML/DQL.
* **Process:**
    1. **Audit:** Identfied schema inconsistencies and missing values.
    2. **Transformation:** Modified table structures to enforce data types.
    3. **Cleaning:** Used safe updates to resolve null strings and manual ingestion for missing industry data.
    4. **Analysis:** Executed multi-table joins and aggregation for seasonal reporting.

---

### **SQL Implementation**

### 1. Data Definition & Schema Hardening (DDL)
* **Objective**: Transition from raw CSV imports to a structured relational model.*

```sql
-- Setting the Primary Key to ensure record uniqueness
ALTER TABLE `p9-consolegames` MODIFY `RANK` INT PRIMARY KEY;

-- Standardizing column types for temporal logic
ALTER TABLE `P9-CONSOLEGAMES` MODIFY `YEAR` YEAR;
ALTER TABLE `P9-CONSOLEDATES` MODIFY FirstRetailAvailability DATE;

-- Enforcing referential integrity between Software and Hardware tables
ALTER TABLE `p9-consolegames`
ADD CONSTRAINT fk_platform FOREIGN KEY(platform) 
REFERENCES `p9-consoledates`(platform);
```

### 2. **Strategic Data Cleansing (DML)**
* **Objective**: Rectify inconsistent entries and missing platform data to prevent skewed results.*

```sql
-- Resolving 'Orphan' records in the software table
SET sql_safe_updates = 0;
UPDATE `p9-consolegames` SET platform = 'Wii' WHERE platform = '';

-- Ingesting missing industry-standard platform data (PC)
INSERT INTO `p9-consoledates`(PLATFORM, FIRSTRETAILAVAILABILITY, DISCONTINUED, UNITSSOLDMILLIONS) 
VALUES('PC', '2017-03-03', '2020-05-10', 141.32);
```

#### 3.** Advanced Market Analysis (DQL)**
* **Objective**: Identify platforms released during "Holiday Windows" and their weighted sales impact.*

```sql
SELECT 
    d.Platform,
    SUM(d.UNITSSOLDMILLIONS * g.NA_SALES) AS NA_TOTALSALES,
    (g.NA_SALES / SUM(d.UNITSSOLDMILLIONS * g.NA_SALES)) * 100 AS PERC_NA_SALES,
    LEFT(g.`NAME`, 4) AS ABV_NAME -- Abbreviated title for reporting
FROM `p9-consoledates` d
JOIN `p9-consolegames` g ON d.Platform = g.PLATFORM
WHERE (MONTH(FIRSTRETAILAVAILABILITY) = 11 AND DAY(FirstRetailAvailability) BETWEEN 15 AND 30)
   OR (MONTH(FIRSTRETAILAVAILABILITY) = 12 AND DAY(FIRSTRETAILAVAILABILITY) < 25)
GROUP BY d.Platform, g.`RANK`, g.`NAME`, g.`YEAR`, g.`PUBLISHER` -- [Simplified for display]
ORDER BY `NAME` ASC, `YEAR` DESC;
```
---
## **Recommendations for Stakeholders**
* **Missing Value Management:** I recommend the future use of the `COALESCE` function during the query phase. This allows for dynamic "Unknown" tagging without permanently modifying the raw source data.
* **Data Ingestion Pipeline:** Standardize the `Game_Year` format at the point of entry to `YEAR` format to avoid manual `ALTER TABLE` operations in production environments.
* **Indexing:** For future scalability (datasets >1M rows), I recommend indexing the `Platform` column in both tables to optimize join performance.

## 📂 Repository Structure
* `/sql_scripts`: Contains `schema_setup.sql` and `cleaning_logic.sql`.
* `/data`: Reference CSV files (ConsoleGames, ConsoleDates).
* `README.md`: Project documentation and executive summary.

---
**Consultant:** [Your Name]  
**LinkedIn:** [Your Profile Link]  
**Portfolio:** [Your Portfolio Link]
