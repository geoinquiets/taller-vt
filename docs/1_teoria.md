# Qué son las teselas vectoriales

* qué son,

https://mappinggis.com/2017/09/que-son-los-vector-tiles-y-como-generarlos-con-geoserver/

https://www.mapbox.com/vector-tiles/

https://wiki.openstreetmap.org/wiki/Vector_tiles

https://en.wikipedia.org/wiki/Vector_tiles

http://blog.sourcepole.ch/assets/2017/t-rex-foss4g2017.pdf

https://www.slideshare.net/jgarnett/vector-tiles-with-geoserver-and-openlayers

https://www.mapbox.com/help/glossary/


* para qué sirven y para qué no,
TODO

## Un poco de Historia

Existe una larga historia de uso de teselas vectoriales en SIG. En 1966 el Sistema de Información Geográfica de Canadá (CGIS), utilizaba un esquema de almacenamiento vectorial que permitía a las computadoras de recursos limitados acceder de manera eficiente y procesar datos de mapas vectoriales. CGIS usó el término "marco" en lugar de teselas vectoriales.

En 1975, el Servicio de Vida Silvestre de los EE.UU. inició un programa nacional para mapear y digitalizar todos los humedales de los EE.UU. En 1976 desarrollan un software que se llamó WAMS (Wetlands Analytical Mapping System). El almacenage de datos del WAMS usaba una estructura de teselas vectorial. Cada tesela se llamaba "geounit". Una geounit correspondía a una de las escalas cuadrangulares del USGS, generalmente 1:24000.

En 1986 basándose en la experiencia operativa adquirida en la implementación y el uso de WAMS y del Map Overlay and Statistical System (MOSS), se lanzó un SIG comercial DeltaMap (más tarde GenaMap) basado en UNIX que implementó una estructura mejorada de almacenamiento y acceso de teselas vectores. DeltaMap permitió al usuario definir cualquier tamaño de tesela en cualquier sistema de referencia de coordenadas (CRS). De esta forma, los datos dispersos requerían solo unas pocas teselas, mientras que los datos densos podían usar teselas mucho más pequeñas. Utilizaban R-trees como el esquema de indexación para las teselas de vectores.

A finales de la década de 1980, se mejoró aún más GenaMap para permitir el procesamiento "continuo e ininterrumpido" de las capas de teselas. Básicamente, desde la perspectiva del usuario final, las teselas se volvieron invisibles. [^1]

[^1] https://en.wikipedia.org/wiki/Vector_tiles

Abril de 2014 Mapbox saca la version 1.0 de la especificación Mapbox Vector Tile (MVT).

Diciembre 2015 versión 2.0 de la especificación MVT.

Marzo de 2015 ESRI (el que no debe ser nombrado) anuncia que soportará MVT.

Mapbox actualmente está trabajando en la versión 3.


TODO

* Concepto teórico, diferencias con "raster" tiles y con formatos vectoriales existentes.

## Diferencias entre teselas raster y teselas vectoriales

* El estilo se define en el cliente (vector) y no en el servidor (raster)
* Teselas vectoriales sólo se necesita teselar la información una sola vez y se pueden tener múltiples mapas
* Vectores se ven mejor en dispositivos de alta resolución
* Teselas raster son más fáciles de consumir

### Comparación con otros formatos

#### WMS

* No teselado, con lo cual no hay problemas de etiquetas, etc.
* Se puede "imprimir facilmente"

#### WMTS

* Escalabilidad
* Cache tanto en cliente como en servidor

#### WFS

* Retorna datos en vector sin modificar

#### Vector Tiles

* Escalabilidad
* Cache tanto en cliente como en servidor
* Interactivo
* Estilo flexible (cliente es quien define el estilo)
* Hi-DPI (impresión)
* Retorna datos en vector modificados (generalizados, simplificados)

## Presentación de ejemplos visuales hechos con vt

* Terreno https://openicgc.github.io/
* Luces LA https://cityhubla.github.io/lacity_exploration_18/index.html#16.38/34.053569/-118.242875/36/55
* https://twitter.com/jessewhazel/status/981379944440877058 código https://codepen.io/jwhazel/pen/NYzpWG
* https://vimeo.com/263466166 blog explicativo https://medium.com/@erdag/mappox-mapmadness18-round-4-1251a8c10421


## Exponer esquema general de lo que se va a hacer en el taller.

TODO

## Diferentes especificaciones: mbtiles, vt, pbf, tilejson, style, sprites, glyphs.

### pbf

**Protocol buffers** desarrollado por Google (para uso interno) es un método para serializar datos estructurados. Es language-neutral, platform-neutral y cuyo objetivo de diseño enfatizaron la simplicidad y el rendimiento.

El método implica un lenguaje de descripción de interfaz que describe la estructura de algunos datos y un programa que genera código fuente a partir de esa descripción para generar o analizar una secuencia de bytes que representa los datos estructurados.

### mvt

Formato binario basado en la especificación de Mapbox que usa **pbf** para serializar datos geográficos. Los archivos deberían tener extensión .mvt pero no es obligatorio así que se pueden encontrar archivos con extensión .pbf, .vector.pbf o .mvt.gz (compresión gzip)

Por ejemplo un conjunto de teselas mvt almacenadas en un SQLite siguiendo una esquema específico formaría un MBTiles.

### MBTiles

**MBTiles** es un formato de archivo para almacenar conjuntos de teselas. Está diseñado para que pueda empaquetar los potencialmente miles de archivos que componen un conjunto de teselas y moverlos, eventualmente subirlos a Mapbox o usarlos en una aplicación web o móvil. MBTiles es una especificación abierta y se basa en la base de datos SQLite. MBTiles puede contener conjunto de teselas reaster o vector.

MBTiles es una especificación compacta y restrictiva. Solo admite datos teselados, incluidas teselas vectoriales o de imágenes y UTFGrid (hasta la versión 1.2). Solo la proyección esférica de Mercator es soportada para la presentación (visualización) y solo se admiten coordenadas de latitud y longitud para metadatos, como límites y centros.

Es una especificación mínima, que solo especifica las formas en que los datos deben ser recuperables. Por lo tanto, los archivos MBTiles pueden comprimir y optimizar datos internamente, y construir vistas que se adhieren a la especificación MBTiles. Dentro del MBtiles los vectores estan almacenados comprimidos (gzip) y en formato pbf.

A diferencia de Spatialite, GeoJSON y Rasterlite, MBTiles no es un almacenamiento de datos sin formato. Es almacenamiento de datos en teselas.

### tilejson

**TileJSON** es un formato para describir un conjunto de teselas. Realiza un seguimiento de dónde solicitar el conjunto de teselas, el nombre del conjunto de teselas y cualquier atribución que sea necesaria al utilizar el conjunto de teselas.

Esta especificación intenta crear un estándar para representar metadatos sobre múltiples tipos de capas, para ayudar a los clientes en la configuración y navegación.


* cómo están hechas por dentro,

TODO

feature geometries are transformed to a single tile, local, pixel coordinate system, which by default goes from upper-left(0,0) to lower-right (4096,4096), i.e. an affine transformation with integer rounding.
features attributes are encoded as a unique set of keys (something like a layer fields schema) and the list of their values.
geometries and attributes are encoded as Google Protobuf (PBF) binary data.


Protocol buffer format (PBF, binary,
Streamable)
> Geometry in screen pixel coordinates
(Integers, ZigZag encoded)
> Multipoint/Multiline/Multipolygon
> Non-spatial attributes (optional Feature-ID)
> Multiple layers per tile


* cómo se almacenan y distribuyen,

TODO

Cada conjunto de teselas vectoriales tiene su propio esquema. Un esquema consiste en nombres de capas, atributos, selección de elementos, etc.

No existe un esquema que sirva para todo. Existen varios esquemas como por ejemplo: OpenMapTiles, Mapbox Streets, etc.

* listado de software que soporta/maneja VT

https://github.com/mapbox/awesome-vector-tiles
