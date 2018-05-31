# Sprites y Glyphs

## Sprites

!!! quote "Definición"
    Un **sprite** es una imagen individual que contiene todos los iconos incluidos en un estilo. Los Sprites se utilizan a menudo en el desarrollo web e incluso en videojuegos para mejorar el rendimiento. Al combinar muchas imágenes pequeñas en una sola imagen (sprite), puede reducir el número de solicitudes necesarias para recuperar todas las imágenes, mejorar el rendimiento y hacer que su mapa sea más rápido.

    Los Sprites pueden tener un tamaño máximo de 1024x1024 píxeles (2048x2048 para pantallas con alta DPI), lo que significa que el sprite completo que contiene todos los iconos debe tener un tamaño inferior a 1024x1024 píxeles. Cada sprite tiene un archivo JSON complementario que define cada icono, incluido el tamaño y la posición del icono dentro del sprite, como indicaciones para cada icono

    Más información en https://www.mapbox.com/help/define-sprite/

La propiedad de **sprite** de un estilo proporciona una URL para cargar imágenes pequeñas para usar en la representación de las propiedades de estilo de fondo, patrón de relleno, patrón de línea e imagen de icono.

Una fuente de sprites válida debe suministrar dos tipos de archivos:

* *Indice* es un fichero JSON que contiene una descripción de cada imagen contenida en el sprite. El contenido de este archivo debe ser un objeto JSON cuyas claves forman identificadores para usar como valores de las propiedades de estilo anteriores, y cuyos valores son objetos que describen las dimensiones (ancho y propiedades de altura) y la proporción de píxeles (pixelRatio) de la imagen y su ubicación dentro del sprite (x e y). Por ejemplo:

``` js
{"aerialway-15":{"width":15,"height":15,"x":0,"y":0,"pixelRatio":1},
"airfield-15":{"width":15,"height":15,"x":15,"y":0,"pixelRatio":1}}
```

* *Imagen* fichero PNG que contiene los datos del sprite. Por ejemplo:

![Sprite](img/sprite.png)

### Cómo crear tus propios sprites

Para crear los sprites hay que crear ambos archivo el JSON de indice y el PNG que contiene todas las imágenes, esto de se puede hacer manualmente con un editor de texto y en editor de imágenes, pero el proceso es lento y laborioso. 

Lo mejor es buscar algún generador de sprites, en la web se pueden encontrar múltiples generadores de sprites para usar en la web que generar el archivo PNG y un archivo CSS que cumple la función del archivo de indice. Para los mapas con mapbox gl el archivo css no sirve ya que necesitamos el archivo JSON.

Para generar sprites basados en ficheros SVG podemos utilizar https://github.com/gencat/ICGC-createsprites un script de Nodejs basado en la librería de Mapbox [spritezero](https://github.com/mapbox/spritezero) que permite generar sprites en @2x y de mayor resolución para usar en pantallas retina, etc.

## Glyphs

La propiedad de **glyphs** de un estilo proporciona una plantilla de URL para cargar conjuntos de glifos en formato PBF. Sirve para cargar las diferentes fuentes que se utilizar en el mapa. Ejemplo

``` 
https://free.tilehosting.com/fonts/{fontstack}/{range}.pbf
```

Esta plantilla de URL debe incluir dos tokens:

* *{fontstack}* Cuando se solicitan glifos, este token se reemplaza con una lista de fuentes separadas por comas de una pila de fuentes especificada en la propiedad de fuente de texto de una capa de símbolo.

* *{rango}* Cuando se solicitan glifos, este token se reemplaza con un rango de 256 puntos de código Unicode. Los rangos reales que se cargan se determinan en tiempo de ejecución según el texto que se debe mostrar.

### Cómo crear tus propios glyphs

Descargar el proyecto de github `openmaptiles/fonts`

```bash
wget https://github.com/openmaptiles/fonts/archive/master.zip
unzip master.zip
cd fonts-master
npm install
node generate.js
```

Al cabo de un rato, podemos ver los resultados en el directorio `_output`.

Si no queremos generar una tipografía determinada, basta con borrar el directorio que la contiene.
Del mismo modo podemos añadir tipografías añadiendo directorios. Por ejemplo, para generar "Comic Sans": 


```bash
rm -rf metropolis noto-sans open-sans pt-sans roboto
cp -r ../datos/comic-sans-ms .
node generate.js
```

El directorio `_output` no se borra entre ejecuciones, con lo que habremos conservado todas las fuentes anteriores,
además de la recién generada "Comic Sans".

Finalmente, copiaremos el contenido de `_output` al directorio `tileserver/fonts`:

```bash
cp -r _output/* ../tileserver/fonts
```

Habrá que reiniciar el tileserver para que cargue las nuevas tipografías.


### Cómo utilizar los sprites y glyphs en el estilo

En el fichero de estilo indicar la URL tanto de los sprites como de los glyphs.

``` js linenums="25"
"sprite": "https://openmaptiles.github.io/osm-bright-gl-style/sprite",
"glyphs": "https://free.tilehosting.com/fonts/{fontstack}/{range}.pbf?key=RiS4gsgZPZqeeMlIyxFo",
```

     
Para descargar los archivos de sprites escribiremos lo siguiente en nuestro terminal

``` bash
mkdir sprites
cd sprites
wget https://raw.githubusercontent.com/gencat/ICGC-createsprites/master/output/sprite%401.json
wget https://raw.githubusercontent.com/gencat/ICGC-createsprites/master/output/sprite%401.png
wget https://raw.githubusercontent.com/gencat/ICGC-createsprites/master/output/sprite%402.json
wget https://raw.githubusercontent.com/gencat/ICGC-createsprites/master/output/sprite%402.png
wget https://raw.githubusercontent.com/gencat/ICGC-createsprites/master/output/sprite%404.json
wget https://raw.githubusercontent.com/gencat/ICGC-createsprites/master/output/sprite%404.png
```

Ir a la carpeta de data 

```bash
cd ..
```

Modificar el fichero **config.json** del tileserver-gl para agregar la ruta donde se encuentran los sprites

``` js hl_lines="2 3 4 5 6"
{
  "options":{
    "paths":{
      "sprites": "sprites"
    }
  },
  "styles": {
    "natural-earth": {
      "style": "natural_earth.json",
      "tilejson": {
        "type": "overlay"
      }
    },
    "natural-earth-2": {
      "style": "natural_earth_2.json",
      "tilejson": {
        "type": "overlay"
      }
    }
  },
  "data": {
    "natural_earth": {
      "mbtiles": "natural_earth.mbtiles"
    }
  }
}
```

Modificar el fichero **natural_earth_2.json** para cargar los sprites propios. En este caso cargaremos los sprites con resolución para retina.

``` js hl_lines="8" linenums="18"
.....
"sources": {
    "local": {
      "type": "vector",
      "url": "http://localhost:8181/data/natural_earth.json"
    }
  },
  "sprite": "sprite@2",
  "glyphs": "https://free.tilehosting.com/fonts/{fontstack}/{range}.pbf?key=RiS4gsgZPZqeeMlIyxFo",
  "layers": [
    {
 .....
```

Reiniciar el tileserver-gl Ctrl+c

``` bash
tileserver-gl-light config.json -p 8181
```
