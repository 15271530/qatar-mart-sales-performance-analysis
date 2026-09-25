# Qatar Mart Retail & E-commerce
## Data Cleaning & Preparation Report

**Project:** Sales Performance Analysis  
**Data period:** January 2025 – June 2026  
**Source file:** `Qatarmart Retail & E-commerce (Raw_Dataset).csv`  
**Cleaning tool:** Microsoft Excel  
**Next stage:** MySQL Exploratory Data Analysis (EDA)  
**BI tool:** Power BI

---

## 1. Purpose

This document records the data cleaning and preparation process applied to the Qatar Mart Retail & E-commerce raw dataset before loading the prepared data into MySQL for exploratory data analysis.

The objective was to make the dataset:

- structurally consistent
- analytically reliable
- validated against business rules
- suitable for SQL analysis and Power BI
- documented well enough for another analyst to reproduce the preparation process

The cleaning process focuses on **data quality rather than changing business outcomes**. Records were not removed simply because a value was unusual.

---

## 2. Raw Dataset Overview

The raw dataset contains **49,930 records and 21 columns**.

| Metric | Result |
|---|---:|
| Rows | 49,930 |
| Columns | 21 |
| Duplicate rows | 0 |
| Duplicate Order IDs | 0 |
| Missing/null values | 0 |
| Date range | 2025-01-01 to 2026-06-30 |
| Customers | 9,933 |
| Sales channels | 3 |
| Order statuses | 4 |
| Product categories | 5 |
| Cities/locations including Unknown | 8 |

### Initial assessment

The dataset was already relatively structured. The main preparation requirements were:

1. Correctly parse the pipe-delimited source file.
2. Validate data types.
3. Check missing and placeholder values.
4. Check duplicate records and identifiers.
5. Validate numerical ranges.
6. Validate date-derived fields.
7. Recalculate sales to verify financial consistency.
8. Review the `sales_variance` field for consistency.
9. Protect customer-identifying information before public GitHub publication.
10. Produce an analysis-ready dataset for MySQL.

---

## 3. Data Dictionary

| Column | Type | Business meaning | Preparation |
|---|---|---|---|
| `order_id` | Text | Unique order identifier | Validated for uniqueness |
| `order_date` | Date | Date the order was placed | Converted/validated as date |
| `customer_id` | Text | Customer identifier | Validated; retained for customer analysis |
| `customer_name` | Text | Customer name | Excluded from public analytical dataset |
| `gender` | Text | Customer gender | Standardized/validated |
| `age` | Integer | Customer age | Range validated |
| `city` | Text | Customer/order location | Standardized; `Unknown` retained |
| `product_category` | Text | Product category | Standardized/validated |
| `product` | Text | Product name | Standardized/validated |
| `quantity` | Integer | Units purchased | Range validated |
| `unit_price` | Decimal | Price per unit in QAR | Numeric and positive |
| `discount` | Decimal | Discount rate | Validated as 0–25% |
| `payment_method` | Text | Payment method | `Unknown` retained as an explicit category |
| `sales_channel` | Text | Store, Online, or Phone | Standardized/validated |
| `salesperson` | Text | Salesperson identifier | Validated |
| `order_status` | Text | Completed, Cancelled, Pending, or Returned | Standardized/validated |
| `sales_amount` | Decimal | Recorded sales value in QAR | Validated against calculation |
| `net_sales_calc` | Decimal | Calculated net sales | Recalculated/validated |
| `sales_variance` | Decimal | Source-provided variance field | Audited; not used as a primary analytical measure |
| `year` | Integer | Order year | Cross-checked against date |
| `month` | Integer | Order month | Cross-checked against date |

---

## 4. Cleaning & Preparation Steps

### Step 1 — Import and delimiter validation

The source file is pipe-delimited (`|`) rather than comma-delimited.

**Action:**
- Imported the file using the correct delimiter.
- Confirmed that the dataset contains 21 logical columns rather than treating the entire row as one text field.

**Result:** 49,930 rows × 21 columns.

---

### Step 2 — Column-name standardization

Column names were reviewed for:

- consistent lowercase naming
- removal of unnecessary spaces
- SQL-friendly naming
- consistent use of underscores

The final naming convention uses `snake_case`, for example:

`order_date`, `customer_id`, `product_category`, `sales_channel`, `sales_amount`.

---

### Step 3 — Data-type validation

The following data types were validated:

**Dates**
- `order_date` → Date

**Integers**
- `age`
- `quantity`
- `year`
- `month`

**Decimals**
- `unit_price`
- `discount`
- `sales_amount`
- `net_sales_calc`
- `sales_variance`

**Categorical/text**
- customer and product attributes
- city
- payment method
- channel
- order status
- salesperson

No invalid dates were detected.

---

## 5. Missing-Value Assessment

No true blank/null values were found in the raw dataset.

However, two fields contain an explicit `Unknown` category:

| Field | `Unknown` records |
|---|---:|
| `city` | 100 |
| `payment_method` | 79 |

### Treatment

`Unknown` values were **not converted to arbitrary values** and the affected records were **not deleted**.

They are retained as an explicit category because replacing them with a guessed value would introduce false information.

For analysis, these records can be grouped as `Unknown`.

---

## 6. Duplicate-Record Validation

Two duplicate checks were performed.

### Full-row duplicates

**Result: 0**

No completely duplicated records were found.

### Duplicate Order IDs

**Result: 0**

Each `order_id` is unique in the dataset.

This supports treating `order_id` as the transaction-level identifier.

---

## 7. Numerical Data Validation

The following business-rule checks were performed.

| Field | Observed range | Validation |
|---|---:|---|
| `age` | 18–65 | Valid |
| `quantity` | 1–10 | Valid |
| `unit_price` | QAR 5.00–1,499.99 | Positive/valid |
| `discount` | 0%–25% | Valid |
| `sales_amount` | QAR 4.02–14,955.90 | Positive/valid |

No negative quantities, negative prices, negative discounts, or impossible ages were detected.

---

## 8. Date Validation

The order-date range is:

**2025-01-01 to 2026-06-30**

The dataset contains two calendar years:

- 2025
- 2026

The supplied `year` and `month` fields were checked against `order_date`.

### Result

- Year mismatches: **0**
- Month mismatches: **0**
- Invalid dates: **0**

Therefore, the existing `year` and `month` fields are consistent with the transaction date.

---

## 9. Sales Calculation Validation

The expected net sales formula is:

```text
Expected Net Sales =
Quantity × Unit Price × (1 − Discount)
```

This was independently recalculated and compared with `net_sales_calc`.

The maximum observed difference was approximately **QAR 0.005**, consistent with decimal/rounding behavior.

Therefore, the sales calculation is considered financially consistent at the dataset's displayed precision.

### Example

```text
Quantity × Unit Price × (1 − Discount)
```

is used as the independent validation formula rather than blindly trusting the source calculation.

---

## 10. `sales_variance` Quality Review

The `sales_variance` field required additional investigation.

Observed values:

- `-0.01`
- `0.00`
- `0.01`

There were:

- **1,865** records with `-0.01`
- **46,382** records with `0.00`
- **1,683** records with `0.01`

However, the actual difference between `sales_amount` and `net_sales_calc` does not consistently match the supplied `sales_variance` value. In particular, records marked `+0.01` can have no actual difference between the two source fields.

### Cleaning decision

The raw `sales_variance` column is **not used as a primary business metric** in the analytical dataset.

The original raw field is retained in the raw-data layer for traceability, while the analysis should rely on validated calculations such as:

```text
quantity × unit_price × (1 − discount)
```

and the recorded `sales_amount`.

This prevents a questionable derived field from influencing revenue analysis.

---

## 11. Categorical-Value Validation

The main categorical fields were reviewed for consistency.

### Gender

- Male
- Female

### Sales channel

- Online
- Store
- Phone

### Order status

- Completed
- Cancelled
- Pending
- Returned

### Product categories

- Electronics
- Fashion
- Food & Beverage
- Grocery
- Home

### Payment methods

- Card
- Cash
- Bank Transfer
- Mobile Payment
- Unknown

### Cities

- Doha
- Al Rayyan
- Al Wakrah
- Lusail
- Umm Salal
- Al Khor
- Mesaieed
- Unknown

No unexpected spelling variants or duplicate category spellings were identified.

---

## 12. Customer Information & GitHub Privacy

The raw dataset contains `customer_name`.

Although the dataset is intended for portfolio analysis, customer names are not required for the planned sales-performance EDA.

### Public GitHub preparation

The recommended public analytical dataset should **exclude `customer_name`**.

`customer_id` can be retained when customer-level analysis is required, but the project should avoid exposing unnecessary personally identifying information.

The raw dataset should therefore remain separate from the public cleaned dataset.

---

## 13. Final Cleaning Decisions

| Issue | Decision | Reason |
|---|---|---|
| Duplicate rows | None removed | No duplicates found |
| Duplicate order IDs | None removed | IDs are unique |
| Blank/null values | None imputed | No true nulls found |
| `Unknown` city | Retained | Prevents fabricated location data |
| `Unknown` payment method | Retained | Prevents fabricated payment data |
| Invalid ages | None found | All values 18–65 |
| Invalid quantity | None found | All values 1–10 |
| Invalid prices | None found | All values positive |
| Invalid discounts | None found | All values 0–25% |
| Invalid dates | None found | All dates parse correctly |
| Year/month mismatch | None found | Derived fields agree with date |
| Sales calculation | Validated | Formula is consistent within rounding |
| `sales_variance` | Excluded from primary analysis | Source field contains inconsistencies |
| `customer_name` | Excluded from public dataset | Not required for EDA and unnecessary exposure |

---

## 14. Recommended Final Analytical Dataset

For the public GitHub project, the analysis-ready dataset should contain:

```text
order_id
order_date
customer_id
gender
age
city
product_category
product
quantity
unit_price
discount
payment_method
sales_channel
salesperson
order_status
sales_amount
net_sales_calc
year
month
```

The following should remain outside the public analytical dataset:

```text
customer_name
sales_variance
```

`customer_name` is excluded for privacy/minimization, while `sales_variance` is excluded because it is a questionable source-derived field that is not required for the core analysis.

---

## 15. Excel Cleaning Workflow

The Excel preparation workflow should follow this sequence:

```text
RAW CSV
   ↓
Import with "|" delimiter
   ↓
Inspect columns and data types
   ↓
Trim/standardize text fields
   ↓
Validate missing values
   ↓
Check duplicates
   ↓
Validate IDs
   ↓
Validate dates
   ↓
Validate numerical ranges
   ↓
Validate sales calculation
   ↓
Review Unknown categories
   ↓
Remove unnecessary customer_name from public analytical copy
   ↓
Exclude unreliable sales_variance from primary analysis
   ↓
Final quality checks
   ↓
CLEANED CSV
   ↓
MySQL
   ↓
Exploratory Data Analysis
   ↓
Power BI Dashboard
```

---

## 16. Quality-Control Checklist

Before exporting the cleaned dataset, the following checks should return the expected result:

- [x] Correct delimiter identified
- [x] 49,930 records loaded
- [x] 21 source columns identified
- [x] No duplicate rows
- [x] No duplicate order IDs
- [x] No true blank/null values
- [x] No invalid dates
- [x] Year matches order date
- [x] Month matches order date
- [x] Age range validated
- [x] Quantity range validated
- [x] Unit price range validated
- [x] Discount range validated
- [x] Sales calculation independently validated
- [x] Unknown categories documented
- [x] `sales_variance` investigated
- [x] Customer-name field excluded from public analytical copy
- [x] Final dataset prepared for MySQL

---

## 17. Handoff to MySQL EDA

After Excel preparation, the cleaned dataset will be loaded into MySQL.

The SQL analysis should then focus on business questions rather than additional basic cleaning.

### Core EDA areas

**Overall performance**
- Revenue
- Orders
- Units sold
- Average Order Value (AOV)
- Monthly performance

**Channel performance**
- Online vs Store vs Phone
- Revenue contribution
- Order contribution
- AOV by channel

**Geographic performance**
- Revenue by city
- Orders by city
- AOV by city
- Regional growth/decline

**Product performance**
- Category revenue
- Product revenue
- Units sold
- Product contribution

**Order-status analysis**
- Completed
- Pending
- Cancelled
- Returned

**Customer analysis**
- Customer count
- Revenue by customer
- Repeat purchasing
- Customer contribution

**Time-based analysis**
- Monthly revenue
- Month-over-month growth
- Year-over-year comparison where applicable
- Peak and low-performing periods

---

## 18. Portfolio Data Pipeline

The final project pipeline is:

```text
Raw Dataset
    │
    ▼
Excel — Data Cleaning & Preparation
    │
    ├── Quality checks
    ├── Standardization
    ├── Validation
    └── Analytical dataset
    │
    ▼
MySQL — Exploratory Data Analysis
    │
    ├── CTEs
    ├── Window Functions
    ├── KPI calculations
    ├── Trend analysis
    └── Root-cause analysis
    │
    ▼
Power BI — Business Intelligence
    │
    ├── Executive KPIs
    ├── Sales performance
    ├── Channel analysis
    ├── Geographic analysis
    └── Business insights
    │
    ▼
Business Recommendations
```

---

## 19. Key Data-Quality Findings

The raw dataset is structurally strong: there are no duplicate transactions, no duplicate order IDs, no true null values, no invalid dates, and no obvious numerical-range violations.

The main data-quality considerations are:

1. **Unknown location/payment values** must remain explicitly identified rather than being guessed.
2. **`sales_variance` should not be treated as a trusted analytical KPI** because its values do not consistently represent the actual difference between the source sales fields.
3. **Sales values are independently validated** against quantity, unit price, and discount within expected rounding tolerance.
4. **Customer names should not be included in the public portfolio dataset** because they are unnecessary for the sales-performance analysis.
5. The prepared dataset is therefore suitable for the next stage: **MySQL EDA**.

---

## 20. Analyst Handoff Statement

> The Qatar Mart raw transaction dataset was systematically assessed and prepared in Excel before exploratory analysis. The process included structural validation, duplicate checks, missing-value assessment, data-type validation, numerical-range checks, date validation, categorical standardization, and independent sales-calculation verification. No transaction records required deletion based on duplicate or invalid-value checks. Explicit `Unknown` categories were retained to avoid introducing unsupported assumptions, while the inconsistent source-derived `sales_variance` field was excluded from primary analysis. Customer names were also excluded from the public analytical dataset to minimize unnecessary exposure of customer-identifying information. The resulting dataset is ready for loading into MySQL for exploratory data analysis and subsequent Power BI reporting.
