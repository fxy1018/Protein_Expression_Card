library(pool)
library(dplyr)
require("httr")
require("jsonlite")
library(async)
library(future)
plan(multiprocess)
library(Hmisc)
library(shiny)
library(DBI)
library(jsonlite)

#################connect to database#################
host = Sys.getenv(c("MYSQL"))
username = Sys.getenv(c("MYSQL_USER"))
password = Sys.getenv(c("MYSQL_PASSWORD"))


my_db2 <- dbPool(
  RMySQL::MySQL(),
  dbname = "protein_exp",
  host = host,
  username=username,
  password = password
)
conn <- poolCheckout(my_db2)
dbSendQuery(conn, "SET NAMES utf8;")
dbSendQuery(conn, "SET CHARACTER SET utf8;")
dbSendQuery(conn, "SET character_set_connection=utf8;")

poolReturn(conn)

# info_source= data.frame(my_db2 %>% tbl('info_source'))
# franchise= data.frame(my_db2 %>% tbl('franchise'))
# organ= data.frame(my_db2 %>% tbl('organ'))
# cell_type= data.frame(my_db2 %>% tbl('cell_type'))
# primary= data.frame(my_db2 %>% tbl('primary'))
# cell= data.frame(my_db2 %>% tbl('cell'))
# species= data.frame(my_db2 %>% tbl('species'))
# cell_source= data.frame(my_db2 %>% tbl('cell_source'))
# treatment= data.frame(my_db2 %>% tbl('treatment'))
# assay_type= data.frame(my_db2 %>% tbl('assay_type'))
# assay = data.frame(my_db2 %>% tbl('assay'))
# signal_strength = data.frame(my_db2 %>% tbl('signal_strength'))
# antibody = data.frame(my_db2 %>% tbl('antibody'))
# detail= data.frame(my_db2 %>% tbl('detail'))
# eln = data.frame(my_db2 %>% tbl('eln'))
# scientist= data.frame(my_db2 %>% tbl('scientist'))
# item_type= data.frame(my_db2 %>% tbl('item_type'))
# path= data.frame(my_db2 %>% tbl('path'))

# experiment = data.frame(my_db2 %>% tbl('experiment_view'))
# print(head(experiment))

# poolClose(my_db2)

appCSS <-
  ".mandatory_star { color: red; }"