url <-  "http://www.thesauruslex.com/typo/eng/enghtml.htm"

url <- "https://www.w3schools.com/charsets/ref_html_8859.asp"

library(rvest)

html_data <- read_html(url)

my_tables <- html_data %>%
  html_nodes("table") %>%
  html_table(fill = T)

df <-  lapply(my_tables[1:4], function(x){

  x[] <- sapply(x, as.character)
  x

})

df <- dplyr::bind_rows(df)
df <- df[nchar(df$`Entity Name`) != 0, ]
df$`Entity Number` <- NULL
df$Number <- NULL

names(df) <- c("character", "entity.name", "description")

encoding_table <- df

devtools::use_data(encoding_table, overwrite = T, internal = T)
