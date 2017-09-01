library(data.table)
library(dplyr)
library(httr)
library(lubridate
library(jsonlite)

date = Sys.Date()
data_stage = NULL
if(!file.exists(paste0("tour_s",day(date),".Rdata"))){
  save(data_stage,file = paste0("tour_s",day(date),".Rdata"))
}
currTime <- Sys.time()

while (currTime < as.POSIXct(paste(date,"20:00:00",tz = "Europe/Paris"))) {
  print(currTime)
  load(paste0("tour_s",day(date),".Rdata"))
  r <-  try(nothing,silent =TRUE)
  print(class(r))
  while(class(r)[1] == "try-error"){
    r <- try({
      letour <- GET(paste0("http://fep-api.dimensiondata.com/v2/stages/",sample(1:10000,1),"/rider-telemetry"))
      data <- content(letour)
      riders <- data.table(rbindlist(data$Riders),TIMESTAMP = data$TimeStampEpoch)
    },silent = TRUE)
    print(class(r))
  }
  data_stage = rbind(data_stage,riders)
  print(dim(data_stage))
  Sys.sleep(5)
  save(data_stage,file = paste0("tour_s",day(date),".Rdata"))
  write.csv2(data_stage,paste0("tour_s",day(date),".csv"),append = TRUE,row.names = FALSE)
  currTime <- Sys.time()
  print(letour$url)
  
}
