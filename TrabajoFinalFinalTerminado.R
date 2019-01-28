# limpia datos rm(list = ls())

install.packages('rvest')
library('rvest')
DataFramePP<-data.frame()

#For para Recorrer las paginas.
for(i in 1:3){
pagina <- paste('https://www.casamarilla.cl/guitarras/electricas?p=',i,sep = "")
  print(pagina)
#Se lee la pagina
  ReadCA<-read_html(pagina)
#Se comienza la extraccion de la informacion en busqueda de link interno.
 DataCasaAmarilla1<-html_nodes(ReadCA,".item")
 DataCasaAmarilla<-html_nodes(DataCasaAmarilla1,'[type="button"]')
 EnlacesCA<-html_attr(DataCasaAmarilla,"href")
 
#For para abrir link anterior y extraer informacion.
for(link in EnlacesCA){
  print(link)
#Se lee nuevo enlace generado
  DataProductos<-read_html(link)
#Se comienza con la extraccion de:
#TITULO
  Titulo1<-html_nodes(DataProductos,".product-primary-column.product-shop.grid12-6")
  Titulo<-html_nodes(Titulo1,"h1")
  TextoTitulo<-html_text(Titulo)
#PRECIO
  Precio2<-html_nodes(Titulo1,'[itemprop="offers"]')
  Precio3<-html_nodes(Precio2,".escyber")
  Precio1<-html_nodes(Precio3,".price")
  Precio<-html_text(Precio1)
#Limpiar Informacion de Precios.
  Precios1<-gsub("[.]",",",Precio)
  Precios2<-gsub("\n"," ",Precios1)
  Precios3<-gsub("$","",Precios2)[[1]]
#PrecioFinal
  Precios<-gsub("\\$","",Precios3)
#Se crea Data Frame para guardar informacion generada por el bucle.
  NuevoDataFrame<-data.frame(Titulo=TextoTitulo, Precio=Precios)
  DataFramePP<-rbind(DataFramePP,NuevoDataFrame)
  
}
}
#Se procede con la instalacion de la libreria que servira para graficar.
install.packages('ggplot2')
library(ggplot2)
#Se comienza a graficar 
DataFramePP %>%
  ggplot() +
  aes(x = Titulo, y = Precio) +
  geom_bar(stat="identity")

#Extraccion de trabajo realizado en Excel  y texto.
write.csv(DataFramePP, file="TrabajoFinal.csv")
write.table(DataFramePP, file="TrabajoFinal.txt")
