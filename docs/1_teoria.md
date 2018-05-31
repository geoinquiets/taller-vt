# Qué son las teselas vectoriales

* qué son,
https://mappinggis.com/2017/09/que-son-los-vector-tiles-y-como-generarlos-con-geoserver/
https://www.mapbox.com/vector-tiles/
https://wiki.openstreetmap.org/wiki/Vector_tiles
https://en.wikipedia.org/wiki/Vector_tiles

* para qué sirven y para qué no,


* cómo están hechas por dentro,


* cómo se almacenan y distribuyen,

### MBTiles

**MBTiles** es un formato de archivo para almacenar conjuntos de teselas. Está diseñado para que pueda empaquetar los potencialmente miles de archivos que componen un conjunto de teselas y moverlos, eventualmente subirlos a Mapbox o usarlos en una aplicación web o móvil. MBTiles es una especificación abierta y se basa en la base de datos SQLite. MBTiles puede contener conjunto de teselas reaster o vector.

MBTiles es una especificación compacta y restrictiva. Solo admite datos teselados, incluidas teselas vectoriales o de imágenes y UTFGrid (hasta la versión 1.2). Solo la proyección esférica de Mercator es soportada para la presentación (visualización) y solo se admiten coordenadas de latitud y longitud para metadatos, como límites y centros.


Unlike Spatialite, GeoJSON, and Rasterlite, MBTiles is not raw data storage. It is storage for tiled data, like rendered map tiles.

Dentro del MBtiles los vectores estan almacenados comprimidos (gzip) y en formato pbf.

* listado de software que soporta/maneja VT

https://github.com/mapbox/awesome-vector-tiles
