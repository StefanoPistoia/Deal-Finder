library(magrittr)
library(tidyverse)
library(rvest)
library(mailR)
library(taskscheduleR)

rJava::.jinit()
rJava::.jcall("java/lang/System","S","setProperty", "mail.smtp.ssl.protocols", "TLSv1.2")


BookNames <- list()
BookCurrentPrices <- list()
BookNewPrices <- list()


PreciosActuales <- function(x){
  for(i in seq_along(x)){
    BookCurrentPrices[[i]] <<-  read_html(x[[i]]) %>% html_nodes(".sale-price") %>% 
                                html_text2() %>% .[1] %>% parse_number(locale =locale(decimal_mark = ",", grouping_mark = "."))
  }
}

DealFinder <- function(x){
  
  for(i in seq_along(x)){
    
    BookNames[[i]] <<- read_html(x[[i]]) %>% html_nodes("h1") %>% html_text2()
    
    BookNewPrices[[i]] <<-  read_html(x[[i]]) %>% html_nodes(".sale-price") %>% html_text2() %>% .[1] %>% parse_number(locale =locale(decimal_mark = ",", grouping_mark = ".")) 
    
    if((BookNewPrices[[i]]+150) < BookCurrentPrices[[i]]){
      send.mail(from = "ElCorreoDeLasOfertasR@gmail.com",
                to = c("Recipent name <stefanofpistoia@gmail.com>"),
                subject = paste(BookNames[[i]],"paso de $",BookCurrentPrices[[i]],"a $",(BookNewPrices[[i]])),
                body = paste("Podes comprarlo aca:",x[[i]]),
                smtp = list(host.name="smtp.gmail.com", port=465, user.name="ElCorreoDeLasOfertasR@gmail.com", 
                            passwd="thepassword", ssl=TRUE),
                authenticate = TRUE,
                send = TRUE)
      BookCurrentPrices[[i]] <<- BookNewPrices[[i]]
    }
  }
}



taskscheduler_create(taskname = "test_run", rscript = "C:/Users/ESTEFANO/Documents/BookDepository.R", 
                     schedule = "HOURLY", starttime = format(Sys.time(), "%H:%M"),
                     Rexe = file.path(Sys.getenv("R_HOME"), "bin", "Rscript.exe")
                     )
