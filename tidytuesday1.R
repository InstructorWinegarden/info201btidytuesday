# 2022-11-29 INFO 201 B Lecture 1:30pm Seattle, WA
# 
# I'm Thomas Winegarden
# Senior Data Scientist at Microsoft 8+yrs
# 2018 to 2021 MS Data Science at UW
# 2010 to 2014 BS UW Informatics HCI focus at UW
# 
# Azure

#Links to stuff
#TIDY TUESDAY
# https://twitter.com/tracykteal/status/1597385673539203078?s=20&t=o_qXSCVrA8eGLzYYhmFMbQ
# https://github.com/rfordatascience/tidytuesday/blob/master/README.md
# https://www.kaggle.com/datasets/evangower/fifa-world-cup

# ggplot
# https://ggplot2.tidyverse.org
# https://r4ds.had.co.nz/data-visualisation.html
# https://r4ds.had.co.nz/graphics-for-communication.html
# https://r-graph-gallery.com

# ggthemes
# https://github.com/WrightWillT/info201_ggplot

# plotly
# https://plotly-r.com/overview.html

# Shiny Apps with R
# great learning docs and videos here:
# https://shiny.rstudio.com/tutorial/
# working demo code in this gallery:
# https://shiny.rstudio.com/gallery/

# shiny theme selector (also multiple tabs!)
# https://shiny.rstudio.com/gallery/shiny-theme-selector.html

# If you're going to use other people's code you need to attribute
# Pay attention to the licensing!
# https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository

# APIs for League of Legends personal game stats
# https://github.com/IamJasonBian/Riot-API-and-Match-History-Analytics

#code from:
# https://github.com/PursuitOfDataScience/TidyTuesdayWork/tree/main/2022-11-29
# https://twitter.com/PursuitOfDS/status/1597670458261807104?s=20&t=tJiIuYXoI7TD7qqcBLXYEQ
# https://youzhi.netlify.app/about/

# co2 data for homework
dl_co_csv <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")
?write.csv()

write.csv(dl_co_csv, file = "owid-co2-data.csv")

# start worldcup demo from PursuitOfDataScience Y. Yu
library(tidyverse)
theme_set(theme_light())

wcmatches <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-29/wcmatches.csv')

write.csv(wcmatches, file = "wcmatches.csv")

# now you can do this instead, and comment out the URL input line so it doesn't load everytime
wcmatches <- read_csv("wcmatches.csv")

worldcups <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-29/worldcups.csv')

write.csv(worldcups, file = "worldcups.csv")

worldcups <- read_csv("worldcups.csv")

# Plot 1

# pivot longer
# https://tidyr.tidyverse.org/reference/pivot_longer.html

# why is the "pipe" not %>% but |> instead?
# https://www.r-bloggers.com/2021/05/the-new-r-pipe/

worldcups_longer <- worldcups |>
  pivot_longer(cols = c(goals_scored:attendance), names_to = "stat") |>
  mutate(stat = str_to_title(str_replace(stat, "_", " ")))

worldcups |>
  pivot_longer(cols = c(goals_scored:attendance), names_to = "stat") |>
  mutate(stat = str_to_title(str_replace(stat, "_", " "))) |>
  ggplot(aes(year, value, fill = stat)) +
  geom_col(show.legend = F) +
  facet_wrap(~stat, scales = "free") +
  scale_fill_brewer(palette = "Set1") +
  labs(x = NULL,
       y = "respective value",
       title = "World Cup Historical Stats")

library(plotly)

ggplotly(worldcups |>
           pivot_longer(cols = c(goals_scored:attendance), names_to = "stat") |>
           mutate(stat = str_to_title(str_replace(stat, "_", " "))) |>
           ggplot(aes(year, value, fill = stat)) +
           geom_col(show.legend = F) +
           facet_wrap(~stat, scales = "free") +
           scale_fill_brewer(palette = "Set1") +
           labs(x = NULL,
                y = "respective value",
                title = "World Cup Historical Stats"))

#ggsave("plot1.png")

# Plot 2

worldcups |>
  pivot_longer(winner:fourth) |>
  count(name, value, sort = T) |>
  complete(name, value, fill = list(n = NA)) |>
  mutate(name = factor(name, levels = c("winner", "second", "third", "fourth"))) |>
  ggplot(aes(name, value, fill = n)) +
  geom_tile() +
  scale_fill_gradient2(high = "green",
                       low = "red",
                       midpoint = 2,
                       mid = "pink") +
  labs(x = NULL,
       y = NULL,
       fill = "# of wins",
       title = "Top 4 Rankings Country Count")

#ggsave("plot2.png")

# Plot 3

wcmatches |>
  mutate(is_group = ifelse(str_detect(stage, "Group"), "Group Game", "After Group Game")) |>
  pivot_longer(cols = c(home_score:away_score)) |>
  mutate(name = str_replace(name, "_", " ")) |>
  ggplot(aes(value, name, fill = is_group)) +
  geom_violin(alpha = 0.7) +
  scale_x_continuous(breaks = seq(0, 10, 2)) +
  scale_fill_brewer(palette = "Set1") +
  labs(x = "score",
       y = NULL,
       fill = NULL,
       title = "World Cup Scores") 

#ggsave("plot3.png")

# Plot 4

wcmatches |>
  pivot_longer(c(home_score:away_score)) |>
  mutate(name = str_replace(name, "_", " ")) |>
  ggplot(aes(value, fill = name)) +
  geom_histogram(alpha = 0.6, position = "dodge", binwidth = 1) +
  scale_x_continuous(breaks = seq(0, 10)) +
  labs(x = "score",
       fill = "",
       title = "Home & Away Score Distribution") 

#ggsave("plot4.png")


