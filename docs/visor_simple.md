# Visor simple 

En este primer ejemplo crearemos un visor de mapas utilizando la librería de Mapbox GL JS. Tanto los datos procedente de teselas vectoriales ó vector tiles (VT) como el estilo para simbolizar los mismo se encuentran en la red.

* Dentro de la carpeta public crear un archivo llamado visor_simple.html y copiar el siguiente código

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
    style: 'https://openmaptiles.github.io/osm-bright-gl-style/style-cdn.json', // ubicación del estilo
    center: [2, 42], // posición inicial [lng, lat]
    zoom: 7 // zoom inicial
});

// Agregar los controles de zoom y rotación al mapa.
map.addControl(new mapboxgl.NavigationControl());

</script>

</body>
</html>
```

* Abrir el navegador y escribir http://localhost:3000/visor_simple.html en la barra de navegación.

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

| ![Resultado visor simple](img/visor_simple.png) |
| :--: |
| *Resultado visor simple* |