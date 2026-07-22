#Hypothesis
#H1: Loyalty members spend more per order than non-members.

#T test
t.test(Total.Price ~ Loyalty.Member, data = check_df)
t.test(total_amount ~ Loyalty.Member, data = check_df)
t.test(Quantity ~ Loyalty.Member, data = check_df)
#Model
model_h1 <- lm(total_amount ~ Loyalty.Member + Age + Gender +
                   Product.Type_Laptop + Product.Type_Tablet +
                   Product.Type_Smartphone + Product.Type_Smartwatch +
                   `Payment.Method_Credit Card` + Payment.Method_Paypal + Payment.Method_Cash + `Payment.Method_Debit Card`,
               data = check_df)

summary(model_h1)
#Boxplot
ggplot(check_df, aes(x = factor(Loyalty.Member), y = total_amount)) +
    geom_boxplot(fill = "lightblue") +
    labs(
        x = "Loyalty Member (0 = No, 1 = Yes)",
        y = "Total Amount",
        title = "Total Spending by Loyalty Membership"
    )
#bar chart
check_df %>%
    group_by(Loyalty.Member) %>%
    summarise(mean_spend = mean(total_amount, na.rm = TRUE), .groups = "drop") %>%
    ggplot(aes(x = factor(Loyalty.Member), y = mean_spend)) +
    geom_col(fill = "steelblue") +
    coord_cartesian(ylim = c(2500, 3500)) + 
    labs(
        x = "Loyalty Member",
        y = "Average Total Amount",
        title = "Average Spending by Loyalty Status"
    )
#distribution
ggplot(check_df, aes(x = total_amount, fill = factor(Loyalty.Member))) +
    geom_density(alpha = 0.4) +
    labs(
        fill = "Loyalty Member",
        x = "Total Amount",
        title = "Spending Distribution by Loyalty Status"
    )

#follow up (Loyalty Members Purchase More Frequently)
orders_per_customer %>%
    group_by(Loyalty.Member) %>%
    summarise(
        mean_orders = mean(order_count),
        median_orders = median(order_count)
    )

lifetime_spend %>%
    group_by(Loyalty.Member) %>%
    summarise(
        mean_lifetime_spend = mean(total_spent),
        median_lifetime_spend = median(total_spent)
    )
