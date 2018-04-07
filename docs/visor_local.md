# Visor local

En este ejemplo crearemos un visor de mapas utilizando la librería de Mapbox GL JS. Tanto los datos procedente de teselas vectoriales ó vector tiles (VT) como el estilo para simbolizar los mismo se encuentran en nuestro servidor.

* Dentro de la carpeta public crear un directorio llamado *styles* `mkdir styles`

* Descargar el estilo [OSM Bright de OpenMapTiles](https://openmaptiles.org/styles/#osm-bright) dentro de la carpeta *styles*. El archivo de estilo se puede descargar directamente desde [este enlace])https://github.com/openmaptiles/osm-bright-gl-style/blob/master/style.json) 

* Editar el archivo descargado style.json para que cargue los datos desde nuestro servidor local. Para ello modificar la línea 51 y reemplazar la url por `http://localhost:8080/data/v3.json` 

* Dentro de la carpeta public crear un archivo llamado visor_local.html y copiar el siguiente código

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8' />
    <title>Display a map</title>
    <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
    <script src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.44.1/mapbox-gl.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.44.1/mapbox-gl.css' rel='stylesheet' />
    <style>
        body { margin:0; padding:0; }
        #map { position:absolute; top:0; bottom:0; width:100%; }
    </style>
</head>
<body>

<div id='map'></div>
<script>
var map = new mapboxgl.Map({
    container: 'map', // id contenedor
    style: './styles/style.json', // ubicación del estilo
    center: [2, 42], // posición inicial [lng, lat]
    zoom: 7 // zoom inicial
});

// Agregar los controles de zoom y rotación al mapa.
map.addControl(new mapboxgl.NavigationControl());

</script>

</body>
</html>
```

* Abrir el navegador y escribir http://localhost:3000/visor_local.html en la barra de navegación. Abrir la consola del desarrollador (F12) y ver que aparecen una serie de errores que hacen que no se vea el mapa.

* El primer error que vemos hace referencia a que no existe la capa *aerodrome_label* en nuestro archivo de teselas vectoriales. En nuestro estilo buscamos la capa *aerodrome_label* y la borramos (líneas 4286 hasta 4323).

* Recargar la página y comprobar que el error que hacía referencia a la capa *aerodrome_label* ha desaparecido, pero seguimos teniendo errores.

* El siguiente error hace referencia a que no puede cargar los archivos con las fuentes para pintar las etiquetas del mapa. Si vamos a la línea 55 de nuestro archivo de estilos observamos que en la url de carga solicita una llave (**key**). Para obtener esta **key** hay que registrarse (tienen un plan gratuito) en [Tilehosting](https://www.tilehosting.com/). 

* Sustituir en la url del glyphs (línea 55) donde dice **{key}** por nuestra key. Para no tener que generar una key en este taller podremos usar *RiS4gsgZPZqeeMlIyxFo*. Ahora la url debe ser `https://free.tilehosting.com/fonts/{fontstack}/{range}.pbf?key=RiS4gsgZPZqeeMlIyxFo`. NOTA: para desplegar un mapa en producción o fuera del ámbito del taller se debe usar la key propia.

* Recargar la página y comprobar que desaparecen los errores y que se ve nuestro mapa.

### Agregar el control para inspección

El [Inspect Control](https://github.com/lukasmartinelli/mapbox-gl-inspect) permite ver todos los elementos de un VT y también permite pasar el cursor sobre los elementos para ver sus propiedades.

* Agregar la librería *mapbox-gl-inspect* en el archivo visor_simple.html para esto agregar los siguiente justo debajo de donde se carga el estilo mapbox-gl.css

```html
<script src='http://mapbox-gl-inspect.lukasmartinelli.ch/dist/mapbox-gl-inspect.min.js'></script>
<link href='http://mapbox-gl-inspect.lukasmartinelli.ch/dist/mapbox-gl-inspect.css' rel='stylesheet' />  
```

* Para agregar el control de inspección al mapa, Escribir lo siguente debajo de donde se agrega el *NavigationControl*

```js
// Agragar el control de inspección
map.addControl(new MapboxInspect());
``` 
* Recargar la página en el navegador y comprobar que aparece el Inspect control

| ![Resultado visor local](img/visor_local.png) |
| :--: |
| *Resultado visor local* |