#Workflow for the manuscript "A new variance ratio metric to detect the timescale of 
#compensatory dynamics"
#
#Coded by Lei Zhao (lei.zhao@cau.edu.cn), Daniel Reuman (d294r143@ku.edu), 
#Lauren Hallett (hallett@uoregon.edu), and Shaopeng Wang (shaopeng.wang@pku.edu.cn)
#
#There are additional authors that contributed to the manuscript itself but not to 
#the codes here 
#
#See the README.md

#####  Preparing  #####
rm(list=ls())

#checkpoint package - when present, uses the package, sets up a local
#installation of all packages as they existed on the date specified, in the
#same directory as this file. 
library(checkpoint)
if (!dir.exists("./.checkpoint/")){
  dir.create("./.checkpoint/")
}
#checkpoint("2019-02-28",checkpointLocation = "./")
checkpoint("2019-09-28",checkpointLocation = "./")

#folder for figures
dir.create("Figs", showWarnings = FALSE)   #create a folder to store the figs

library(tsvr)

#####  Fig - timeseries of the pedagogical example  #####
#input: null
#output: "fig_example_timeseries.tif"
#        "Data_example_timeseries.RDS"
source("fig_example_timeseries.R")

#####  get clean data #####
#input: csv file from data archive
#output: "Data_grassland.RDS", "SiteNames.RDS"
source("dataprep_2012synthesisdat.R")

#####  get calculations for basic results  ##### 
#input: "Data_grassland.RDS", "SiteNames.RDS"
#output: "result_basic.RDS", "summary_table.RDS", "XTableResult.tex", "TextResults.RData"
source("result_basic.R")

##### get p-values from shuffling ######
#input: "Data_grassland.RDS", "SiteNames.RDS"
#output: "result_shuffling.RDS" (to store the result of 1000 simulations),
#        "result_shuffling_proportion.RDS" (to store the p-values)
source("result_shuffling.R")

#####  Fig - demo for pedagog time series and for one plot  #####
#input: "Data_example_timeseries.RDS", "result_basic.RDS"
#output: "fig_demon_application.tif"
source("fig_demon_application.R")

#####  Fig - lineplot for values averaged across short- and long-timescales  #####
#input: "result_basic.RDS"
#output: "fig_lineplot_average.tif"
source("fig_lineplot_averaged.R")

#####  Fig - quantile plot for timescale-specific variance ratio  #####
#input: "result_basic.RDS"
#output: "fig_timescale_quantile.pdf"
source("fig_timescale_quantile.R")

#####  Fig - timescale-decomposed versus classic variance ratio  #####
#input: "result_basic.RDS"
#output: "fig_new_vs_classic.pdf"
source("fig_new_vs_classic.R")

#####  Figs - timescale-specific variance, com, and com_ip for individual sites  ##### 
#input: "result_basic.RDS"
#output: 7 figures ("fig_decomposed_classic_",names.sites[ii],"_sorted_vrf.pdf")
source("fig_timescale_decomposed.R") 
