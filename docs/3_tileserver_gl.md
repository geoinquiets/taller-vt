# TileServer GL

El [TileServer GL](http://tileserver.org/) es un servidor de mapas de código abierto creado para teselas vectoriales, y capaz de renderizar en teselas raster con MapBox GL Native engine en el lado del servidor.

Proporciona mapas para aplicaciones web y móviles. Es compatibles con Mapbox GL JS, Android SDK, iOS SDK, Leaflet, OpenLayers, HighDPI/Retina, SIG a través de WMTS, etc.

Si se quiere servir teselas raster lo mejor es utilizar la versión de Docker ya que son necesarias algunas librerías nativas que pueden variar dependiendo de la plataforma, estas librerías sirven para renderizar las teselas vectoriales en teselas raster. Si únicamente se quiere servir teselas vectoriales se puede utilizar el TileServer GL Light que no tiene ninguna dependencia nativa ya que está desarrollado en javascript.

## Instalación

Para este taller utilizaremos la versión Light ya que serviremos sólo teselas vectoriales.

Para instalar el TileServer GL Light es necesario tener instalado el [Node.js](https://nodejs.org/es/) versión 6 o superior. Una vez instalado el Node.js

* Abrir el terminal y escribir `npm install -g tileserver-gl-light`

* Comprobar la instalación. Escribir `tileserver-gl-light -v`. En el terminal debe aparacer un mensaje con la versión del TileServer instalada. 

## Probar el servidor

* Crear una carpeta llamada *datos* dentro del directorio de trabajo **taller-vt-demo**. Escribir en la terminal `mkdir datos`

* Escribir `cd datos` para entrar en el directorio de datos.

* Descargar los datos. Para ello ir [OpenMapTiles](https://openmaptiles.com/downloads) y descargar el archivo **OpenStreetMap vector tiles** del área que se quiera dentro del directorio *datos*. Para este taller descargaremos el archivo de [España](https://openmaptiles.com/downloads/europe/spain/)

* Escribir `tileserver-gl-light 2017-07-03_europe_spain.mbtiles`

* Abrir el navegador y escribir http://localhost:8080 y comprobar que aparece la página del TileServer.

| ![TileServer GL Light](img/tileServerGL.png) |
| :--: |
| *TileServer GL Light* |
