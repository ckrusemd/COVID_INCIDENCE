setwd("C:/Users/Christian/OneDrive/COVID_INCIDENCE/Data-Epidemiologiske-Rapport-16102020-4tt9")


library(pacman)
pacman::p_load(openxlsx,dplyr,tidyr,ggplot2,lubridate,tibbletime)

rolling_sum <- rollify(.f = sum, window = 14)

  df <- read.csv("Test_pos_over_time.csv",sep = ";") %>%
  slice(c(1:(nrow(.)-2))) %>% 
  tbl_df() %>%
  dplyr::mutate(ROLLING_SUM=lag(rolling_sum(NewPositive))) %>%
  dplyr::mutate(INCIDENCE=ROLLING_SUM/58) %>%
  dplyr::mutate(Date=ymd(Date)) %>%
  dplyr::select(Date,NewPositive,ROLLING_SUM,INCIDENCE)

df.fit <- df %>%
  filter(Date>=ymd("2020-09-29"))

fit.incidence <- lm(log10(INCIDENCE)~Date,data=df.fit)

predicted.incidence <- 10^predict(fit.incidence,
                                  data.frame(Date=seq.Date(ymd("2020-09-29"),ymd("2021-01-01"),by = "1 day"))) %>%
  tbl_df() %>%
  dplyr::mutate(Date=seq.Date(ymd("2020-09-29"),ymd("2021-01-01"),by = "1 day"))

break_even_date <- predicted.incidence %>% filter(value>60) %>% slice(nrow(.)) %>% .[["Date"]]


df %>%
  ggplot(.,aes(x=Date,y=INCIDENCE)) +
  geom_point() +
  scale_x_date(date_breaks = "1 week",limits=c(dmy("26-02-2020"),dmy("01-01-2021")),date_labels = "%d-%m") +
  scale_y_continuous(limits=c(0,125),breaks=seq(0,125,by=5)) +
  geom_hline(yintercept = 60) +
  geom_abline(slope = -1,intercept = 200) +
  geom_line(data=predicted.incidence,aes(x=Date,y=value),color="red") +
  geom_vline(xintercept = break_even_date,color="red") +
  theme(axis.text.x = element_text(angle = 90))
