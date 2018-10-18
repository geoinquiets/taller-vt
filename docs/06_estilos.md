# Una breve introducción de Mapbox Style Specification

La especificación de estilos de Mapbox es la piedra angular de la visualización de nuestras teselas vectoriales. Las teselas vectoriales viajan hasta el cliente y este es el encargado de aplicar la definición de estilos que hayamos preparado. 

Los estilos se definen mediante JSON y deberán estar accesibles en una URL desde nuestro cliente. Ya que los estilos son aplicados por el cliente, podríamos cambiar estos sobre nuestros datos de manera dinámica sin necesidad de interactuar con el servidor, y a ¡60fps!, obtneniendo visualizaciones muy dinámicas.

La [especifiación de Mapbox](https://www.mapbox.com/mapbox-gl-js/style-spec) es extensa pero detallaremos algunas de las características principales.

## Root

En la raiz del estilo definiremos varias de las propiedades globales del mismo, como son la *version* de la especifiación que estamos usando y el *name* o nombre que le asignamos al estilo.

```json
{
    "version": 8,
    "name": "Menorca Online"
}
```

Algunas otras propiedades serán las que indicarán la posición inicial del mapa como el "center", "zoom", "bearing" que será el ángulo con el que el mapa aparecerá o el "pitch" que será la inclinación de la cámara.

```json hl_lines="4 5 6 7 8 9 10"
{
    "version": 8,
    "name": "Menorca Online",
	"center": [
            4.264113,
            39.892787
        ],
    "zoom": 12.5,
    "bearing": 0,
    "pitch": 30,
}
```

Sprite y glyphs irian indicadas en esta sección también

```json hl_lines="4 5"
{
    "version": 8,
    "name": "Menorca Online",
    "sprite": "mapbox://sprites/mapbox/streets-v8",
    "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
	"center": [
            4.264113,
            39.892787
        ],
    "zoom": 12.5,
    "bearing": 0,
    "pitch": 30,
}
```

También tendríamos una parte de ["metadata"](https://www.mapbox.com/mapbox-gl-js/style-spec/#root-metadata) donde podremos definir metadatos del estilo.

## Sources
En "sources" definiremos las fuentes de datos que queremos simbolizar. Tenemos diferentes tipos de fuentes que podemos usar dentro de Mapbox *"vector"*, *"raster"*, *"raster-dem"*, *"geojson"*, *"image"*, *"video"*.

### "vector"
Podremos definir un fuente de tipo *"vector"* se definirá de las sigiuentes formas, utilizando la URL de las tiles directamente en el servidor o la URL del TileJSON

```json hl_lines="13 14 15 16 17 18 19"
{
    "version": 8,
    "name": "Menorca Online",
    "sprite": "mapbox://sprites/mapbox/streets-v8",
    "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
	"center": [
            4.264113,
            39.892787
        ],
    "zoom": 12.5,
    "bearing": 0,
    "pitch": 30,
    "sources": {
        "menorca-base": {
            "type": "vector",
            "url": "https://tileserver.fonts.cat/data/menorca_base.json",
            "maxzoom": 14
        }
    }
}
```

### "raster"
En el caso de un WMS deberemos incluir la URL del servicio que soporte EPSG:3857 con una plantilla `"{bbox-epsg-3857}"`

```json hl_lines="13 14 15 16 17 18 19 20 21"
{
    "version": 8,
    "name": "Menorca Online",
    "sprite": "mapbox://sprites/mapbox/streets-v8",
    "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
	"center": [
            4.264113,
            39.892787
        ],
    "zoom": 12.5,
    "bearing": 0,
    "pitch": 30,
    "sources": {
      "wms-source": {
        "type": "raster",
        "tiles": [
          "http://www.ign.es/wms-inspire/pnoa-ma?bbox={bbox-epsg-3857}&format=image/jpeg&service=WMS&version=1.1.1&request=GetMap&srs=EPSG:3857&width=256&height=256&layers=OI.OrthoimageCoverage"
        ],
        "tileSize": 256
      }
    }
}
```

## Layers

Cada *"source"* dispondrá de una o múltiples capas que podremos referenciar desde esta sección del JSON y que serán el punto donde definiremos mediante dos grupos de propiedades, "paint" y "layout" el estilo de nuestros datos. Existen también múltiples tipos de capas *"background"*, *"fill"*, *"line"*, *"symbol"*, *"raster"*, *"circle"*, *"fill-extrusion"*, *"heatmap"*, *"hillshade"* y cada una de ellas tendrá unas características diferentes

```json hl_lines="24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47"
{
    "version": 8,
    "name": "Menorca Online",
    "sprite": "mapbox://sprites/mapbox/streets-v8",
    "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
	"center": [
            4.264113,
            39.892787
        ],
    "zoom": 12.5,
    "bearing": 0,
    "pitch": 30,
    "sources": {
        "menorca-base": {
            "type": "vector",
            "url": "https://tileserver.fonts.cat/data/menorca_base.json",
            "maxzoom": 14
        },
        "buildingpart": {
            "type": "vector",
            "url": "https://tileserver.fonts.cat/data/menorca_buildings.json"
        }
    },
    "layers": [
            {
            "id": "background",
            "type": "background",
            "paint": {
                "background-color": "#f8f4f0"
            }
        },
        {
            "id": "building-3d",
            "type": "fill-extrusion",
            "source": "buildingpart",
            "source-layer": "buildingpart",
            "paint": {
                "fill-extrusion-color": "#d9c7a5",
                "fill-extrusion-height": {
                    "type": "identity",
                    "property": "floors"
                },
                "fill-extrusion-base": 0,
                "fill-extrusion-opacity": 0.6
            }
        }
    ]
}
```

## Expresions

Con las expresiones podemos definir formulas que modifican el valor de las propiedades usando los operadores que diponemos en Mapbox.

```json hl_lines="32"
{
    "version": 8,
    "name": "Menorca Online",
    "sprite": "mapbox://sprites/mapbox/streets-v8",
    "glyphs": "mapbox://fonts/mapbox/{fontstack}/{range}.pbf",
	"center": [
            4.264113,
            39.892787
        ],
    "zoom": 12.5,
    "bearing": 0,
    "pitch": 30,
    "sources": {
        "menorca-base": {
            "type": "vector",
            "url": "https://tileserver.fonts.cat/data/menorca_base.json",
            "maxzoom": 14
        },
        "buildingpart": {
            "type": "vector",
            "url": "https://tileserver.fonts.cat/data/menorca_buildings.json"
        }
    },
    "layers": [
        {
            "id": "building-3d",
            "type": "fill-extrusion",
            "source": "buildingpart",
            "source-layer": "buildingpart",
            "paint": {
                "fill-extrusion-color": "#d9c7a5",
                "fill-extrusion-height": ["*", 3, ["get", "floors"]],
                "fill-extrusion-base": 0,
                "fill-extrusion-opacity": 0.6
            }
        }
    ]
}
```

`[Caso práctico: maputnik]`
