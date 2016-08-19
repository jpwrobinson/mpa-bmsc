# mpa-bmsc
R labs and data for Marine Protected Areas course at Bamfield Marine Sciences Centre (2016)

# #11 Publication quality plots

Lab 2 asks you to make some high-quality figures, but isn't clear about what a high-quality figure might be. There are a few things to think about when making good plots in R:

* colour helps to distinguish between different groups (like transects or species or sites)
* axis titles and labels are important - make them large enough to read from distance, and informative enough to indicate what the data is
* how are you displaying the data? can you use points with lines, or are boxplots the most informative? you want to convince someone else that you have a pattern (or no pattern) in your data, so make it easy for the reader to see what's going on
* legends? you need legends. ggplot has built-in legends, not sure about excel..

Bottom-line: can the reader understand what your results say, without reading much of the text? 

# #10 North Arrow update

Emily's figured out the north arrow issue. If you like (and I know most of you have already put north arrows in so don't worry if you don't fancy changing anything), create your map as usual, but instead of ```print(bsmc.map)``` do ```north2(bsmc.map, 0.2, 0.4)``` and see how you go.

You'll need the ggsn package that gives you the scale bar. The 0.2, 0.4 indicate the relative position of the north arrow, so change around if you're not happy with the position.

# #9 BETA DIVERSITY UPDATE

Please all note that Transect 1 at Scott's bay DID record Pistaster and leather seastar species, and acorn and brown barnacles. These species are now on the master quadrat dataset on google docs.

# #8 Shitty north arrow.

```
 geom_segment(aes(x = -125.1465, y = 48.83452, xend = -125.1465, yend = 48.83460),col="white", arrow = arrow(length = unit(0.5, "cm"))) +
 annotate("text", x=-125.1465, y=48.83462, label="N", col='white')
  ```

# #7 ggplotting your diversity data

You can use ggplot to look at trends in the diversity estimates across quadrats, transects and sites. Ignore all of the ggmap stuff - here you want to use ggplot() and build up your plot by adding different lines of code that describe different objects (points, lines etc.) or style aspects (themes, colour palettes etc.). The points and lines are most important - make sure you can display the data properly before moving onto formatting stuff.

So, you always start with:

```
ggplot(data, aes(x = x, y = y)) + geom_SOMETHING()
```

Data is your dataset, and y and x are the column names for the data on the y and x axes. You can use a geom_point or geom_line or geom_boxplot to display your data. To distinguish between sites or quadrats you might use colours (in the aes() part, say col = SOMETHING), shapes (shape = SOMETHING), colour fill (fill = SOMETHING). Also look into ```+ facet_wrap(~SOMETHING)``` to make multipanel plots (maybe for different sites or transects).

Remember to check your brackets and + symbols. If your plot broke after you added something but was working earlier, try running the old plot code first to see that everything is still working.

Again: docs.ggplot2.org/current/index.html for good examples.

# #6 Scale bars and north arrows.

Worse case scenario, copy and paste a North Arrow onto your final saved pdf. Up is North, so we're ok. 

For the scale bar, we're going to need to install a new package (sorry....)

```
install.packages('ggsn')
library(ggsn)
```

Then, you need to change the name of your longitude column from 'lon' to 'long'. Substitute your data frame name into 'data' below:

```
colnames(data)[colnames(data)=='lon']<-'long'
```

Then, add this to your ggplot code with an extra + symbol

```
+ scalebar(locations, dist = 0.02, dd2km = T, model = 'WGS84') 
```

Close your eyes. Push command/control + enter. Pray. Open your eyes. Voila. Scale bar. 

Might need some customisation, so look around the help file (?scalebar) to find how to change things.

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
