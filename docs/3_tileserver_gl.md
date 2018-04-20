# Cómo servir teselas vectoriales

## TileServer GL

El [TileServer GL](http://tileserver.org/) es un servidor de mapas de código abierto creado para teselas vectoriales, y
capaz de renderizar en teselas raster con MapBox GL Native engine en el lado del servidor.

Proporciona mapas para aplicaciones web y móviles. Es compatibles con Mapbox GL JS, Android SDK, iOS SDK, Leaflet,
OpenLayers, HighDPI/Retina, SIG a través de WMTS, etc.

Si se quiere servir teselas raster lo mejor es utilizar la versión de Docker ya que son necesarias algunas librerías
nativas que pueden variar dependiendo de la plataforma, estas librerías sirven para renderizar las teselas vectoriales en teselas raster. Si únicamente se quiere servir teselas vectoriales se puede utilizar el TileServer GL Light que no tiene ninguna dependencia nativa ya que está desarrollado en javascript.

### Instalación

Para este taller utilizaremos la versión Light ya que serviremos sólo teselas vectoriales.

Es necesario tener instalado [Node.js](https://nodejs.org/es/) versión 6.

!!! warning
    tileserver-gl-light NO se instalará correctamente si estamos usando una versión de Node.js superior a la 6.
    Debemos activar esta versión de node con el comando:

    ```bash
    nvm use 6
    node -v # Debería devolver: 6.x.x
    ``` 
 
Una vez comprobada la versión de node:

```bash
npm install -g tileserver-gl-light@2.3.1
tileserver-gl-light -v # Deberia devolver: v2.3.1 
```

### Obtención de datos

Crear una carpeta llamada `tileserver/data` y copiar en ella el fichero [barcelona.mbtiles](data/barcelona.mbtiles):
 
```bash
mkdir -p tileserver/data
cd tileserver/data
wget https://geoinquiets.github.io/taller-vt/data/barcelona.mbtiles
```

!!! tip
    En la web de [OpenMapTiles](https://openmaptiles.com/downloads) se pueden descargar datos de muchas
    otras ciudades, países, e incluso el planeta entero. Es gratuíto, aunque hay que registrarse.


### Arrancar el servidor

Ahora arrancaremos el servidor en el puerto `8181` (parámetro `-p`):

```bash
tileserver-gl-light barcelona.mbtiles -p 8181
```

Abrir el navegador y escribir http://localhost:8181. Aparecerá la página del TileServer.

Dejar el terminal abierto con el servidor arrancado.

![TileServer GL Light](img/tileServerGL.png)
*TileServer GL Light*


### Modificar el visor de mapas

Modificaremos nuestro archivo *index.html* para que el visor de mapas consuma las teselas vectoriales servidas por
 nuestro TileServer:

``` html hl_lines="22"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mapa VT</title>
    <link rel='stylesheet' href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.44.1/mapbox-gl.css' />
    <script src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.44.1/mapbox-gl.js'></script>
    <link href='https://mapbox-gl-inspect.lukasmartinelli.ch/dist/mapbox-gl-inspect.css' rel='stylesheet' />
    <script src='https://mapbox-gl-inspect.lukasmartinelli.ch/dist/mapbox-gl-inspect.min.js'></script>
    <style>
        html, body {
            margin: 0;
            height: 100%;
        }
    </style>
</head>
<body id='map'>
<script>
    var map = new mapboxgl.Map({
        container: 'map', // id del elemento HTML que contendrá el mapa
        style: 'http://localhost:8181/styles/osm-bright/style.json', // Ubicación del estilo
        center: [2.175, 41.39], // Ubicación inicial
        zoom: 13, // Zoom inicial
        bearing: -45, // Ángulo de rotación inicial
        hash: true // Permite ir guardando la posición del mapa en la URL
    });

    // Agrega controles de navegación (zoom, rotación) al mapa:
    map.addControl(new mapboxgl.NavigationControl());

    // Agregar el control de inspección
    map.addControl(new MapboxInspect());
</script>
</body>
</html>
```
