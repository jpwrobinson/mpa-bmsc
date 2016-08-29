
setwd('/Users/jpwrobinson/Documents/git_repos/mpa-bmsc')


## aggregating data across transects
dat<-read.csv("Lab2/lab2_ross_day1.csv")
head(dat)
require(tidyr)
dat1<-gather(dat,species ,abundance, -team, -observer, -transect, -lat, -lon,
             -N_algae, -N_seastar, -N_total)
dat1<-dat1[!colnames(dat1)%in%c("N_algae", "N_seastar", "N_total"),]

theme_set(theme_bw())

## plot 1 - abundances by observer - observer bias?
ggplot(dat1, aes( species,abundance, col=factor(observer))) + 
            geom_point() + 
            facet_wrap(~transect)

## plot 2- abundances across transects
ggplot(dat1, aes(species, abundance, fill=factor(transect))) +
            geom_boxplot()


### reading in data from both days
ross<-read.csv('lab2/ross-transects-master.csv')

## average abundances
avg<-aggregate(cbind(leather, pisaster, fucus, sea.potato, bull, giant, sargassum, turkish ) ~ team + transect + day  , ross, mean)

write.csv(avg, file='lab2/ross_average_density.csv')
## for plotting
dat1<-gather(ross,species ,abundance,-day, -team, -observer, -transect, -lat, -lon)
dat1$bull<-NULL

## plot 1 - abundances by observer - observer bias?
ggplot(dat1, aes( species,abundance, col=factor(observer))) + 
  geom_point() + 
  facet_wrap(day~team)

ggplot(dat1[dat1$abundance<250,], aes( species,abundance, col=factor(observer))) + 
  geom_point() + 
  facet_wrap(day~team)

## plot 2- abundances across transects
ggplot(dat1, aes(species, abundance, fill=factor(transect))) +
  geom_boxplot(day~team)




