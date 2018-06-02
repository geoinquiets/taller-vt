# Cómo simbolizar teselas vectoriales


## Maputnik

Es un editor visual gratuito y abierto para estilos Mapbox GL dirigidos tanto a desarrolladores
como a diseñadores de mapas.

Se puede utilizar en línea en [*Maputnik editor*](https://maputnik.github.io/editor/) o se puede
hacer una instalación local.


### Instalación

Se puede descargar la última versión de la [*página de releases*](https://github.com/maputnik/editor/releases).
En nuestro caso, la tenemos ya descargada en `~/Desktop/taller-vt/maputnik`.

Para arrancar la versión local:

```bash
cd ~/Desktop/taller-vt/maputnik
live-server --port=8082
```

Abrir Maputnik en http://localhost:8082

![Maputnik](img/maputnik.png)


### Comenzar un estilo nuevo 

En la barra de menú seleccionamos la opción **Open**.
Del apartado **Gallery Styles**, seleccionamos **Empty Style**.


### Agregar un origen de datos (Source)

En la barra de menú seleccionamos la opción **Source**.
En la parte inferior del diálogo está la sección: **Add New Source**.

![Maputnik Add Source](img/maputnik_add_source.png)

* Como `Source ID` ponemos `naturalearth`.
* Como `Source Type` seleccionamos `Vector (TileJSON URL)`.
* Como `TileJSON URL` seleccionamos `http://localhost:8081/data/natural_earth.json`

También se podría usar como `Source Type` un `Vector (XYZ URL)`, en cuyo caso también hay que
indicar el rango de zooms en que los datos son válidos.


### Agregar sprite y glyphs

En la barra de menú seleccionamos **Style Settings**:

![Maputnik Style Settings](img/maputnik_style_settings.png)

* `Name`: Nombre del estilo. En nuestro caso pondremos `Natural Earth`.
* `Sprite URL`: Usaremos el sprite de uno de los estilos que tenemos publicados en tileserver `http://localhost:8081/styles/osm-bright/sprite`
* `Glyphs URL`: Accederemos a las tipografías publicadas en nuestro Tileserver `http://localhost:8081/fonts/{fontstack}/{range}.pbf`


### Simbolización básica

Presionamos el botón de **Add Layer**: 

![Maputnik Add Layer](img/maputnik_add_layer.png)

#### Fondo

Añadimos una primera capa de fondo:

* `ID`: identificador único de la capa. Pondremos `fondo`.
* `Type`: tipo de capa. Seleccionar la opción de `Background`.

Seleccionamos el color en **Paint properties** => **Color**: "#50A8E7".

El fondo del mapa pasa a un gris claro.

#### Océanos

Añadimos ahora los océanos: 

* `ID`: identificador único de la capa. Pondremos `oceanos`.
* `Type`: tipo de capa. Seleccionar la opción de `Fill` ya que la capa es de tipo polígono.
* `Source`: identificador del origen de datos. En nuestro caso pondremos `naturalearth`.
* `Source Layer`: identificador de la capa dentro del origen de datos. Pondremos `ocean`.

Aparecerán los océanos de color negro.

Simbolizamos la capa seleccionando un color RGB en **Paint properties** => **Color**: "#50A8E7".

En el apartado inferior del panel de propiedades de la capa, vamos viendo la definición tal
como se guardará en el fichero json de estilo:

```json
{
  "id": "oceanos",
  "type": "fill",
  "source": "naturalearth",
  "source-layer": "ocean",
  "paint": {
    "fill-color": "#50A8E7"
  }
}
``` 

Maputnik no es más que un asistente gráfico para generar el fichero `style.json`. 

#### Resto de capas básicas

El resto de capas se puede simbolizar procediendo de la misma manera: 

| id | type | source-layer | color | otras propiedades "paint" |
|----|------|--------------|-------|-------------------|
| fondo | Background | -- | #F8F4F0 | -- |
| oceanos | Fill | ocean | #A0C8F0 | -- |
| tierra | Fill | land | #E6C7C7 | -- |
| costa | Line | coastline | #4793E8 | -- |
| rios | Line | rivers | #4793E8 | -- |
| lagos | Fill | lakes | #A0C8F0 | "stroke-color": "#4793E8" |
| ferrocarril | Line | rail | #707070 | -- | 
| carreteras | Line | roads | #BF5757 | -- |

![Maputnik Add Filter](img/maputnik_mapa_base.png)

### Filtrar los datos a mostrar en una capa

Vamos a eliminar las rutas de ferry que se muestran como carreteras.

Hay dos maneras de definir un filtro en un estilo MapboxGL:
1. **Filters**: La forma clásica, que implementa Maputnik: https://www.mapbox.com/mapbox-gl-js/style-spec/#other-filter
2. **Decision Expressions**: La nueva forma, más potente, pero que Maputnik no implementa: https://www.mapbox.com/mapbox-gl-js/style-spec/#expressions-decision

En Maputnik, seleccionando la capa `carreteras`, apartado **Filter**: Presionamos el botón **Add filter**.
La condición será:

        featurecla == Road

![Maputnik Add Filter](img/maputnik_add_filter.png)

Comprobar que desaparecen las líneas de Ferry en el mapa.

!!! tip
    Usa el **Inspect Mode** integrado en Maputnik para explorar los diferentes campos de una capa y sus posibles valores.

#### Ejercicio extra

Crea una nueva capa "ferrys" y aplica el filtro contrario para mostrar sólo las rutas de ferry.
Investiga la propiedad `Dasharray` para darle un aspecto de línea discontinua a las rutas.

![Maputnik Ferries](img/maputnik_ferries.png)


### Etiquetar una capa

1. Agregar la capa de ciudades. Presionar el botón de **Add Layer** y rellenar el formulario con
la siguiente información:

    * `ID`: `ciudades`
    * `Type`: `Symbol`, utilizado para mostrar entidades puntuales (iconos y etiquetas)
    * `Source`: `naturalearth`
    * `Source Layer`: `cities`

2. En el apartado **Text layout properties**:

    * En la propiedad `Field` escribir `{NAME}` (el nombre del campo a mostrar, entre llaves).
    * En la propiedad `Font`, escribir `Comic Sans`, tipografía que hemos generado y publicado en el apartado anterior (nota: el taller sobre cómo evitar hacer mapas feos es esta tarde).

3. Estilizar las etiquetas. En el apartado de **Text paint properties**:
 Para los textos podemos definir un Halo para que el teto destaque mejor en nuestro mapa.


### Utilizar un icono para simbolizar nuestra capa

1. Agregar la capa de aeropuertos. Presionar el botón de **Add Layer** y rellenar el formulario con
la siguiente información:

    * `ID`: `aeropuertos`
    * `Type`: `Symbol`, utilizado para mostrar entidades puntuales (iconos y etiquetas)
    * `Source`: `naturalearth`
    * `Source Layer`: `airports`

2. En el apartado de **Icon layout properties**:

    * En la propiedad `Image`, escribir `airport_11`. Este nombre debe coincidir con alguna imagen definida en el sprite.

3. Comprobar que aparecen los aeropuertos en el mapa.

!!! tip
    Estos son los iconos del sprite del estilo (`osm-bright`) que estamos utilizando:
    https://github.com/openmaptiles/osm-bright-gl-style/tree/master/icons


### Exportar el estilo creado

Seleccionar la opción **Export**, y luego el boton de **Download** para descargar el estilo en nuestro ordenador.
Descargamos el archivo, lo renombramos a `style.json` y lo movemos a la carpeta `tileserver/styles/natural-earth/`,
donde ya habíamos copiado los sprites generados en el apartado anterior.

Habrá que editar el fichero de configuración de tileserver `tileserver/config.json` para añadir el estilo: 


```json
{
  "styles": {
    "natural-earth": {
      "style": "natural-earth/style.json"
    }
  }
}
```

Reiniciar tileserver y comprobar que ofrece el nuevo estilo de visualización.


### Crear un visor para el nuevo estilo

Vamos a crear un visor para nuestro nuevo estilo:

* Copiar el archivo `visor/barcelona.html` en `visor/naturalearth.html`
* Además, hacer una copia de `tileserver/styles/natural-earth/style.json` en `visor/natural-earth-style.json`.

Por último, editaremos `visor/naturalearth.html` y en la parte de `<script>` dejaremos este código:

```javascript
var map = new mapboxgl.Map({
    container: 'map',
     // style: 'http://localhost:8081/styles/natural-earth/style.json',
    style: 'natural-earth-style.json',
    center: [1.5, 41],
    zoom: 5,
    hash: true
});

map.addControl(new mapboxgl.NavigationControl());
map.addControl(new MapboxInspect());
```  

Abriendo en el navegador http://127.0.0.1:8080/naturalearth.html debería verse:

![Natural Earth Viewer](img/natural_earth_viewer.png)


## Estilo basado en datos (data-driven style)

El estilo basado en datos le permite estilizar los datos en función de sus propiedades.
Por ejemplo, cambiar el radio de un círculo en función de la cantidad de clientes,
cambiar el color de un polígono de estado según la población o usar la lógica condicional
para crear etiquetas bilingües.

Para crear estilos basados en datos debemos usar las Mapbox GL JS expressions. En la
especificación de estilo de Mapbox, el valor de cualquier propiedad de diseño, 
de estilo o filtro se puede especificar como una expresión. Las expresiones 
cómo se combinan uno o más valores de propiedad y / o el nivel de zoom actual utilizando
operaciones lógicas, matemáticas, de cadena o de color para producir el valor de
propiedad de estilo apropiado o la decisión de filtro.

Para más información y ejemplos
https://www.mapbox.com/help/how-map-design-works/#data-driven-styles


### Crear un estilo basado en datos

Copiar el estilo **natural_earth.json** en un fichero llamado *natural_earth_2.json*


#### Estilo basado en valores concretos de una propiedad

Editar el fichero *natural_earth_2.json* y eliminar las capas con id **secundarias**,
**principales** y **ferrys**

Entre la capa con id *land* y la capa con id *aeropuertos* crear una capa con id **roads**.
El color de las líneas de esta capa varia dependiendo del valor de la propiedad *type*.

```json
{
    "id": "roads",
    "type": "line",
    "source": "local",
    "source-layer": "roads",
    "layout": {
        "visibility": "visible"
    },
    "paint": {
        "line-color": [
            "match",
            [
                "get",
                "type"
            ],
            "Secondary Highway",
            "rgba(206, 32, 79, 1)",
            "Ferry Route",
            "rgba(138, 154, 241, 1)",
            "Major Highway",
            "rgba(20, 52, 232, 1)",
            "#000000"
        ],
        "line-width": 2
    }
}
```

#### Estilo basado en el nivel del zoom

Editar el fichero *natural_earth_2.json* modificar la capa **ciudades_etiquetas** para
cambiar el tamaño del texto basado en el nivel de zoom del mapa y en la propiedad
*SCALERANK*

```json
{
    "id": "ciudades_etiquetas",
    "type": "symbol",
    "source": "local",
    "source-layer": "cities",
    "layout": {
    "symbol-placement": "point",
    "text-field": "{NAME}",
    "visibility": "visible",
    "text-anchor": "bottom",
    "text-offset": [0, -1],
    "text-size": [
        "step",
        ["zoom"],
        [
        "case",
        [
            "<",
            [
            "number",
            ["get", "SCALERANK"]
            ],
            3
        ],
        18,
        0
        ],
        5,
        [
        "case",
        [
            "<=",
            [
            "number",
            ["get", "SCALERANK"]
            ],
            2
        ],
        20,
        [
            "<=",
            [
            "number",
            ["get", "SCALERANK"]
            ],
            5
        ],
        14,
        10
        ],
        8,
        [
        "case",
        [
            "<=",
            [
            "number",
            ["get", "SCALERANK"]
            ],
            2
        ],
        24,
        [
            "<=",
            [
            "number",
            ["get", "SCALERANK"]
            ],
            5
        ],
        18,
        14
        ]
    ]
    },
    "paint": {
    "text-halo-color": "rgba(253, 253, 253, 1)",
    "text-halo-width": 5,
    "text-color": "rgba(16, 16, 16, 1)",
    "text-halo-blur": 2
    }
}

```

#### Estilo basado en una propiedad

Crear una capa con id **ciudades** y de tipo *circle* entre las capas *aeropuertos* y
la capa *ciudades_etiquetas*. En esta nueva capa el tamaño del circulo utilizará
directamente el valor de la propiedad *SCALERANK*

```json
{
    "id": "ciudades",
    "type": "circle",
    "source": "local",
    "source-layer": "cities",
    "layout": {
    "visibility": "visible"
    },
    "paint": {
    "circle-color": [
        "match",
        ["get", "ADM0CAP"],
        0,
        "hsl(285, 75%, 68%)",
        "hsl(0, 96%, 48%)"
    ],
    "circle-radius": ["-", 15, ["get","SCALERANK"]]
    }
}
```

Agregar el nuevo estilo al fichero de configuración *config.json* del tileserver-gl

```js hl_lines="9 10 11 12 13 14"
{
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

Parar *Ctrl+c* y arrancar el tileserver utilizando el archivo de configuración creado

```bash
tileserver-gl-light -c config.test.json -p 8181
```

Modificar el archivo *index.html* para que el visor de mapa para cargue los datos de
Natural Earth con el nuevo estilo creado

```html hl_lines="22"
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
        style: 'http://localhost:8181/styles/natural-earth-2/style.json', // Ubicación del estilo
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


### Ejercicio extra: uso de una fuente con iconos para simbolizar un punto

Si se ha hecho el ejercicio extra del apartado anterior, en el que creábamos una fuente
a partir de una colección de iconos, ahora veremos cómo utilizarla en el Layer de
aeropuertos:


```json hl_lines="8 9 10 11"
{
  "id": "aeropuertos",
  "type": "symbol",
  "source": "naturalearth",
  "source-layer": "airports",
  "layout": {
    "symbol-placement": "point",
    "icon-image": "",
    "text-font": ["Geostart Regular"],
    "text-size": 25,
    "text-field": ","
  },
  "paint": {
    "text-color": "#fabada",
    "text-halo-color": "#888",
    "text-halo-width": 2
  }
}
```

En las líneas destacadas se observa cómo no se usa una `icon-image`, sino una etiqueta de texto (`text-font`, `text-size`
y `text-field`). En `text-field` se indica una coma `","`, que corresponde al icono que queremos mostrar.
Al tratarse de una fuente, podemos indicar el tamaño que queramos sin miedo a obtener una imagen pixelada,
y aplicar otras propiedades como escoger color, halo, etc.

Como resultado del estilo indicado se simbolizarían los aeropuertos así:

![Aeropuerto](img/aeropuerto_icon.png)
