
load("~/BookPruebas/BookCurrentPrices.Rda")
load ("~/BookPruebas/.RData")


library(tidyverse)
library(rvest)
library(mailR)

DealFinder(Wishlist)

save(BookCurrentPrices,file="~/BookPruebas/BookCurrentPrices.Rda")