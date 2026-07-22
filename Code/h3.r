#Hypothesis
#H3: Order quantities differ significantly across months.

kruskal.test(Quantity ~ Month, data = check_df)

model_h3 <- lm(Quantity ~ Month, data = check_df)
summary(model_h3)

check_df %>%
  group_by(Month) %>%
  summarise(mean_qty = mean(Quantity, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = Month, y = mean_qty, group = 1)) +
  geom_line() +
  geom_point() +
  labs(
    x = "Month",
    y = "Average Quantity",
    title = "Average Order Quantity per Month"
  )

check_df %>%
  group_by(Month) %>%
  summarise(mean_qty = mean(Quantity, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = Month, y = mean_qty)) +
  geom_col(fill = "orange") +
  labs(
    x = "Month",
    y = "Average Quantity",
    title = "Monthly Average Order Quantity"
  )


ggplot(check_df, aes(x = Month, y = Quantity)) +
  geom_boxplot(fill = "wheat") +
  labs(
    x = "Month",
    y = "Quantity",
    title = "Distribution of Order Quantity Across Months"
  )
