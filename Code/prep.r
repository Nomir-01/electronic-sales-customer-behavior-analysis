library(tidyverse)
library(lubridate)
library(fastDummies)
library(dplyr)
library(ggplot2)
library(MASS)

# Load the supplied dataset when the analysis starts from a clean R session.
data_path <- file.path("Data", "Electronic_sales_Sep2023-Sep2024.csv")
if (!file.exists(data_path)) {
    stop("Dataset not found. Run the analysis from the repository root.")
}

my_data <- read.csv(data_path, stringsAsFactors = FALSE, check.names = TRUE)

check_df <- my_data %>%
    mutate(
        Purchase.Date = as.Date(Purchase.Date),
        Order.Status = ifelse(Order.Status == "Completed", 1, 0),
        Loyalty.Member = ifelse(Loyalty.Member == "Yes", 1, 0),
        Gender = ifelse(Gender == "Male", 1, 0),
        Payment.Method = stringr::str_to_title(Payment.Method),
        total_amount = Total.Price + Add.on.Total,
        add_on_total_count = ifelse(
            is.na(Add.ons.Purchased) | trimws(Add.ons.Purchased) == "",
            0L,
            stringr::str_count(Add.ons.Purchased, ",") + 1L
        ),
        Month = factor(format(Purchase.Date, "%m"), levels = sprintf("%02d", 1:12)),
        Quarter = factor(quarters(Purchase.Date)),
        YearMonth = floor_date(Purchase.Date, unit = "month"),
        HighBundle = ifelse(add_on_total_count >= 3, 1, 0)
    ) %>%
    dummy_cols(
        select_columns = c("Product.Type", "Payment.Method", "Shipping.Type"),
        remove_first_dummy = FALSE,
        remove_selected_columns = TRUE
    )

orders_per_customer <- check_df %>%
    group_by(Customer.ID, Loyalty.Member) %>%
    summarise(order_count = n(), .groups = "drop")

lifetime_spend <- check_df %>%
    group_by(Customer.ID, Loyalty.Member) %>%
    summarise(
        total_spent = sum(total_amount, na.rm = TRUE),
        .groups = "drop"
    )

customer_summary <- check_df %>%
    group_by(Customer.ID) %>%
    summarise(
        avg_quantity = mean(Quantity, na.rm = TRUE),
        avg_spent = mean(total_amount, na.rm = TRUE),
        total_orders = n(),
        .groups = "drop"
    )

check_df %>%
  dplyr::select(
    Product.Type_Laptop,
    Product.Type_Tablet,
    Product.Type_Smartphone,
    Product.Type_Smartwatch
  ) %>%
  summarise(across(everything(), sum)) %>%
  pivot_longer(everything(), names_to = "Product", values_to = "Count") %>%
  ggplot(aes(x = Product, y = Count)) +
  geom_col(fill = "skyblue") +
  labs(
    title = "Distribution of Product Types",
    x = "Product Type",
    y = "Number of Orders"
  ) +
  theme(axis.text.x = element_text(angle = 20))

check_df %>%
  summarise(
    Core = sum(Total.Price),
    AddOns = sum(Add.on.Total)
  ) %>%
  pivot_longer(everything(), names_to = "Component", values_to = "Amount") %>%
  ggplot(aes(x = Component, y = Amount)) +
  geom_col(fill = "steelblue") +
  labs(
    title = "Contribution of Core Products vs Add-Ons",
    y = "Total Revenue"
  )

ggplot(check_df, aes(x = Age)) +
    geom_histogram(bins = 25, fill = "steelblue") +
    labs(
        title = "Customer Age Distribution",
        x = "Age",
        y = "Number of Customers"
    )

ggplot(check_df, aes(x = Quantity, y = total_amount)) +
  geom_jitter(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Relationship Between Quantity and Total Spend",
    x = "Quantity Purchased",
    y = "Total Amount (incl. add-ons)"
  )

ggplot(customer_summary, aes(
  x = avg_quantity,
  y = avg_spent,
  size = total_orders
)) +
  geom_point(alpha = 0.4) +
  labs(
    title = "Customer Purchasing Behavior (Bubble Size = Order Count)",
    x = "Average Quantity per Order",
    y = "Average Amount Spent per Order",
    size = "Number of Orders"
  )

check_df %>%
  group_by(YearMonth) %>%
  summarise(orders = n(), .groups = "drop") %>%
  ggplot(aes(x = YearMonth, y = orders, group = 1)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Order Volume Over Time (Sep 2023 – Sep 2024)",
    x = "Year-Month",
    y = "Number of Orders"
  ) +
  theme(axis.text.x = element_text(angle = 45))
