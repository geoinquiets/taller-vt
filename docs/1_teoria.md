# Qué son las teselas vectoriales

Las teselas vectoriales son un formato de datos liviano para almacenar datos vectoriales geoespaciales, como puntos, líneas y polígonos. Las teselas vectoriales codifican información geográfica de acuerdo con la especificación de teselas vector de Mapbox. La especificación de Mapbox es un estándar abierto bajo una licencia Creative Commons Attribution 3.0 US.

Una tesela vectorial (vector tiles) contiene datos vectoriales georreferenciados (puede contener múltiples capas), recortados en teselas para facilitar su recuperación. Son equivalentes a las teselas raster tradicionales (WMTS, TMS) pero retornan datos vectoriales en lugar de una imagen.

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

## Diferencias entre teselas raster y teselas vectoriales

* El estilo se define en el cliente (vector) y no en el servidor (raster)
* Teselas vectoriales sólo se necesita teselar la información una sola vez y se pueden tener múltiples mapas
* Vectores se ven mejor en dispositivos de alta resolución
* Teselas raster son más fáciles de consumir.
* El tamaño de una tesela vectorial (se recomienda máximo 500kb) suele ser menor que una tesela de imágenes (promedio 75% más pequeñas), lo que permite una mayor velocidad de transferencia.
* El cliente tiene acceso nativo a la información actual del objeto geográfico (atributos y geometría), lo que permite un procesamiento muy sofisticado.
* Las cache de datos vectoriales ocupa mucho menos espacio que las restar. Esto hace que sea fáctible el uso de teselas vectorials en dispositivos móviles sin conexión.
* Las teselas vectoriales permiten *Overzoom* sin perder resolución. Con las teselas raster si queremos hacer un zoom a un nivel mayor del que está definido la imagen se verá borrosa y pixelada.

Overzooming is a vector-tile specific technique that allows a specific tile to be rendered beyond its intended zoom level, so it continues to be visible on the map. If a tileset had a minzoom of 6 and a maxzoom of 12, those are the valid ranges calculated by the tile generator (more on that below). If you were to zoom your map beyond zoom level 12, the map renderer can continue to use zoom 12 by scaling the vector data upwards. This, of course, can result in gross simplifications of data if geometries are rendered too far above their actual level of detail.

Overzoom is the result of a tileset being zoomed in beyond its given zoom extent.

Raster tilesets will appear to lose clarity if overzoom occurs. For example, if you are displaying a raster tileset with a zoom extent between z0 and z6, if you zoom to a higher zoom level past z6, the imagery will become blurry and difficult to see.

The effects of overzoom are not as noticeable with vector tilesets since vector data is not stored in a pixel-based format, but rather encoded and calculated from a series of points, lines, and polygons. Because of this, vector data can be overzoomed and visualized to zoom 22.

![Comparativa pesos teselas vector vs raster](img/vector-raster.png)
Comparativa pesos teselas vector vs raster. Fuente https://plot.ly/~mourner/118.embed

### Comparación con otros formatos

#### WMS

* No teselado, con lo cual no hay problemas de etiquetas, etc
* Se puede imprimir pero hay problemas con Hi-DPI

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

## Cómo están hechas por dentro

Las geometrías y los atributos se codifican como datos binarios de Google Protobuf (PBF).

### Codificar geometrías

Para codificar información geográfica en una tesela vectorial, una herramienta debe convertir las coordenadas geográficas, como la latitud y la longitud, en coordenadas vectoriales de cuadrículas. Las teselas de vectoriales no tienen ningún concepto de información geográfica. Codifican puntos, líneas y polígonos como pares x/y relativos a la esquina superior izquierda de la cuadrícula de forma descendente.

Las geometrías son transformadas a una sola tesela, con un sistema de coordenadas de píxel local, que por defecto va de la esquina superior izquierda (0,0) a la esquina inferior derecha (4096,4096).

![Codificar geometría](img/geo2pbf.gif)

Codificar geometría. Fuente https://www.mapbox.com/vector-tiles/specification/#encoding-geom

### Codificar atributos

los atributos de características se codifican como un conjunto único de claves (algo así como un esquema de campos de capa) y la lista de sus valores.

Los atributos están codificados en una serie de etiquetas que existen dentro de un elemento en el vector que tienen valores enteros que hacen referencia a las claves y los valores que provienen de la geometría. Para geometrías grandes, esto elimina la redundancia de los atributos que tienen las mismas claves y valores similares.

![Codificar atributos](img/atributos2pbf.png)

Codificar atributos. Fuente https://www.mapbox.com/vector-tiles/specification/#encoding-attr

### Winding order

El *Winding order*(dirección de digitalización) se refiere a la dirección en que se dibuja un anillo en un mosaico vectorial, ya sea en sentido horario o antihorario. Muchas geometrías son multipolígonos con "agujeros", que también se representan como anillos de polígono. Es importante poder inferir orden para extraer datos fuente de un mosaico vectorial y comprender si la geometría es parte de un polígono múltiple o un polígono único.

Para que los procesadores distingan de manera apropiada qué polígonos son agujeros y cuáles son geometrías únicas, la especificación requiere que todos los polígonos sean válidos (validez de OGC). Cualquier anillo interior poligonal debe orientarse con el orden opuesto al de su anillo exterior principal y todos los anillos interiores deben seguir directamente el anillo exterior al que pertenecen. Los anillos exteriores deben estar orientados en el sentido de las agujas del reloj y los anillos interiores deben estar orientados en sentido contrario a las agujas del reloj.

![Winding order](img/winding-order.png)

Winding order. Fuente https://www.mapbox.com/vector-tiles/specification/#winding-order

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

## Presentación de ejemplos visuales hechos con vt

* Terreno https://openicgc.github.io/
* Luces LA https://cityhubla.github.io/lacity_exploration_18/index.html#16.38/34.053569/-118.242875/36/55
* https://twitter.com/jessewhazel/status/981379944440877058 código https://codepen.io/jwhazel/pen/NYzpWG
* https://vimeo.com/263466166 blog explicativo https://medium.com/@erdag/mappox-mapmadness18-round-4-1251a8c10421

* para qué sirven y para qué no,
TODO

## Exponer esquema general de lo que se va a hacer en el taller.

TODO




* cómo se almacenan y distribuyen,

TODO

Cada conjunto de teselas vectoriales tiene su propio esquema. Un esquema consiste en nombres de capas, atributos, selección de elementos, etc.

No existe un esquema que sirva para todo. Existen varios esquemas como por ejemplo: OpenMapTiles, Mapbox Streets, etc.

* listado de software que soporta/maneja VT

https://github.com/mapbox/awesome-vector-tiles
