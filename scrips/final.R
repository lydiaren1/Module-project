
#prepare before coding
install.packages("here")
install.packages("tidyverse")

library(here)
library(tidyverse)
library(gganimate)
library(plotly)
library(htmlwidgets)

# Data Import
source <-"https://raw.githubusercontent.com/TheEconomist/big-mac-data/master/source-data/big-mac-source-data-v2.csv"
col_names <- c("name","iso_a3","currency_code","local_price","dollar_ex","GDP_dollar","GDP_local","date")
data <- read.csv(source, skip=1, fill=TRUE)
colnames(data) <- col_names
df<-data

# Data Preparation
library(dplyr)

df <- df %>% 
# Change data type  
  mutate(
    local_price = as.numeric(local_price), 
    dollar_ex = as.numeric(dollar_ex),
    date = as.Date(date, format = "%Y-%m-%d")
  ) %>% 
# Organize data
  rename(country = name) %>% 
  select(date, country, local_price, currency_code, dollar_ex) %>% 
  filter(country %in% 
           c("China", "Euro area", "South Africa", "United States", "Britain"))  %>% 
  group_by(country)


# Add new value

# 1.dollar_price
df <- df %>%
  mutate(dollar_price = local_price / dollar_ex)

# 2.USD
usa_data <- subset(df, country == "United States")
df$USD <- NA  
for (i in 1:nrow(df)) {
  if (df$country[i] == "United States") {
    df$USD[i] <- 0
  } else {
    usa_price <- usa_data$dollar_price[usa_data$date == df$date[i]]
    df$USD[i] <- df$dollar_price[i] / usa_price - 1
  }
}


#ggplot
p <- ggplot(df, mapping=aes(x=date, y=USD, group=country, col=country))
p1<-p+geom_line(size=0.8)+
  scale_color_viridis_d()+
  labs(title="The Big Mac index", x="Year",y="Under/Over Valued",color = "Country") +
  theme(plot.title = element_text(size = 20,face = "bold", family = "Arial"))+
  theme(legend.title = element_text(size = 14,face = "bold", family = "Arial"))+
  scale_x_date(date_labels = "%Y",date_breaks = "2 year")+
  scale_y_continuous(labels = scales::percent, breaks = c(-0.2,-0.4,-0.6,-0.8,0, 0.2, 0.4, 0.6))

#ggplotly
p2 <- p1+ aes(text = paste("Local Price: ", local_price, currency_code))
p2 <- ggplotly(p2) %>%
  layout(title = list(text = "<b>The Big Mac index</b>", x = 0.5),
         annotations = list(text = "<b>How much more expensive/cheaper is McDonald's in different countries than in the US?</b>", 
                            x = 0.5, y = 1.06, xref = "paper", yref = "paper", showarrow = FALSE))
ggplotly(p2)

# USA data
p3 <- ggplot(filter(df, country == "United States"),
             mapping = aes(x = date, y = dollar_price, group = country, col = country))+
  labs(title="The Big Mac Price Of USA", x="Year",y="Price(USD)",color = "Country")+
  geom_point()+
  geom_line()
p3

#ggsave
saveWidget(ggplotly(p2), file='figs.html')
