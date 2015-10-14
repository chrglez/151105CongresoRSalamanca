#https://cran.r-project.org/web/packages/wikipediatrend/vignettes/using-wikipediatrend.htmls

#☺En caso de que sea necesario instalarlo install.packages("wikipediatrend")
library(wikipediatrend)
library(ggplot2)

page_views <- wp_trend("main_page")
ggplot(page_views, aes(x=date, y=count)) +
      geom_line(size=1.5, colour="steelblue") +
      geom_smooth(method="loess", colour="#00000000", fill="#001090", alpha=0.1) +
      scale_y_continuous( breaks=seq(5e6, 50e6, 5e6) ,
                          label= paste(seq(5,50,5),"M") ) +
      theme_bw()

simple_page_views<-page_views[1:2]
page_views_ts<-as.xts(simple_page_views[2],order.by=as.Date(simple_page_views[1]))
#Falla porque no reconoce la columna 1 como fecha. Mirar
