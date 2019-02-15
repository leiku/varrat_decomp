#Workflow for the manuscript "Decomposition of the variance ratio illuminates timescale-specific population and community variability"
#coded by Lei Zhao (lei.zhao@cau.edu.cn)

########### Preparing ##########
rm(list=ls())
dir.create("Figs")   #creat a folder to store the figs

#install the following packages if you haven't; skip if you have
#install.packages("devtools")
#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("plyr")
#install.packages("scales")
#install.packages("normtest")

library("devtools")
install_github("reumandc/tsvr")


#################  Fig 1. timeseries of the example (by Daniel Reuman)  #################
#input: null
#output: "fig_example_timeseries.tif"
#        "Data_example_timeseries.RDS"
source("fig_example_timeseries.R")

################   get clean data (by Lauren Hallett)                  ##################
#input: csv file from google drive
#output: "Data_grassland.RDS"
source("dataprep_2012synthesisdat.R")


################   get calculations for basic results                  ################## 
#input: "Data_grassland.RDS"
#output: "result_basic.RDS"
source("result_basic.R")


################    Fig 3. get a demonstration of the empirical application  ###########
#input: "Data_example_timeseries.RDS", "result_basic.RDS"
#output: "fig_demon_application.tif"
source("fig_demon_application.R")



########## Fig 4. lineplot for values averaged across short- and long-timescales  #####
#input: "result_basic.RDS"
#output: "fig_lineplot_average.tif"
source("main_plot_lineplot_timescale_averaged.R")


########## Fig 5. quantile plot for timescale-specific variance ratio  ################
#input: "result_basic.RDS"
#output: "fig_timescale_quantile.tif"
source("fig_timescale_quantile.R")



#########  Fig 6. timescale-decomposed versus classic variance ratio    ###############
#input: "result_basic.RDS"
#output: "fig_timescale_quantile.tif"
source("fig_timescale_quantile.R")


#Fig S. timescale-specific variance, com, and com_ip                   ################ 
#input: "result_basic.RDS"
#output: 6 figures ("fig_decomposed_classic_",names.sites[ii],"_sorted_vrf.pdf")
source("fig_timescale_decomposed.R")  








