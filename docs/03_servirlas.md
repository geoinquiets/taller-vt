# Servicio básico de teselas vectoriales

Un servicio de teselas *a la google* o de tipo "XYZ" consiste en una URL donde se sustituyen los valores de zoom, fila y
columna siguiendo una plantilla, como en:

http://tileserver.fonts.cat/data/buildingpart/{z}/{x}/{y}.pbf

Se supone una proyección determinada, `EPSG:3857`, y un esquema de teselado determinado. Nada se sabe sobre el rango
de zooms o el ámbito geográfico de los datos (BBXOX), su atribución, o su contenido. Por ello mapbox ideó un fichero
de metadatos para publicar esta información de forma estándar: la especificación *TileJSON*.


## Especificación *TileJSON*

Este fichero de "metadatos" vendría a ser algo entre un GetCapabilities de mínimos, y un DescribeFeatureType:

```json
{
  "tilejson": "2.0.0"
  "name": "Catastro Building Parts",
  "tiles":["http://tileserver.fonts.cat/data/buildingpart/{z}/{x}/{y}.pbf"],
  "minzoom": 14,
  "maxzoom": 16,
  "bounds": [2.038039, 41.278439, 2.268328, 41.573783],
  "type": "overlay",
  "attribution": "Catastro",
  "vector_layers": [
    {
      "id": "buildingpart",
      "minzoom": 14,
      "maxzoom": 16,
      "fields": {
        "floors": "Number",
        "id": "String",
        "parcel": "String"
      }
    }
  ]
}
```


## Caso práctico: Explorando una instancia de Tileserver GL

[TileServer GL](http://tileserver.org/) es un servidor de mapas de código abierto creado para teselas vectoriales, y
capaz de renderizar en teselas raster con MapBox GL Native engine en el lado del servidor.

Proporciona mapas para aplicaciones web y móviles. Es compatibles con Mapbox GL JS, Android SDK, iOS SDK, Leaflet,
OpenLayers, HighDPI/Retina, SIG a través de WMTS, etc.

Si se quiere servir teselas raster lo mejor es utilizar la versión de Docker ya que son necesarias algunas librerías
nativas que pueden variar dependiendo de la plataforma, estas librerías sirven para renderizar las teselas vectoriales
en teselas raster. Si únicamente se quiere servir teselas vectoriales se puede utilizar el TileServer GL Light,
que no tiene ninguna dependencia nativa ya que está desarrollado en javascript.


1. Abrir http://tileserver.fonts.cat en un navegador

2. Explorar la sección "DATA":

    * Documento `TileJSON`
    * Inspector

3. Explorar la sección "STYLES":

    * Documento `TileJSON`. No siempre. Diferencias con el anterior.
    * Viewers: Vector y Raster. Similitudes y diferencias.
    * Servicio WMTS. Sólo para imagen.
    * Estructura de un documento GL Style:
        * Sprites  
        * Glyphs (y el endpoint oculto: http://tileserver.fonts.cat/fonts.json)
        * Sources
        * Layers
