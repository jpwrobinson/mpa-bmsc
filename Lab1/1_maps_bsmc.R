#Lab 1 Marine Protected Areas

#Annote your files by using # before the text 

#first things is first, set you working drive so that you can save your data into a specified folder

setwd("/Users/jpwrobinson/Documents/git_repos/mpa-bmsc")
setwd("/Users/IMAC3/Documents/git-jpwrobinson/mpa-bmsc")

#In R you can load packages from libraries where script has already been written

#first you need to install the package

install.packages ("maptools")
install.packages ("sp")
install.packages ("foreign")
install.packages ("grid")
install.packages ("lattice")
install.packages ("ggplot2")
install.packages ("ggmap")
install.packages ("mapproj")
install.packages ("rgeos")

#then you load the library
#you have to reload the library each time you open R, but you only have to install.packages once in your life/computer
library(maptools)
library(raster)
library (sp)
library (foreign)
library (grid)
library (lattice)
library(ggplot2)
library(ggmap)
library(mapproj)

#lets load up some map data
## <- is used in R to assign objects to your workspace 
map.world<-map_data(map="world")

## the head command shows us the top 6 rows of an object
head(map.world)

#plot a map
ggplot(map.world, aes(long, lat, group=group))+geom_polygon()+
  labs(title = "World map in R")

#create a map object by saving with the <- sign
firstmap<-ggplot(map.world, aes(long, lat, group=group))+geom_polygon()+
  labs(title = "World map in R")
firstmap

#let zoom in on Canada
#ie subset the data to only include Canada in the dataset
canada.df<-subset(map.world, map.world$region == "Canada")

#what does map.world$region do?

#plot a map
ggplot(canada.df, aes(long, lat, group=group))+geom_polygon()+
  labs(title = "Canada")

#let zoom in on Bamfield
#the database doesn't let you pick bamfield (low resolution the units are the country), but you can
#tell it to zoom in on by giving lats and longs
#ggplot(canada.df, aes(x=c(-125.5,-124.5), y=c(48.5,49.5), group=group))+geom_polygon()+
#  labs(title = "Canada")

#lets use google maps since the resolution is a lot better
vanisle<-get_map(location="Vancouver Island", zoom = 7, maptype="hybrid")

#this plots the map
VanIsle.map<-ggmap(vanisle)+labs(title="VanIsle")
print(VanIsle.map)

#this retrieves the data
BMSC<-get_map(location="Bamfield", zoom = 14, maptype="hybrid")

#lets take a look at what the function get_map does 
?get_map

#this plots the map
BMSE.map<-ggmap(BMSC)+labs(title="Bamfield")
print(BMSE.map)

#lets get closer to bamfield
#lat long from the internet lon=-125.1356,lat=48.83528
bmsc<-get_map(location=c(lon=-125.1356,lat=48.83528), zoom = 19,maptype=c("satellite"))
BMSC.map<-ggmap(bmsc)+labs(title="BMSC")
print(BMSC.map)

#-----------------------------------------------------------------------------
#----------------------HEAD OUTSIDE TO COLLECT GPS POINTS---------------------
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------

#lets add up the data points that you took from around campus
#your excel sheet needs to be SAVED AS A .csv (comma seperated file)
#you should have the columns names set as "lat", "long" (remembers longs are negative), and "location" and "time"
#time has to be in a special format

# read.csv is used to read in raw data in R. S
bmsc.pts <-read.csv("GPStest.csv")

#create a map object that we can build upon
GPSmap<-ggmap(bmsc)+geom_point(data = bmsc.pts, aes(x=long, y=lat, shape = location, colour=location))
print(GPSmap)

#lets make it look better
GPSmap<-GPSmap+geom_text(data=bmsc.pts, aes(x=long, y=lat, label=location), hjust=-0.2)
GPSmap<-GPSmap + theme(legend.position = "none", panel.grid.major=element_blank(), 
                       panel.grid.minor = element_blank(), 
                       axis.text =element_blank(), 
                       axis.title = element_blank(), 
                       axis.ticks=element_blank())
GPSmap<-GPSmap + labs(title= "GPS point locations")
print(GPSmap)

#now lets connect points according to substrate type, ie grass, gravel, vegetation area (this information
#should be under the "location" column in your excel spreadsheet)
#these lat longs should be in order from sequentially, and in your csv file from top to bottom
#double check you excel file, fix it if necessary, and load your data back in
bmsc.pts <-read.csv("GPStest.csv")
chkpts <- data.frame(bmsc.pts)
chkpts$location <- factor(chkpts$location) 

# Map 1: use "geom_point" to mark the points
ggmap(bmsc,extent="device") +
  geom_area(aes(x = long, y = lat, colour = location), data = bmsc.pts, alpha = .5, size = 4)

#map with each dot representing density
ggmap(bmsc) + geom_point(data = bmsc.pts, aes(x =long, y= lat,size = density), alpha=0.5) +
  labs(title= "GPS point locations") +
  theme(legend.position = "none", panel.grid.major=element_blank(), 
          panel.grid.minor = element_blank(), 
          axis.text =element_blank(), 
          axis.title = element_blank(), 
          axis.ticks=element_blank())

#-----------------------------------------------------------------------------
#---------------------OR another way to plot this..---------------------------
#-----------------------------------------------------------------------------
#First change time into a POSIXct object. 
#load your data
bmsc.pts <-read.csv("lab1/GPStest.csv")

#check to see if your data loaded correctly
bmsc.pts

#change the type of your data
#time needs to be in the following format YYYY-MM-DD HH:MM. if its not, go back to excel and change
bmsc.pts$time<-as.POSIXct(bmsc.pts$time)

#sort by time  
bmsc.pts <- bmsc.pts[order(bmsc.pts$time),]

#lets subset the database so we can plot gravel and grass
grass<-subset(bmsc.pts, bmsc.pts$location =="grass")
gravel <-subset(bmsc.pts, bmsc.pts$location =="gravel")

#plot using the following
plot(lat~long,data=gravel, col="black", pch = 20, main = "BMSC contour plot")
points(lat~long,data=grass, col="green", pch = 20)     
box(col="grey50")
lines(lat~long,data=gravel, col="black", cex=2) 
lines(lat~long,data=grass, col="green", cex=2) 

#Drawing Polygons form coordinates
#lets check what the function does
?polygon
polygon(bmsc.pts$lat,bmsc.pts$long)
polygon(gravel$long, gravel$lat, col = "black", border = "black")
polygon(grass$long, grass$lat, col = "green", border = "green")

#turn this into a spatial file, in R these are called "spatialpointsdataframes" or "spatialpolygonsdataframe
#you need to do this in order to do spatial analyses such as 
#caclucate area, overlay analyses, etc. 
coordinates(gravel)<-~long+lat
pts<-coordinates(gravel)
# you need to make sure that the last point and first coincide
pts2 <- rbind(pts, pts[1,])
sp <- SpatialPolygons( list(  Polygons(list(Polygon(pts2)), 1)))
plot(sp, col="black", border="black")

#now for grass
coordinates(grass)<-~long+lat
grass.pts<-coordinates(grass)
# you need to make sure that the last point and first coincide
grass.pts2 <- rbind(grass.pts, grass.pts[1,])
sp.grass <- SpatialPolygons( list(  Polygons(list(Polygon(grass.pts2)), 1)))
plot(sp.grass, col="green", border="green")

library(rgeos)
gArea(sp.grass)
