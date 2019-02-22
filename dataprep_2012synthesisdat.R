rm(list=ls())
## Load libraries
library(dplyr)
library(tidyr)
source("data_import.R")

## To get started use the old LTER synthesis

# read in data
dat <- read_csv_gdrive("0BwguSiR80XFZSnlSMWJWY1hVUTQ") %>%
  tbl_df() %>%
  # clean data
  mutate(site = as.character(tolower((location))),
         uniqueID = as.character(sitesubplot)) %>%
  mutate(species = as.character(species)) %>%
  select(site, uniqueID, species, year, abundance) %>%
  # vasco caves has a few different oldSpecies for brmama, summarize
  group_by(site, uniqueID, species, year) %>%
  summarize(abundance = sum(abundance)) %>% 
  tbl_df() %>%
  group_by(site, uniqueID, species, year) 

# Make a list of sites with a list of species matrices
# higher level list is each site
# lower level list is a year (row) x species (column) matrix for each uniqueID

# Unique sites in the dataset
sites <- unique(dat$site)

# An empty list to populate
allsites <- list()

# Populate the allsites list
for (i in 1:length(sites)){
  # subset the site
  subber <- subset(dat, dat$site == sites[i]) 
  # fill in missing values as 0
  subber2 <- subber %>%
    arrange(year) %>%
    spread(species, abundance, fill = 0) %>%
    as.data.frame()
  # split by uniqueID
  X <- split(subber2, subber2$uniqueID)
  # set the row names for each item in a list
  X1 <- lapply(X, FUN=function(d){rownames(d)=unlist(d[,3]); return(d)})
  # turn it into a matrix and remove unnecessary rows
  X2 <- lapply(X1, FUN = function(d){return(as.matrix(d[,-c(1:3)]))})
  # append to alsites
  allsites[[length(allsites)+1]] <- X2
  # clean up
  rm(subber, subber2, X, X2)
}
# name the items in allsites by the site name
names(allsites) = sites

saveRDS(allsites, "Data_grassland.RDS")
sitenames<-c("cdr","ebrp","Hays, Kansas","Jasper Ridge Biological Preserve",
             "Jornada Basin LTER","Kellogg Biological Station LTER",
             "Konza Prarie LTER","Sevilleta LTER","sgs")
saveRDS(sitenames, "SiteNames.RDS")
