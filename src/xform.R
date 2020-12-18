# https://covid19.who.int
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(geoutils))

dir.create("output", showWarning = FALSE)
dir.create("output/admin0", showWarning = FALSE)

d <- readr::read_csv("https://covid19.who.int/WHO-COVID-19-global-data.csv",
  na = c("", " "))

names(d) <- c("date", "admin0_code", "admin0_name", "who_region_code",
  "cases1", "cases", "deaths1", "deaths")

if (ncol(d) != 8)
  stop("Data format has changed...")

d <- d %>%
  select(!contains("1")) %>%
  filter(admin0_name != "Other") %>%
  select(-admin0_name)

d <- d %>%
  select(-who_region_code) %>%
  left_join(
    select(geoutils::admin0, admin0_code, who_region_code, continent_code),
    by = "admin0_code")

global <- d %>%
  group_by(date) %>%
  summarise(cases = sum(cases), deaths = sum(deaths)) %>%
  arrange(date)

who <- d %>%
  filter(!admin0_code %in% c("XA", "XB", "XC")) %>%
  group_by(who_region_code, date) %>%
  summarise(cases = sum(cases), deaths = sum(deaths)) %>%
  arrange(who_region_code, date)

cont <- d %>%
  filter(!admin0_code %in% c("XA", "XB", "XC")) %>%
  group_by(continent_code, date) %>%
  summarise(cases = sum(cases), deaths = sum(deaths)) %>%
  arrange(continent_code, date)

admin0 <- d %>%
  filter(!admin0_code %in% c("XA", "XB", "XC")) %>%
  select(admin0_code, date, cases, deaths)

stopifnot(select(d, admin0_code, date) %>% distinct() %>% nrow() == nrow(d))

readr::write_csv(admin0, "output/admin0/all.csv")
readr::write_csv(cont, "output/continents.csv")
readr::write_csv(who, "output/who_regions.csv")
readr::write_csv(global, "output/global.csv")
