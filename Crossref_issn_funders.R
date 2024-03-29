#this script uses the rcrossref package to interface with the Crossref API 
#to get information on funder coverage per ISSN
#Crossref REST API information: https://github.com/CrossRef/rest-api-doc

#use rcrossref
#vignette: https://cran.r-project.org/web/packages/rcrossref/rcrossref.pdf 

#install.packages("tidyverse")
#install.packages("rcrossref")
library(tidyverse)
library(rcrossref)

#set email in Renviron
#file.edit("~/.Renviron")
#add email address to be shared with Crossref:
#crossref_email = name@example.com
#save the file and restart your R session
  
#Use low level API as this includes abstract coverage per type
#set parse = FALSE to get JSON, parse = TRUE to get list output
getCrossref_low <- function(offset){
  res <- cr_journals_(offset = offset,
                     limit = 1000,
                     parse = TRUE) %>%
  
  .$message %>%
  .$items
  
  return(res)
}

#add progress bar to function
getCrossref_low_progress <- function(offset){
  pb$tick()$print()
  result <- getCrossref_low(offset)
  
  return(result)
}

#extract relevant variables with pluck
#also consider (from ?pluck):
#The map() functions use pluck() by default to retrieve multiple values from a list:
# map(x, list(2, "elt")) is equivalent to map(x, pluck, 2, "elt")

extractData_all <- function(x){
  data <- tibble(
    id = map_dbl(x, "id"),
    primary_name = map_chr(x, "primary-name"),
    count_current_type = map_dbl(x, 
                                 list("counts",
                                      "current-dois"),
                                 .default = 0),
    deposits_funders_current = map_lgl(x,
                                         list("flags",
                                              "deposits-funders-current"),
                                         .default = NA),
    funders_current_type = map(x,
                                 list("coverage",
                                      "funders-current"),
                                 .default = 0)) %>%
    #keep only issns with (current) output of type
    filter(count_current_type > 0) %>%
    #convert abstract coverage into numerical, then percentage
    mutate(funders_current_type = as.double(funders_current_type),
           funders_current_type = round(funders_current_type, 3)) %>%
    #arrange in descending order of count
    arrange(desc(count_current_type))
  
  return(data)
}



extractData_type <- function(x, type){
  data <- tibble(
    id = map_dbl(x, "id"),
    primary_name = map_chr(x, "primary-name"),
    count_current_type = map_dbl(x, 
                                 list("counts-type",
                                      "current",
                                      type),
                                 .default = 0),
    deposits_funders_current = map_lgl(x,
                                         list("flags",
                                              "deposits-funders-current"),
                                         .default = NA),
    funders_current_type = map(x,
                                 list("coverage-type",
                                      "current",
                                      type,
                                      "funders"),
                                 .default = 0)) %>%
    #keep only members with (current) output of type
    filter(count_current_type > 0) %>%
    #convert abstract coverage into numerical
    mutate(funders_current_type = as.double(funders_current_type)) %>%
    #arrange in descending order of count
    arrange(desc(count_current_type))
  
  return(data)
  }

#define function to write to csv
toFile <- function(type, data, path){
  filename <- paste0(path,"/crossref_issn_funders_current_", type, "_", date,".csv")
  write_csv(data, filename)
}


#------------------------------------------------------------------------------

#set date
date <- Sys.Date()
#create output directory
path <- file.path("data_issn",date) 
dir.create(path)


#get number of issns
res <- cr_journals(limit=0)
total <- res$meta$total_results

#set vector of offset values
c <- seq(0, total, by=1000)

#set parameter for progress bar
pb <- progress_estimated(length(c))

#get API results, flatten into 1 list
res <- map(c, getCrossref_low_progress) %>%
  flatten()

#extract data for different types, write each to file
type = "all"
data <- extractData_all(res)
toFile(type, data, path)

type = "journal-article"
data <- extractData_type(res, type)
toFile(type, data, path)

type = "posted-content"
data <- extractData_type(res, type)
toFile(type, data, path)

type = "book-chapter"
data <- extractData_type(res, type)
toFile(type, data, path)
