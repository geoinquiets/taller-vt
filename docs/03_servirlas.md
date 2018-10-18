# Servicio básico de teselas vectoriales


# Especificación *TileJSON*
Metadatos: Capas y atributos. También nombre, atribución, minZoom, maxZoom.

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

Especificación TileJSON, servicio XYZ.

`[Caso práctico: tilserver-gl]`