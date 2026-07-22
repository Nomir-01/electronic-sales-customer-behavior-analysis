# Electronic Sales Customer Behavior Analysis

An R-based analysis of 20,000 electronics transactions recorded between September 2023 and September 2024. The project examines loyalty membership, add-on purchases, customer ratings, and monthly purchasing patterns.

## Questions evaluated

1. Do loyalty members spend more per order than non-members?
2. Do orders containing at least three add-ons receive higher ratings?
3. Does order quantity differ significantly across months?

The analysis uses Welch two-sample tests, Wilcoxon rank-sum testing, Kruskal-Wallis testing, linear regression, and ordinal logistic regression.

## Repository structure

```text
.
├── Code/
│   ├── prep.r              # Data loading, cleaning, derived variables and EDA
│   ├── h1.r                # Loyalty membership analysis
│   ├── h2.r                # Add-on bundle and rating analysis
│   ├── h3.r                # Monthly quantity analysis
│   └── install_packages.r  # Installs missing R packages
├── Data/                   # Local source CSV location
├── Presentations/          # Midterm and final presentations
└── run_analysis.r          # Reproducible entry point
```

## Run the analysis

R 4.3 or newer is recommended. From the repository root:

```r
source("Code/install_packages.r")
source("run_analysis.r", encoding = "UTF-8")
```

`prep.r` loads the CSV itself, creates the add-on count, month, quarter, year-month, customer summary, and high-bundle variables, then the three hypothesis scripts run in order.

## Data

The analysis expects `Data/Electronic_sales_Sep2023-Sep2024.csv`. The customer-level CSV is intentionally excluded from the public Git repository; place your authorized local copy at that path before running the scripts. It contains customer demographics, order details, product types, payment and shipping methods, purchase dates, add-on descriptions, and transaction values.
