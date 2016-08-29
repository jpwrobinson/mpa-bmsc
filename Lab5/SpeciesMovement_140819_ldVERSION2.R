library(base) #sapply function
library(maps)
library(plyr)
library(shapefile)
library (mapdata)   #to load up the map of Madagascar
library (sp)  #over function
library(spatstat)
library(maptools)

setwd("/Users/jpwrobinson/Desktop/MPA-labs")

# #load the ".shp" file (shapefile) which is a standard spatial database file that has a map, projection, and an attribute table
continents<-readShapePoly("lab5/Continents.shp")
# print(proj4string(continents))
# proj4string(continents) <-"+proj=longlat +datum=WGS84" 
plot(continents,  border = "gray") #?plot to see how else you can control the output

#lets load up the wandering albatross location data
albatross<-read.csv("lab5/Albatross_PTT_LD.csv", sep=",", header = T)
head(albatross) 

#lets take a look at the data
plot(albatross$LAT, albatross$LON)

# OPTIONAL:
#convert to spatial data so we can plot it ontop of a map and get spatial info. like distance, area, etc
# coordinates(albatross)= ~LON +LAT 
# plot(continents,  border = "gray", xlim = c(-80,0), ylim = c(-65, 0))
# points(albatross, pch =20, cex=0.8)

## OR, just plot:
head(albatross)
plot(continents,  border = "gray")
points(albatross$LAT, albatross$LON, pch =20, cex=0.8)

#QUESTION 1:how frequently are locations obtained through this ARGOS system at this latitude? (see background info)

#take a look at the data
tail(albatross)

## how does actual data compare with the information you have on the ARGOS system?


#QUESTION 2: how far did this bird travel from its breeding colony during this 2 week deployment?
#turn the points into a line, measure the distance of the line
## list of Lines per id, each with one Line in a list
albatross.lines<-read.csv("lab5/Albatross_PTT_Lines.csv", sep=",", header = T)
head(albatross.lines)

alba.matrix <-as.matrix(albatross.lines[,c(3:2)])
dim(alba.matrix)
head(alba.matrix)

t<-apply(alba.matrix, 1, function(x) spDistsN1(alba.matrix, x, longlat=TRUE))
dim(t)
sum(t[,1])
head(t)

summed.alba <- rep(0, 229)
for (i in 1:229){
  summed.alba[i] <- t[i,i+1]
}
sum(summed.alba)

# #QUESTION 3: what is the mean, max, average distance travelled between points
# mean(summed.alba)
# max(summed.alba)
# min(summed.alba)

#GEOLOCATION
fulmar<-read.table("lab5/Fulmar_GLS.txt",  header = T)
head(fulmar) 
#lets convert to spatial data so we can plot it ontop of a map and get spatial info. like distance, area, etc

#QUESTION 4: PROVIDE A MAP, suitable scale, WITH THE DATA POINTS, LAT, LONG AXIS LABELS, LEGEND
coordinates(fulmar)= ~LONG +LAT 
plot(continents,  border = "gray")
points(fulmar, pch =20, cex=0.8)

#QUESTION 5: What is the maximum, min, average, distance from the breeding colony that this bird travelled?
fulmar.dist<-read.table("lab5/Fulmar_GLS.txt",  header = T)
head(fulmar.dist) 

fulmar.matrix <-as.matrix(fulmar.dist[,c(7:8)])
dim(fulmar.matrix)
head(fulmar.matrix)


#the lat long of the area where this bird was tagged (Eynhallow, Orkney) is 59.142N, -3.1199W
tagged.pt<-c(-3.11, 59.14)
fulmar.d<-spDistsN1(as.matrix(fulmar.matrix), tagged.pt, longlat=TRUE)
head(fulmar.d)

#now we can answer - what is the mean, max, average distance travelled per hour


#QUESTION 7; use a kernel density to find the areas in the NW Atlantic in which this birds was foraging, where are the areas this bird uses the most?
library(ggmap)
fulmar.gg<-read.table("lab5/Fulmar_GLS.txt",  header = T)
ful.map<-get_map(location=c(lon=-10,lat=50), zoom = 3,maptype=c("satellite"))
mapPoints <- ggmap(ful.map)
head(fulmar)
mapPoints + 
  stat_density2d(data=fulmar.gg,aes(LONG, LAT,fill= ..level..), alpha =0.5, geom="polygon") + 
  geom_point(data=fulmar.gg, aes( LONG, LAT), colour="grey90", alpha = .2)

#QUESTION 8; Tell me about FULMAR life history, ie. what do they eat, how to do they eat, where do they reproduce

#GPS LOGGER
high_res <- read.csv("lab5/Albatross_GPS_High res.csv",   header = TRUE)
head(high_res) 
low_res <- read.csv("lab5/Albatross_GPS_Low res.csv",  header = T)
head(low_res)

#QUESTION 9; put the high res points, and the low res points on a map together!
#make sure you are zoomed in so I can see any land features
#here is a start
# coordinates(high_res)= ~LON +LAT
# coordinates(low_res)= ~LON +LAT

par(mfrow=c(2,2))
par(mfrow=c(1,1))
	plot(continents,  border = "gray",axes=TRUE, xlim=c(-50, -30), ylim=c(-60, -50))
	# points(high_res, pch =20, cex=0.8, col='red')
	points(high_res$LON, high_res$LAT, col='red')
	points(low_res$LON, low_res$LAT, col='black')
	# points(low_res, pch =20, cex=0.8, col='blue')
	plot(continents, border='gray', xlim=c(-80, 0), ylim=c(-80, -30), axes=TRUE)
	rect(xleft=-50, ybottom=-60, xright=-30, ytop=-50, border='red')
	plot(continents,  border = "gray", xlim=c(-39, -38), ylim=c(-55, -53), axes=TRUE)
	# points(high_res, pch =20, cex=0.8, col='red')
	points(high_res$LON, high_res$LAT, col='red')
	

#QUESTION 10; What distance did this bird travel during its 6 day foraging trip using low res database only
low.matrix <-as.matrix(low_res2[,c(4:5)])
head(low.matrix)
dim(low.matrix)
t.low<-apply(low.matrix, 1, function(x) spDistsN1(low.matrix, x, longlat=TRUE))
dim(t.low)
sum(t.low[,1])
head(t.low)

summed.forage <- rep(0, 580)
for (i in 1:580){
  summed.forage[i] <- t.low[i,i+1]
}
sum(summed.forage)
# 3314.797 km
#QUESTION 11; what is the average speed this bird was flying?
head(low_res2)

#QUESTION 12; how many data points are there for the high_res file and the low_res? 
# How would the difference in sampling (low and high res) affect
#estimates of a) distance travelled and b) flight speed?

 # dim(low_res); dim(high_res)

#GPS MOBILE PHONE TAG
#see KMZ file, double click to open in google earth
#question 13 and 14 
#13.  Explore the individual variation in the movements of these 10 seals, how are they the same? Difference?
#14.	Which major haul-out areas do these seals appear to use?

#T-PODS (TIMED PORPOISE DETECTORES)
#QUESTION 15. WHAT IS THE MEAN CLICKS FOR DOLPHINS? PORPOISES? 
clicks <- read.csv("lab5/ClickData_LD2.csv", header = TRUE)
clicks2<-as.data.frame(clicks)
head(clicks2)
dolphin<-subset(clicks2, species =="dolphin")
porpoise<-subset(clicks2, species =="porpoise")
a<-mean(dolphin$clicks)
b<-mean(porpoise$clicks)


#OR
means<-aggregate(clicks ~ species, clicks2, mean)

#QUESTION 16. IS THIS DIFFERENCE SIGNIFICANT? REPORT YOUR PVALUE
t.test(clicks2$clicks ~ clicks2$species)

#plot the relationship between time and clicks for dolphins
head(dolphin)
plot(dolphin$clicks ~ dolphin$time)

#so messy! lets add us the clicks per day
# day<-ddply(clicks2, .(species, day), function (x) data.frame (sum = sum(x$clicks)))
day<-aggregate(clicks ~ species + day, clicks2, sum)
head(day)

day.do<-subset(day, species == "dolphin")
tail(day.do)
plot(day.do$sum ~ day.do$day)
abline(lm(day.do$day~day.do$sum))

#QUESTION 17; PROVIDE A PLOT OF DAY AND NUMBER OF CLICKS. PLOT SHOULD HAVE ALL OF THE POINTS AND TWO LINES (ONE FOR DOLPHINS AND ONE FOR PORPOISES). 
#POINTS SHOULD BE COLOUR ACCORDING TO SPECIES TYPE

## provide 2 options - multi panel using par....
##					 - same panel, y-axis looks bad
##					- ggplot + facet_wrap()

#QUESTION 18; what is the mean of clicks for dolphins during the day and night (daytime = 4-20:00)
head(dolphin)
dim(dolphin)
daylight <-subset(dolphin, dolphin$time<20.00 &  dolphin$time>3.59 )
dim(daylight)
mean(daylight$clicks)
night <- subset(dolphin, dolphin$time>19.59|dolphin$time<4.00 )
dim(night)


#QUESTION 19; is the difference signficant?
t.test(night$clicks ,daylight$clicks)

#Yes. p=0.017


#QUESTION 20; what is the mean clicks for porpoises during the day and night? 
daylight <-subset(porpoise, porpoise$time<20.00 &  porpoise$time>3.59 )
dim(daylight)
mean(daylight$clicks)
night <- subset(porpoise, porpoise$time>19.59|porpoise$time<4.00 )
dim(night)


#QUESTION 19; is the difference signficant?
t.test(night$clicks ,daylight$clicks)
#QUESTION 21; is this relationship significant?
#NO. p=0.7224