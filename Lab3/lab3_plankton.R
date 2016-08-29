setwd('/Users/jpwrobinson/Documents/git_repos/mpa-bmsc/Lab3')


depth<-read.csv('data/depth.csv')
depth$X<-NULL
depth$X.1<-NULL
depth$var<-colnames(depth)[4]
depth$var.val<-depth[,paste(colnames(depth)[4])]
depth[,paste(colnames(depth)[4])]<-NULL
lat<-read.csv('data/lat.csv')
lat$X<-NULL
lat$X.1<-NULL
lat$var<-colnames(lat)[4]
lat$var.val<-lat[,paste(colnames(lat)[4])]
lat[,paste(colnames(lat)[4])]<-NULL
grazingrate<-read.csv('data/grazingrate.csv')
grazingrate$X<-NULL
grazingrate$X.1<-NULL
grazingrate$var<-colnames(grazingrate)[4]
grazingrate$var.val<-grazingrate[,paste(colnames(grazingrate)[4])]
grazingrate[,paste(colnames(grazingrate)[4])]<-NULL
grazingthreshold<-read.csv('data/grazingthreshold.csv')
grazingthreshold$X<-NULL
grazingthreshold$X.1<-NULL
grazingthreshold$var<-colnames(grazingthreshold)[4]
grazingthreshold$var.val<-grazingthreshold[,paste(colnames(grazingthreshold)[4])]
grazingthreshold[,paste(colnames(grazingthreshold)[4])]<-NULL
par<-read.csv('data/par.csv')
par$X<-NULL
par$X.1<-NULL
par$var<-colnames(par)[4]
par$var.val<-par[,paste(colnames(par)[4])]
par[,paste(colnames(par)[4])]<-NULL
recycledn<-read.csv('data/recycledn.csv')
recycledn$X<-NULL
recycledn$X.1<-NULL
recycledn$var<-colnames(recycledn)[4]
recycledn$var.val<-recycledn[,paste(colnames(recycledn)[4])]
recycledn[,paste(colnames(recycledn)[4])]<-NULL
variability<-read.csv('data/variability.csv')
variability$X<-NULL
variability$X.1<-NULL
variability$var<-colnames(variability)[4]
variability$var.val<-variability[,paste(colnames(variability)[4])]
variability[,paste(colnames(variability)[4])]<-NULL

dat<-rbind(depth, grazingrate, grazingthreshold, lat, par, recycledn, variability)



head(dat)

summed<-aggregate(cbind(carbon_diatom, carbon_dinoflagellate) ~var, dat, sum)

summed.var<-aggregate(cbind(carbon_diatom, carbon_dinoflagellate) ~factor(var.val) + var, dat, sum)
head(summed)


ggplot(summed.var, aes('factor(var.val)', carbon_diatom, col='factor(var.val)')) + geom_point() + facet_wrap(~var)
ggplot(summed.var, aes('factor(var.val)', carbon_dinoflagellate, col='factor(var.val)')) + geom_point() + facet_wrap(~var)


range<-aggregate(cbind(carbon_diatom, carbon_dinoflagellate) ~ var, summed.var, range)
range$diatom<-range[,2][,2] - range[,2][,1]
range$dino<-range[,3][,2] - range[,3][,1]

range
