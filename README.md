# Workflow for the manuscript "A new variance ratio metric to detect the timescale of compensatory dynamics"

Lei Zhao, China Agricultural University  
Lauren Hallett, University of Oregon  
Shaopeng Wang, Peking University  
Reuman Daniel, University of Kansas
There are additional authors that contributed to the manuscript itself but not to the codes here 

## Introduction

This repository provides the workflow that resulted in all the results for the manuscript. The latex for the supporting information of the manuscript is also included. 

## Running the workflow

See 'master.R' for the workflow. Run it with your R working directory set to directory it
is in. Then see SuppMat.tex and compile (e.g., using pdflatex).

## Dependencies for master.R

R, and the checkpoint package. This codes uses the R `checkpoint` package. This is set up in 
the master file `master.R` near the top, where you will find a line of code specifying a 
date.

    checkpoint("2019-09-28",checkpointLocation = "./")

The `checkpoint` package then automatically scans through code files looking for other 
required R packages. It then downloads and installs the newest versions of those packages 
available on the given date. This helps ensure that re-compiling the document uses _exactly_ 
the same code that was originally used. This can take some time on first run (you are 
warned) but it is faster on subsequent runs because the packages are already installed. This 
also means that R package dependencies should only be the `checkpoint` package, since that 
package should scan for other packages and install them locally. Quite a few MB disk space 
are used (550-650) to install all the packages locally as they existed on the date.

## Dependencies for SuppMat.tex

This is just a latex file, so setups that compile those should work. E.g., you 
will need latex and bibtex.

## Additional dependencies?

If you find additional dependencies were needed on your system, please let us know: 
lei.zhao@cau.edu.cn, reuman@ku.edu. The code was run by Reuman on Ubuntu 16.04 
using R version 3.4.4 and pdflatex; and by Zhao on Windows 10 using R version 3.5.1 and MikTex 2.9. 
It has not been tested on Mac. We have endeavored above to outline dependencies, 
but we have only run the codes on our own machines, so we cannot 
guarantee that additional dependencies will not also be needed on other machines. 
This repository is intended to record a workflow, and is not designed or tested 
for distribution and wide use on multiple machines. It is not guaranteed to work 
on the first try without any hand-holding on arbitrary computing setups.

## Intermediate files:

Compiling the latex automatically produces a lot of 'intermediate' files. Some of these 
can be useful for diagnosing problems, if any. 

## Acknowlegements

This material is based upon 
work supported by the National Science Foundation under Grant Numbers 17114195 and 1442595. Any 
opinions, findings, and conclusions or recommendations expressed in this material are those of 
the author(s) and do not necessarily reflect the views of the National Science Foundation. The 
work was also supported by the James S McDonnell Foundation.
