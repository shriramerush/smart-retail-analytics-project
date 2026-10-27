# Smart Retail Analytics & Sales Forecasting System

An end-to-end retail analytics project: data cleaning → SQL analysis → interactive Power BI dashboard → time-series sales forecasting.

**Author:** Rushabh Dinkar Shrirame
**Dataset:** Smart Retail Analytics Sales Forecasting Dataset (2,002 orders, Jan 2023 – Dec 2025)
**Stack:** Python (Pandas, NumPy, statsmodels, scikit-learn) · SQLite · Power BI

---

## 1. Project Overview

A retail business generates thousands of transaction records each year but rarely converts them into decisions. This project builds a practical analytics system to:

1. Identify **which products and categories generate the highest revenue and profit**
2. Determine **which months, regions, and channels perform best**
3. Profile **the most valuable and repeat customers**
4. Flag **products with declining sales or stock issues**
5. Forecast **expected sales for the next 6 months**

---

## 2. Dataset

- **Rows:** 2,002 orders
- **Columns:** 20 (Order_ID, Order_Date, Customer_ID, Product_ID, Category, Region, City, Sales_Channel, Quantity, Unit_Price_INR, Unit_Cost_INR, Discount_Pct, Revenue_INR, Profit_INR, Stock_On_Hand, Reorder_Level, ...)
- **Date range:** 2023-01-02 → 2025-12-30
- **Products:** 12 across 5 categories (Electronics, Furniture, Fashion, Home & Kitchen, Stationery)
- **Regions:** 4 (North, South, East, West)
- **Channels:** Online, In-Store, Marketplace

### Data Dictionary

| Column | Meaning |
|---|---|
| Order_ID | Unique order identifier |
| Order_Date | Date of order (D/M/YYYY) |
| Customer_ID / Name | Buyer identifiers |
| Product_ID / Name / Category | Item details |
| Region / City | Geography |
| Sales_Channel | Online / In-Store / Marketplace |
| Quantity | Units sold |
| Unit_Price_INR / Unit_Cost_INR | Price and cost per unit |
| Discount_Pct | 0 – 15% |
| Revenue_INR | Price × Quantity × (1 − Discount) |
| Profit_INR | Revenue − (Cost × Quantity) |
| Stock_On_Hand / Reorder_Level | Inventory fields |

---

## 3. Repository Structure
smart-retail-analytics/
├── README.md
├── data/
│ └── clean_retail.csv ← cleaned dataset (2,002 rows, 29 cols)
├── notebooks/
---

## 4. Key Findings

### Q1 — Products & Categories by Revenue / Profit
- **Top product by revenue:** Wireless Earbuds (~₹13.4 L revenue, ~₹6.0 L profit)
- **Top category by revenue:** Electronics
- **Highest-margin category:** Electronics (~45%)

![Product Performance](dashboard/screenshots/page2_product_performance.png)

### Q2 — Months, Regions, Channels
- **Best month:** December (holiday spike across years)
- **Best region:** West (Mumbai / Ahmedabad / Pune cluster)
- **Best channel:** In-Store, followed closely by Marketplace and Online

![Executive KPIs](dashboard/screenshots/page1_executive_kpis.png)

### Q3 — Valuable & Repeat Customers
- **Top 10 customers account for ~X% of revenue** (fill in from your output)
- **Repeat customers (>1 order)** contribute ~Y% of revenue

![Customer Analysis](dashboard/screenshots/page3_customer_analysis.png)

### Q4 — Declining Sales & Stock Risks
- Products with **lowest Days of Cover** flagged as reorder priorities
- Status column identifies CRITICAL / LOW / OK stock levels

![Inventory Alerts](dashboard/screenshots/page4_inventory_alerts.png)

### Q5 — Sales Forecast
- **Model:** Holt-Winters exponential smoothing (additive trend + seasonality, S = 12)
- **Evaluation:** MAE = ₹X, RMSE = ₹Y, MAPE = Z% (vs Naive baseline)
- **Horizon:** 6 months ahead
- **Lower confidence bound clipped at zero** (revenue cannot be negative)

![Forecast](dashboard/screenshots/page5_forecast.png)

---

## 5. Methodology

### Phase 3 — Data Cleaning
- Parsed `Order_Date` (D/M/YYYY) using `dayfirst=True`
- Verified Revenue_INR consistency: `Quantity × Unit_Price × (1 − Discount)` — 0 mismatches
- Confirmed 0 negative revenue, 0 negative profit, 0 invalid quantities
- Engineered: `Year, Month, Month_Name, YearMonth, Quarter, Profit_Margin, Discount_Amt`

### Phase 4 — Exploratory Data Analysis
Pandas groupby + matplotlib for all 5 business questions.

### Phase 5 — SQL Analysis
SQLite database `retail.db` with tables `sales`, `customers`, `products`. Queries use `SELECT, WHERE, GROUP BY, JOIN, CTE (WITH), window functions`.

All SQL results were validated against equivalent Pandas aggregations.

### Phase 7 — Sales Forecasting
- Monthly aggregation of revenue (36 points)
- Train/test split: last 6 months held out for evaluation
- Models compared: **Naive baseline**, **Holt-Winters**, **SARIMA**, **Random Forest** (with lag features)
- Evaluation: **MAE, RMSE, MAPE**
- Final model: refit on full series → 6-month forward forecast with 95% CI (clipped at 0)

### Power BI Dashboard
5 pages, all interactive with cross-filtering:
1. **Executive KPIs** — Revenue, Profit, Orders, AOV, Margin %, YoY growth
2. **Product Performance** — Top 10 products, category P&L
3. **Customer Analysis** — Top 10 LTV, repeat customer %
4. **Inventory Alerts** — Stock vs reorder, Days of Cover, CRITICAL/LOW/OK
5. **Forecast** — 6-month projected revenue with CI band

---

## 6. Model Evaluation

| Model | MAE (₹) | RMSE (₹) | MAPE (%) |
|---|---|---|---|
| Naive baseline | X | Y | Z |
| Holt-Winters | X | Y | Z |
| SARIMA | X | Y | Z |
| Random Forest | X | Y | Z |

*(Fill in from your notebook output.)*

**Best model:** [whichever had lowest MAPE]
**Limitations:** only 36 months of training data; no holiday/promotion flags; forecast should be used as directional guidance, not certainty.

---

## 7. Business Recommendations

1. **Prioritise Electronics marketing spend** — highest revenue *and* highest margin category
2. **Replicate West region playbook** — top-performing region across all channels
3. **Loyalty programme for Top 10 customers + repeat segment** — they drive a disproportionate share of revenue
4. **Set automatic reorder triggers for products with Days of Cover < 15** — prevents stockouts
5. **Plan inventory & staffing against the 6-month forecast** — expected monthly revenue in the range ₹X – ₹Y

---

## 8. How to Run

### Run the notebook
1. Open `notebooks/Smart_Retail_Analytics.ipynb` in **Google Colab**.
2. Mount Drive (`from google.colab import drive; drive.mount('/content/drive')`).
3. Upload `data/clean_retail.csv` to `/content/drive/MyDrive/`.
4. Run all cells top to bottom.

### View the dashboard
1. Open `dashboard/Smart_Retail_Dashboard.pbix` in **Power BI Desktop** (free).
2. Or view the static screenshots in `dashboard/screenshots/`.

---

## 9. Future Improvements

- Add **holiday and promotion flags** to the model
- Extend forecasting with **SARIMAX + external regressors**
- Build **customer churn prediction** (requires churn label — not in current data)
- Deploy dashboard to **Power BI Service** for live refresh
- Add **automated anomaly detection** for unusual revenue months

---

## 10. License & Acknowledgements

Dataset: Synthetic, provided for educational purposes. Code: MIT License.
Built as a capstone project demonstrating end-to-end retail analytics.
│ └── Smart_Retail_Analytics.ipynb ← Python + SQL + ML (all phases)
├── sql/
│ └── queries.sql ← all business SQL queries
├── dashboard/
│ ├── Smart_Retail_Dashboard.pbix ← Power BI file
│ └── screenshots/ ← 5 page screenshots
└── models/
└── forecast_next6.csv ← Holt-Winters 6-month forecast

