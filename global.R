load("ALEC.RData")

#require(RJSONIO);
require(jsonlite)#Libreria para convertir el archivo geoJSON a objetos de R
require(rCharts); 
require(RColorBrewer); 
require(httr)
options(stringsAsFactors = F)

#Función para crear el mapa 
dibujarMapa <- function( clusters=12, matriz=diferencias, width = '100%', height=560 , lat=7, lng=-73, tileLayer="http://otile4.mqcdn.com/tiles/1.0.0/osm/{z}/{x}/{y}.png"){
 
  llenado_por_dialecto=colorear_dialectos(clusters, matriz)
  for(i in 1:NROW(teselado["features"])){
    for(j in 1:NROW(teselado["features"][[i]])){
      teselado["features"][[i]][[j]]$properties$style$fillColor=llenado_por_dialecto[j]
    }
  }
  
  
  mapa <- Leaflet$new()
  mapa$set(width = width, height = height)
  mapa$setView(c(lat, lng), 6)
    mapa$geoJson(teselado, onEachFeature = "#! function(feature, layer){
      layer.setStyle({
        weight: 2,
        color: feature.properties.style.color,
        fillColor: feature.properties.style.fillColor,
        fillOpacity: 0.8
      });
      layer.bindPopup(
        feature.properties.Id+'<br/>'+
        'Lugar: '+feature.properties.Municipio+'<br/>'+
        'Tipo de lugar: '+feature.properties.name+'<br/>'+
        'Departamento: '+feature.properties.Departamento+'<br/>'+
        'N° Respuestas vacías: '+feature.properties.vacios+'<br/>'
      )
   }

                 !#")
  mapa$tileLayer(tileLayer)
  return(mapa)
  }



