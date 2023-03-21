

# Clear plots
if(!is.null(dev.list())) dev.off()
# Clear console
cat("\014") 
# Clean workspace
rm(list=ls())



library(raster)
library(sf)
library(exactextractr)

library(sp)
library(rgdal)

library(maptools)

#library(shapefiles)



############################### Cargo raster y lo plot
Vilcanota<- raster("C:\\Disco D\\METEOR Disco D\\INAIGEM_GIS_Lagunas\\Persistencia\\Vilcanota\\Raster NDWI\\Vilcanota20201218.tif")
#Vilcanota <- projectRaster(Vilcanota, crs="+proj=longlat +datum=WGS84 +no_defs" )
Vilcanota
plot(Vilcanota,
     col=gray(0:100/100),
     axes=TRUE,
     main="Vilcanota")

############################# Cargo shape y aprovecho su dataframe
Vilcanota_lagunas<-readOGR('C:\\Disco D\\METEOR Disco D\\INAIGEM_GIS_Lagunas\\Persistencia\\Vilcanota\\Raster NDWI\\Lagunas\\Lag_Depur_CVilcanota_PS_2020.shp')
Vilcanota_lagunas.df <- as(Vilcanota_lagunas, "data.frame")


############################## Estadísticas  de R
Vilcanota_lagunas.df$count_R <- exact_extract(Vilcanota, Vilcanota_lagunas, 'count')
Vilcanota_lagunas.df$mean_R <- exact_extract(Vilcanota, Vilcanota_lagunas, 'mean')



############################# Se adjunta estadística de GEE
gee_means <- read.csv("C:\\Disco D\\METEOR Disco D\\INAIGEM_GIS_Lagunas\\Persistencia\\Vilcanota\\Raster NDWI\\Persistencia_CVilcanota_median_lake.csv")
str(gee_means)



gee_means<-gee_means[gee_means$date == "2020-12-18", ]
gee_means<-gee_means[order(gee_means$OBJECTID_1, decreasing = FALSE), ]  
rownames(gee_means) <- 1:nrow(gee_means)

Vilcanota_lagunas.df$mean_GEE=gee_means$NDWI_SINU






############################## Arreglo de tabla final
Vilcanota_lagunas.df <- Vilcanota_lagunas.df[, c(1:18,20,19,21,22)]
Vilcanota_lagunas.df







############################################################################  Ploteos

# The easiest way to get ggplot2 is to install the whole tidyverse:
#install.packages("tidyverse")

# Alternatively, install just ggplot2:
#install.packages("ggplot2")
library(ggplot2)



ggplot(Vilcanota_lagunas.df,mapping=aes(X_Qgismean))+
geom_histogram()





ggplot(Vilcanota_lagunas.df, mapping=aes(x = X_Qgismean))+ 
geom_boxplot()






ggplot(Vilcanota_lagunas.df,mapping= aes(x=X_Qgismean,y=mean_R, color=Persistenc))+
geom_point()+
ylim(-1,1)+
xlim(-1,1)  
#scale_y_continuous(breaks=seq(-1,1,by=0.05))

ggplot(Vilcanota_lagunas.df,mapping= aes(x=X_Qgismean,y=mean_GEE, color=Persistenc))+
geom_point()+
ylim(-1,1)+
xlim(-1,1) 
#scale_y_continuous(breaks=seq(-1,1,by=0.05))

  

