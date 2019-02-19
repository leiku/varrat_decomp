#Workflow for the manuscript "Decomposition of the variance ratio illuminates 
#timescale-specific population and community variability"
#
#Coded by Lei Zhao (lei.zhao@cau.edu.cn), Daniel Reuman (d294r143@ku.edu), 
#Lauren Hallett (hallett@uoregon.edu), and Shaopeng Wang (shaopeng.wang@pku.edu.cn)
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
checkpoint("2019-01-01",checkpointLocation = "./")

#folder for figures
dir.create("Figs", showWarnings = FALSE)   #create a folder to store the figs

#install the tsvr package from github
library(devtools)
library(withr)
withr::with_libpaths(new=.libPaths()[1],
                     devtools::install_github(repo="reumandc/tsvr",ref="master",force=TRUE))
library(tsvr)

#####  Fig 1. timeseries of the example  #####
#input: null
#output: "fig_example_timeseries.tif"
#        "Data_example_timeseries.RDS"
source("fig_example_timeseries.R")

#####  get clean data #####
#input: csv file from google drive
#output: "Data_grassland.RDS"
source("dataprep_2012synthesisdat.R")

#####  get calculations for basic results  ##### 
#input: "Data_grassland.RDS"
#output: "result_basic.RDS"
source("result_basic.R")

#####  Fig 3. get a demonstration of the empirical application  #####
#input: "Data_example_timeseries.RDS", "result_basic.RDS"
#output: "fig_demon_application.tif"
source("fig_demon_application.R")

#####  Fig 4. lineplot for values averaged across short- and long-timescales  #####
#input: "result_basic.RDS"
#output: "fig_lineplot_average.tif"
source("fig_lineplot_averaged.R")

#####  Fig 5. quantile plot for timescale-specific variance ratio  #####
#input: "result_basic.RDS"
#output: "fig_timescale_quantile.tif"
source("fig_timescale_quantile.R")

#####  Fig 6. timescale-decomposed versus classic variance ratio  #####
#input: "result_basic.RDS"
#output: "fig_new_vs_classic.tif"
source("fig_new_vs_classic.R")

#####  Fig SI. timescale-specific variance, com, and com_ip  ##### 
#input: "result_basic.RDS"
#output: 6 figures ("fig_decomposed_classic_",names.sites[ii],"_sorted_vrf.pdf")
source("fig_timescale_decomposed.R") 
