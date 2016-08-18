# mpa-bmsc
R labs and data for Marine Protected Areas course at Bamfield Marine Sciences Centre (2016)

# #6 Scale bars and north arrows.

Worse case scenario, copy and paste a North Arrow onto your final saved pdf. Up is North, so we're ok. For the scale bar, I am working on a quick fix and I'll put the code up here for you all to use.

Any other R errors and questions - see me!

# #5 Calculating diversity at Scott's bay

The data for calculating diversity at Scott's bay is available at: https://docs.google.com/spreadsheets/d/1IGxccG9DPchddATnYBErAOePjitYwK1InpuQbtyHJBI/edit?usp=sharing

Export or copy the data into a spreadsheet (excel file is ok, but you could use csv later to plot in R). You should be able to calculate the Simpson Diveristy Index for each transect, and then follow the rest of the lab instructions.

Enter your Ross Islet data in the same format for future analysis!

# #4 Mapping and plotting transect data

You should be able to use the ggplot code below to make your maps. ```geom_line()``` will add lines to your map, ```geom_point()```` will add points. Densities and percent covers could be displayed with colours or point sizes (size = )...be creative. What is the best way to display your data?

The class data is in Google Doc:
https://docs.google.com/spreadsheets/d/1UmbazNUiVhUBbNdMPN5QGwIK6zjmbh0BMdNvR_L4x4U/edit#gid=0

Download and save as csv. The different sheets/tabs on the bottom have the density/cover data, and the locations of transect start and end points.

```
bmsc<-get_map(location=c(lon=-125.14712,lat=48.83410), zoom = 19,maptype=c("satellite"))  
BMSC.map<-ggmap(bmsc)+labs(title="Scott's Bay intertidal community") + 
          geom_point(data = transect.pts, aes(x =lon, y= lat,size = barn_dens, col=factor(transect)), alpha=0.5) +
          geom_line(data=transect.pts, aes(x=lon, y=lat, group=transect))
print(BMSC.map)
```
Lots and lots of information on google for formatting ggplot and ggmap figures...copy-paste-edit is encouraged!

http://docs.ggplot2.org/current/ and search 'DO XYZ in ggplot R'

# #3 Google doc link for sharing data

https://docs.google.com/spreadsheets/d/1UmbazNUiVhUBbNdMPN5QGwIK6zjmbh0BMdNvR_L4x4U/edit#gid=0

# #2 Where's Scott's bay?

If you're looking for Scott's bay in the ggmap package, try these co-ordinates...

```
bmsc<-get_map(location=c(lon=-125.14712,lat=48.83410), zoom = 19,maptype=c("satellite"))  
BMSC.map<-ggmap(bmsc)+labs(title="BMSC")   
print(BMSC.map)
```

Not the best looking map, but high-resolution shape files are hard to find. If you add your GPS points to the map we can see how accurate our GPS/googlemap combo is going to be.

```
bmsc<-get_map(location=c(lon=-125.14712,lat=48.83410), zoom = 19,maptype=c("satellite"))  
BMSC.map<-ggmap(bmsc)+labs(title="BMSC")+ geom_point(data = transect.pts, aes(x =long, y= lat,size = percent_cover), alpha=0.5)   
print(BMSC.map)
```

Working on an alternative approach with coastline files [and I'll keep you all posted.] didn't happen. ggmaps working fine.

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
