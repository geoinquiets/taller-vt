# Cómo visualizar teselas vectoriales

## Servidor web

Para ver las aplicaciones que desarrollaremos durante el taller necesitamos publicarlas mediante un servidor web.
En nuestro caso usaremos `live-server`, que permite servir los contenidos de un directorio y recargar la página
automáticamente cuando se modifica el contenido de algún fichero.

Para instalarlo, se usará el comando:

```bash
sudo npm install --global live-server
```

Para arrancarlo, basta con situarse en el directorio que queramos servir y ejecutar:

```bash
mkdir taller-vt
cd taller-vt
live-server
```

Se abrirá el navegador por defecto con la dirección [http://127.0.0.1:8080/](http://127.0.0.1:8080/)
y se mostrará el contenido del directorio para poder navegar por él.

Deja la ventana del terminal abierta, y usa la combinación de teclas `Ctrl` + `C` para parar el servidor.


## Hola Mundo

Vamos a crear un fichero `index.html`.

Abre una nueva ventana de terminal (recuerda dejar el servidor activo) y ejecuta Visual Studio Code
(o el editor que prefieras):

```bash
code .
```

Crea un fichero `index.html`:

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Mapa VT</title>
</head>
<body id="map">
    &#x1f596; &#x1f30d;
</body>
</html>
```

Recargar la página [http://127.0.0.1:8080/](http://127.0.0.1:8080/) en el navegador. Se debería ver un "Hola mundo".


## Hola Mapa

En este primer ejemplo crearemos un visor de mapas utilizando la librería de Mapbox GL JS.
Tanto los datos procedente de teselas vectoriales ó vector tiles (VT) como el estilo para
simbolizar los mismos se encuentran en la red.

Modificar el archivo `index.html` para que contenga el siguiente código:

```html hl_lines="8 9 10 11 12 13 14 15 18 19 20 21 22 23 24 25 26 27 28 29 30"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Mapa VT</title>
    <link rel='stylesheet' href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.44.1/mapbox-gl.css' />
    <script src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.44.1/mapbox-gl.js'></script>
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
        style: 'https://openmaptiles.github.io/osm-bright-gl-style/style-cdn.json', // Ubicación del estilo
        center: [2.175, 41.39], // Ubicación inicial
        zoom: 13, // Zoom inicial
        bearing: -45, // Ángulo de rotación inicial
        hash: true // Permite ir guardando la posición del mapa en la URL
    });
    
    // Agrega controles de navegación (zoom, rotación) al mapa:
    map.addControl(new mapboxgl.NavigationControl());
</script>
</body>
</html>
```

![Resultado visor simple](img/visor_simple.png)
Resultado visor simple

## Inspector de datos

El control [mapbox-gl-inspect](https://github.com/lukasmartinelli/mapbox-gl-inspect) permite ver todos los elementos
de un VT y también permite pasar el cursor sobre los elementos para ver sus propiedades.

Agregar el código de la librería, e instanciar el control tras crear el mapa:


```html hl_lines="10 11 33 34"
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
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
        style: 'https://openmaptiles.github.io/osm-bright-gl-style/style-cdn.json', // Ubicación del estilo
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

Se recargará la página en el navegador con un nuevo botón que permite la "visión de rayos X" sobre los datos.

![Resultado visor simple](img/visor_inspect.png)
Resultado visor simple
