library(tidyverse)
library(ggplot2)
#1
table_2 <- table2 %>% spread(key=type,value=count) %>% 
  mutate(rate = cases/population *10000)
table4a
table4b
table_4a <- table4a%>%gather(`1999`,`2000`,key="year",value="cases")
table_4b <- table4b%>%gather(`1999`,`2000`,key="year",value="population")
table_4a %>% inner_join(table_4b, by = "country")
table4 <- merge(table_4a, table_4b, by = c("country", "year"))
table4 <- table4 %>% mutate(rate = cases/population *10000)

#2. 
#3.
#a
library(nycflights13)
flight_date <- flights %>% group_by(year, month, day) %>% 
  summarise(flight_times = n()) %>% 
  unite(date, year,month,day) 

# I caculate the flight times in everyday across the year. 

#b
flights %>%
  mutate(hour1 = dep_time%/%100,
         minute1 = dep_time%%100,
         hour2 = sched_dep_time%/%100,
         minute2 = sched_dep_time%%100,
         test = (hour1 - hour2)*60 + minute1 - minute2) %>%
  filter(test != dep_delay) %>%
  select(test, dep_time, sched_dep_time, dep_delay)

# The result shows that they are not consistant. 

#c
flights %>% select(dep_time, sched_dep_time, minute)

min_20_30 <- flights %>% filter(minute>=20&minute<=30) %>% 
  mutate(min_20_30 = ifelse(dep_delay>0,1,0)) %>% select(min_20_30)

min_50_60 <- flights %>% filter(minute>=50&minute<=59|minute == 0) %>% 
  mutate(min_50_60 = ifelse(dep_delay>0,1,0)) %>% select(min_50_60)

# From both min_20_30 and min_50_60, it can be found that early departures 
# of flights in minutes 20-30 and 50-60 are caused by scheduled flights 
# that leave early

#4
library(rvest)
scraping_qbs <-  read_html("https://geiselmed.dartmouth.edu/qbs/")
head(scraping_qbs)
h1_text <- scraping_qbs %>% html_nodes("h1") %>%html_text()
h2_text <- scraping_qbs %>% html_nodes("h2") %>%html_text()
h3_text <- scraping_qbs %>% html_nodes("h3") %>%html_text()
h4_text <- scraping_qbs %>% html_nodes("h4") %>%html_text()
p_text <- scraping_qbs %>%html_nodes("p") %>%html_text()
ul_text <- scraping_qbs %>% html_nodes("ul") %>%html_text()
li_text <- scraping_qbs %>% html_nodes("li") %>%html_text()

#Store the information scarped from website in scrap_qbs
scrap_qbs <- list(h1 = h1_text, h2 = h2_text, h3 = h3_text,
                     h4 = h4_text, p = p_text, ul = ul_text, 
                     li = li_text)

