# Servidor Web

Para desplegar las aplicaciones que desarrollaremos durante el taller tenemos que utilizar un servidor web ya sea un [Apache](https://httpd.apache.org/), [Nginx](https://nginx.org/), [Express](http://expressjs.com/es/), etc. En nuestro caso utilizaremos el Express.

## Instalación

Para instalar el Express es necesario tener instalado el [Node.js](https://nodejs.org/es/). Una vez instalado el Node.js crear un directorio llamado taller-vt-demo

Abrir un terminal y escribir:

1. `mkdir taller-vt-demo` para crear el directorio de trabajo.
2. `cd taller-vt-demo` para entrar en el directorio de trabajo.
3. `npm init` para crear un archivo **package.json** para la aplicación. Este comando solicita varios elementos como, por ejemplo el nombre de la aplicación, la versión, etc. Para aceptar los valores predeterminador presionar ENTER. 
4. `npm install express --save` para installar el Express en el directorio y guardarlo en la lista de dependencias.

## Ejemplo Hola Mundo

Crear una aplicación que inicia un servidor y escucha conexiones por el puerto 3000. Esta aplicación responde con "Hola Mundo!" para las solicitudes a la URL raíz (/).  

1. Crear un archivo llamado *server.js* y escribir lo siguiente en el archivo

```js
var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hola Mundo!');
});

app.listen(3000, function () {
  console.log('Servidor escuchando en el puerto 3000!');
});
```
2. Escribir en el terminal `node server.js` para arrancar el servidor

3. Abrir un navegador y escribir http://localhost:3000 y comprobar que la salida es Hola Mundo!

## Ejemplo Servir una página web estática

En el ejemplo anterior la respuesta del servidor era una cadena de texto. En este ejemplo modificaremos el servidor para que retorne archivos estáticos como html, css, imágenes, etc. 

1. Modificar el archivo *servidor.js* y escribir lo siguiente

```js
var express = require('express');
var app = express();

app.use(express.static('public'));

app.get('/', function(req, res){
    res.sendFile(__dirname + '/index.html');
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
```
2. Crear un directorio llamado **public** dentro de nuestro directorio de trabajo.

3. Dentro del directorio *public* crear un archivo llamado **index.html** y escribir lo siguiente dentro del archivo

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    Hola Mundo!!!
</body>
</html>
```

4. Detener el servidor, presionar Ctrl+c en el terminal donde se está ejecutando el servidor.

5. Arrancar de nuevo el servidor. Escribir en el terminal `node server.js`.

6. Abrir un navegador y escribir http://localhost:3000 y comprobar que la salida es Hola Mundo!!!


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