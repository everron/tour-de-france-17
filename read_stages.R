library(data.table)
library(tidyverse)
library(readr)
library(httr)
library(magrittr)
library(lubridate)
library(stringr)
library(stringi)
library(jsonlite)


# get all riders info

riders_df <- GET("http://fep-api.dimensiondata.com/v2/rider/19") %>% 
  content() %>% 
  rbindlist(fill = TRUE)

write_delim(riders_df,path = "stages/riders.csv",delim = ";")
## read every data stage (from stage 5 to stage 21)

all_stages_df <- list.files("stages", pattern = "tour.*csv", full.names = TRUE) %>% 
  map_df(.f = function(x){
    dt = fread(x,sep = ";",dec = ",") 
    dt[,stage := x]
    dt
    }) 

all_stages_df[,stage := str_extract(stage,"(?<=/).*?(?=\\.)")]

stages_df <- unique(all_stages_df)
