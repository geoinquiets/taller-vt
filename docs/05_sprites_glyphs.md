# Iconos y tipografías

## Sprites (iconos)

!!! quote "Definición"
    Un **sprite** es una imagen individual que contiene todos los iconos incluidos en un estilo. Al combinar muchas
    imágenes pequeñas en una sola imagen (sprite), se puede reducir el número de solicitudes necesarias para recuperar
    todas las imágenes, mejorar el rendimiento y hacer que el mapa sea más rápido.

    Los Sprites pueden tener un tamaño máximo de 1024x1024 píxeles (o 2048x2048 para pantallas con alta DPI).
    Cada sprite viene acompañado de un archivo JSON donde se define el nombre de cada icono, y su posición y tamaño
    para saber cómo "recortarlo" de la imagen común.
    
    Más información en sobre sprites https://www.mapbox.com/help/define-sprite/


Cada uno de los iconos contenidos en un sprite se puede usar como textura para el fondo del mapa, patrón de relleno para
un polígono, patrón de dibujo para una línea, o una imagen de icono (símbolo puntual).

La propiedad `sprite` de un estilo apunta a una URL **incompleta**, a partir de la cual se pueden encontrar los diferentes
ficheros (sprites y json complementario).

Por ejemplo, si en el `style.json` se indica:

```json
{
    ...
    "sprite": "http://tileserver.fonts.cat/styles/dark-matter/sprite"
}
```

En realidad dicha URL no existe. Pero sí existen los siguientes recursos (añadiendo `.png`, `.json`, `@2x.png` y `@2x.json` respectivamente):

* http://tileserver.fonts.cat/styles/dark-matter/sprite.png Sprite a resolución convencional
* http://tileserver.fonts.cat/styles/dark-matter/sprite.json JSON que define cada icono dentro del sprite
* http://tileserver.fonts.cat/styles/dark-matter/sprite@2x.png Sprite a resolución doble (para pantallas Retina)
* http://tileserver.fonts.cat/styles/dark-matter/sprite@2x.json JSON que define cada icono dentro del sprite de resolución doble

Ejemplo de sprite:

![Sprite](img/sprite.png)


Uno de los elementos definidos en el JSON:

```json
{
    ...
    "airport_11": {
        "height": 17,
        "width": 17,
        "x": 17,
        "y": 0,
        "pixelRatio": 1
    },
    ....
}
```

### Caso práctico: Cómo crear sprites propios

Para generar los sprites a partir de imágenes individuales hay que crear los cuatro archivos. Esto se podría hacer
manualmente con un editor de texto, un editor de imágenes y mucha paciencia, pero afortunadamente existen herramientas
que lo automatizan. 

Los sprites convencionales para la web difieren de los de Mapbox, ya que utilizan una imagen compuesta `png` y un archivo
`css` con las reglas de simbolización para su aprovechamiento en páginas web. Mapbox GL, en cambio, necesita el fichero
`json`, no un CSS. 

Para generar los sprites y sus json a partir de una colección de imágenes en formato SVG, se recomienda el uso de la
librería de Mapbox [spritezero-cli](https://github.com/mapbox/spritezero-cli).

A partir de los iconos SVG contenidos en https://github.com/geomatico/taller-vt-jiide/tree/master/ejercicios/05

1. Instalar spritezero (necesita node y npm):

        npm install -g @mapbox/spritezero-cli

2. Ejecutar spritezero para generar los iconos a resolución estándar y a alta resolución:

        spritezero sprite icons
        spritezero --retina sprite@2x icons

Una vez generados, los publicamos en la red para poder acceder a ellos desde nuestros estilos.


## Glyphs (tipografías)

En la propiedad `glyphs` de un estilo se indica una plantilla de URL para cargar tipografías codificadas en PBF (el formato es
distinto que MVT, ya que el [`.proto`](https://github.com/mapbox/glyph-pbf-composite/blob/master/proto/glyphs.proto)
utilizado es distinto), que se usarán para dibujar textos en el mapa. Por ejemplo:

```json
{
    ...
    "glyphs": "http://tileserver.fonts.cat/fonts/{fontstack}/{range}.pbf"
}
```

Esta plantilla de URL debe incluir dos tokens:

* `{fontstack}` es el nombre de la tipografía. Por ejemplo `Open Sans Bold`.
* `{range}` es un rango de 256 puntos de código Unicode (es decir, un subconjunto de letras o símbolos). En función del texto a mostrar, el visor solicitará los rangos necesarios. El primero es `0-255`.

Una petición real tendría la forma:

* http://tileserver.fonts.cat/fonts/Open%20Sans%20Bold/0-255.pbf

Un glyph contiene una derivada de la tipografía binaria llamada [*signed distance field*](https://www.youtube.com/watch?v=d8cfgcJR9Tk)
que permite escalarla sin el pixelado. Una composición de varios glyphs daría una imagen con este aspecto:

![Signed Distance Field Glyph](img/signed_distance_field.png)


### Caso práctico: Cómo crear glyphs propios

1. Descargar el proyecto de github `openmaptiles/fonts`:

    ```bash
    wget https://github.com/openmaptiles/fonts/archive/master.zip
    unzip master.zip
    cd fonts-master
    npm install
    node generate.js
    ```

Al cabo de un rato, podemos ver los resultados en el directorio `_output`.

Si no queremos generar una tipografía determinada, basta con borrar el directorio que la contiene.
Del mismo modo podemos añadir tipografías añadiendo nuevos directorios y copiando dentro las tipografías en
formato TTF.

El directorio `_output` no se borra entre ejecuciones, con lo que habremos conservado todas las fuentes anteriores,
además de la recién generada "Comic Sans".

Finalmente, debemos publicar el contenido de `_output` en un servidor web, para que los visores de mapbox puedan acceder a él.
