#Hypothesis
#H2: Orders with ≥3 add-ons receive higher ratings

wilcox.test(Rating ~ HighBundle, data = check_df)

model_h2 <- polr(
  as.factor(Rating) ~ HighBundle,
  data = check_df,
  Hess = TRUE
)

summary(model_h2)

ggplot(check_df, aes(x = factor(HighBundle), y = Rating)) +
  geom_boxplot(fill = "lightgreen") +
  labs(
    x = "High Bundle (≥3 Add-Ons)",
    y = "Rating",
    title = "Customer Rating by Add-On Bundling"
  )


check_df %>%
  group_by(HighBundle) %>%
  summarise(mean_rating = mean(Rating, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = factor(HighBundle), y = mean_rating)) +
  geom_col(fill = "darkgreen") +
  labs(
    x = "High Bundle",
    y = "Average Rating",
    title = "Average Rating by Bundle Size"
  )

check_df %>%
  group_by(add_on_total_count) %>%
  summarise(mean_rating = mean(Rating, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = add_on_total_count, y = mean_rating)) +
  geom_line() +
  geom_point() +
  labs(
    x = "Number of Add-Ons",
    y = "Average Rating",
    title = "Rating Trend Across Add-On Counts"
  )

