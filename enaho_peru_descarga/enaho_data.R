library(tidyverse)
library(lubridate)
library(rvest)
library(haven)
library(readr)
library(stringr)

devtools::install_github('https://github.com/richardastoc/enahoperu')


source('getting_data_master.R')

data_peru=getting_data_master(2011,
                             2022,
                             'VARIABLES.xlsx')



write_rds(data_peru,'data_peru.rds')

write_rds(data_peru,'..//enaho_peru_informe/corruption_app/data_peru.rds')

message('La data fue obtenida exitosamente')
