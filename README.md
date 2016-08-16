# mpa-bmsc
R labs and data for Marine Protected Areas course at Bamfield Marine Sciences Centre (2016)

# #1 R setup 

#### Welcome to Marine Protected Areas 2016 at BMSC!

This folder contains all of the R scripts and data files that we will be using in the labs section of the course.

Before you get started you will need to install R, R Studio, and set up a folder on your desktop for running code.

**1. Install R.**

http://cran.stat.sfu.ca/

**2. Install R Studio.**

https://www.rstudio.com/products/rstudio/download2/

*If the internet is slow, we will pass around some usb sticks with windows/mac installers*

**3. Install some packages in R.**

Open R Studio and copy-paste these lines into the 'console' in the bottom-left hand window.

```
install.packages("stringr")
install.packages("ggmap")
install.packages("raster")
install.packages("ggplot2")
install.packages("sp")
install.packages("foreign")
install.packages("mapproj")
install.packages("rgeos")
install.packages("grid")
```

In the console you should see R attempting to download and install packages. Let this run until everything is installed.

**4. Create a folder on your desktop called *MPA-labs***

*for now, please keep this folder on your desktop*

In R Studio, go to File > New File > R Script [or press command + shift + N] and then copy this code into the file that appears in the top-right hand window. 

Windows: 
```
setwd(C:/Users/Username/Desktop/MPA-labs)
```
Mac: 
```
setwd("Users/Username/Desktop/MPA-labs")
```

Change 'Username' to the relevant username of your personal computer, and then push command + enter (Mac) or control + enter (Windows) with your cursor on that line of text. If the console (bottom-left hand window) now shows that setwd(...) line, and **there is no red error message**, then we are ready to get started!

Every time you start a new R script you will want to include the setwd (= set working directory) command at the top of your script. This tells R where to look for data and where to save figures and results. We will always be working in the MPA-labs folder.
