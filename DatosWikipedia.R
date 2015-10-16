#Leer visitas wikipedia de valores del IBEX35
#Consulta:
##https://cran.r-project.org/web/packages/wikipediatrend/vignettes/using-wikipediatrend.htmls


#En caso de que sea necesario instalarlo
#install.packages("wikipediatrend")
#install.packages("ggplot")
#install.packages("xts")
#install.packages("quantmod")
library(wikipediatrend)
library(ggplot2)
library(xts)
library(quantmod)

#Empresas que forman el IBEX35
IBEX35<-c("Banco_Santander")
page_views <- wp_trend(IBEX35, from = "2007-12-01")
#Utiliza la librería wikipediatrend para descargar el número de visitas del término usado en el argumento de la funcíon


ggplot(page_views, aes(x=date, y=count)) +
      geom_line(size=1.5, colour="steelblue") +
      geom_smooth(method="loess", colour="#00000000", fill="#001090", alpha=0.1) +
      scale_y_continuous( breaks=seq(5e6, 50e6, 5e6) ,
                          label= paste(seq(5,50,5),"M") ) +
      theme_bw()

simple_page_views<-page_views[1:2]

page_views_ts<-as.xts(simple_page_views[,2],order.by=simple_page_views[,1])
#Agrupar datos Wikipedia en semanas
#Consulta en
#http://stackoverflow.com/questions/24628707/aggregate-daily-level-data-to-weekly-level-in-r

weekly <- apply.weekly(page_views_ts,sum)

#Cálculo de la medida de cuantificación de la recogida de información en Wikipedia
#Empezamos con media movil de 3 semanas
weekly.mean <- rollmean(weekly,3,align="right")
signal <- weekly[-(1:4)]-weekly.mean

date.start <- start(page_views_ts)
date.end <- end(page_views_ts)

#Descarga datos IBEX35
#Consultas en
#https://books.google.es/books?id=bLjuCAAAQBAJ&pg=PA624&lpg=PA624&dq=ibex35+quantmod&source=bl&ots=gK1Q1lm3mc&sig=VlU8a18HJdt1mszpxg8UKZVwFYk&hl=es&sa=X&ved=0CEEQ6AEwBGoVChMIuqGPjpjDyAIVRtYaCh3ZlQ_D#v=onepage&q=ibex35%20quantmod&f=false
#http://stackoverflow.com/questions/15641534/yahoo-tickers-time-zone-and-merging
tickers <- c("^IBEX")
data <- new.env() # the data environment will store the data
do.call(cbind, lapply( tickers
                       , getSymbols
                       , from = date.start
                       , to = date.end
                       , env = data # data saved inside an environment
)
)
#Para pegar los datos de Wikipedia con los del IBEX
#a<-merge.xts(weekly,data$IBEX,join='inner')
#Cálculo rendimientos

