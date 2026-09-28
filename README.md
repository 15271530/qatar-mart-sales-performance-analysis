
![img src] = ("https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/ae5efdffb78bbfe61147580f73aacb29fe188082/Visuals/QatarMart%20Retail%20and%20Ecommerce%20Company%20LOGO.png"

<p align="center">
  <img src="[images/logo.png](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/acfcb951abcb30524e8a2576abdd5313d3453fe2/Visuals/QatarMart%20Retail%20and%20Ecommerce%20Company%20LOGO.png)" width="120" alt="Qatar Mart Logo">
</p>

<h1 align="center">Qatar Mart Sales Performance Analysis</h1>

<p align="center">
  Data Analytics Portfolio Project | Qatar
</p>









## Qatar Mart Retail & E-commerce Company

### Client Background

**Qatar Mart** is a retail and e-commerce business operating in Qatar, serving customers through physical retail locations and online sales channels. Established in 2025, the company has grown and expanded over the past year. It has faced increasing competition from peer companies, as well as change in customer demand, purchasing behavior, and channels dynamics.

Qatar Mart's customer base is approaching **9,500 customers**, with more than **48,000 transactions**, generating sales revenue exceeding **QAR 37 million**. The available retail and e-commerce data covers various dimensions and metrics, including sales, products, sales by region, sales by channel, and payment methods.

Reporting to the Head of Operations, an in-depth analysis was conducted to evaluate **Qatar Mart's** performance over the past year (2025–2026). This comprehensive review provides valuable insights that the internal cross-functional team can use to streamline processes and enhance **Qatar Mart's** commercial performance.

The key insights and recommendations focus on the following areas:

#### Stakeholder Questions

**Executive Management**

**How is overall revenue performing and what are the major changes in business performance?**

**Sales Manager**

**What is driving changes in revenue, and where are the major opportunities and risks?**

**Product/Category Manager**

**What drove the February 2026 revenue decline, and which channels, locations, and product categories contributed most?**

---

## Analytical Findings

### Executive Management

##### Business Question

**How is overall revenue performing and what are the major changes in business performance?**

##### Executive Summary

> **Revenue performance was volatile across the Analysis period: (January 2025 – June 2026). Monthly revenue averaged approximately QAR 2.08M, with performance strengthening through 2025 before declining during early 2026. Revenue reached its highest point in August 2025 at approximately QAR 2.24M, while March 2026 recorded the lowest monthly revenue at approximately QAR 1.74M.**

![image](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/855cb21d3914938ae4322c43f80a74a0e5fbb8eb/QatarMart%20KPI.png)

![image](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/9bf4cec5d4455beca2cda012adf23ed43b19e5a5/x.png)

#### Key Findings

**1. Revenue growth during 2025**

> Revenue increased from approximately QAR 1.95M in February 2025 to QAR 2.24M in August 2025, representing an increase of approximately **14.9%**. Revenue remained above the monthly average for most of Q3 and Q4 2025.

**2. Peak performance**

> **August 2025 generated the highest monthly revenue at approximately QAR 2.24M**, exceeding the overall monthly average of QAR 2.08M by approximately **19%**.

**3. Revenue decline in early 2026**

> Revenue declined substantially after December 2025. By February revenue declined to approximately QAR 1.75M, followed by a further decline in March 2026. Revenue of approximately QAR 1.74M was around **23% below the overall monthly average of QAR 2.08M**.

**4. Recovery in June 2026**

> Revenue recovered from approximately **QAR 1.74M in March 2026 to QAR 2.01M in June 2026**, indicating an improvement of approximately **15.5%**, although revenue remained below the 2025 peak.

**5. Change in business momentum**

> The data indicates a shift from relatively strong revenue performance during the second half of 2025 to weaker performance during Q1 2026. This change warrants further investigation into the **underlying drivers of the decline.**

---

### Dataset Structure and ERD (Entity Relationship Diagram)

The database structure consists of six tables: one central fact table (`facts_sales`) and five dimension tables (`dim_customers`, `dim_product`, `dim_payment`, `dim_channel`, and `DateTable`). The `facts_sales` table serves as the central table, linking transactional sales data to customer, product, payment, sales channel, and date dimensions.

![image](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/50689b4422cb2d7852e7caf8613103478bce8841/ChatGPT_Image_Aug_27_2026_04_20_44_PM.png)

---

### Sales Manager

### Business Question

> **What is driving changes in revenue, and where are the major opportunities and risks?**

#### Key Findings

#### 1. How is Business Sales Performance?

**Total recorded sales revenue** during the January 2025–June 2026 analysis period was **QAR 37.12M**. However, monthly performance was **volatile**, with revenue weakening during early 2026.

**Order volume increased by 5.96%**, while **units sold increased by 5.7%**, showing that sales growth is primarily driven by higher transaction volume.

**Average Order Value (AOV) remained relatively stable**, declining slightly by **0.2%**, indicating that growth is not currently being driven by higher customer spend per order.

Overall, the business is experiencing **volume-led growth**, but there is an opportunity to improve revenue efficiency per order.

#### 2. Key Drivers of Sales Performance

![imagel](
https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/a9e59ac9b2914b38df097b244b3928cb925e3af5/Revenue%20By%20Sales%20Channel.png)
![image](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/7de8dd484f8319bc196a2d958019e0b736f93af2/Revenue%20By%20City.png)

**Online sales are the largest revenue-generating channel**, making digital sales an important contributor to overall performance.

**Doha is the highest-revenue city**, followed by other major markets such as Al Rayyan, Lusail, and Al Wakrah.

Performance is therefore concentrated around **key sales channels and high-performing geographic markets**.

#### Revenue Performance

```text
Revenue Performance
│
├── Orders      +5.96%
├── Units Sold  +5.70%
└── AOV         -0.20%
```

**Revenue growth was primarily volume-led, with increased orders and units offsetting the slight decline in AOV.**

#### 3. What Problems or Risks Should the Business Investigate?

**Monthly revenue fluctuations** require further analysis to determine whether changes are related to seasonality, product demand, inventory availability, or customer purchasing behavior.

![image](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/a072a2c5a9c0a996681826fa055b4120462cf525/Revenue%20Leakage.png)

```text
Total Order Value
│
├── Completed  57.58%
├── Pending
├── Cancelled
└── Returned
```

Only **57.58% of sales value is associated with completed orders**, while a significant portion is linked to **pending, cancelled, and returned orders**.

The proportion of **pending, cancelled, and returned order value** warrants investigation to determine its impact on realized sales revenue.

The slight decline in AOV suggests the business should investigate **product mix, customer purchasing patterns, promotions, and order composition**.

#### 4. Where Are the Business Opportunities?

**Increase AOV** through cross-selling, upselling, product bundles, and complementary-product recommendations.

**Improve order completion** by identifying and reducing the causes of pending and cancelled orders.

**Reduce returns** by identifying products, channels, and locations with unusually high return rates.

Use **product-level analysis** to identify high-revenue products and determine whether they are also generating strong margins and repeat purchases.

#### 5. Recommended Business Actions

Monitor **Revenue, Orders, Units Sold, AOV, Completion Rate, Cancellation Rate, and Return Rate** as core performance KPIs.

Conduct a **cancellation and return root-cause analysis** by product, city, channel, and order status.

Develop targeted **upselling and cross-selling strategies** to increase revenue without relying solely on higher order volume.

---

### Product/Category Manager

#### Business Question

> **What drove the February 2026 revenue decline, and which channels, locations, and product categories contributed most?**

#### Summary

**The February 2026 revenue decline was primarily volume-driven, with lower orders and units sold outweighing the modest increase in AOV. The analysis identified the Store channel, Al Rayyan, and Burger/Food & Beverage as key areas requiring further investigation. Management should focus on identifying the root causes of declining transaction volume, strengthening early-warning monitoring, and implementing targeted interventions before similar performance deterioration occurs.**

#### Root Cause Analysis

Revenue decreased **20.9%** month-over-month in February 2026 compared with January 2026, primarily driven by a **15.22% decrease in orders** and a **15.5% decline in units sold**.

![image](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/31df814c3ccf4019c21ce5c24cb03b463a562031/root%20cause%20variances.png)

The **Store channel** accounted for the largest share of the February revenue decline, followed by **Mesaieed and the Burger category within Food & Beverage.**

![image](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/b7977a23da86709fa6ce16b71d232d253e10383d/channel%20analysis.png)

![image](https://github.com/15271530/qatar-mart-sales-performance-analysis/blob/a83513dbcf4fced3a0edd08414d862dabaa42fd2/Regional%20analysis.png)

The findings suggest that the February decline was **primarily volume-driven rather than AOV-driven**.

#### What Management Should Investigate

Identify why **order volume declined by 15.22%** in February.

Investigate the performance of the **Store channel**, Al Rayyan, and Burger/Food & Beverage in greater detail.

Determine whether the decline was related to **customer demand, promotions, product availability, operational issues, or channel-specific factors**.

Compare February performance with the **previous month and the same period in the prior year** to distinguish a temporary fluctuation from a recurring pattern.

#### Recommendation / Prevention

Establish **channel-level early-warning KPIs** for orders, units sold, AOV, cancellations, and returns.

Set alerts when order volume or units sold experience a significant decline.

Monitor **high-impact products and cities** weekly rather than waiting for monthly results.

Investigate sudden changes in customer demand, product availability, promotions, and operational performance.

Develop a **February recovery action plan** for the affected channel, city, and product category.

Track subsequent months to determine whether the recovery is **sustained or temporary**.
