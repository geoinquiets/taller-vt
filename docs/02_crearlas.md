# Creación y almacenaje de teselas vectoriales

# Especificación *`.mbtiles`*

Pirámide de teselas guardada en una BDD SQLite con un esquema determinado:

* `tiles`
    * `zoom_level` (z)
    * `tile_column` (x)
    * `tile_row` (y)
    * `tile_data` (blob!)

* `metadata`
    * `format` ('*pbf*')
    * `attribution`
    * `minZoom` / `maxZoom`
    * `BBOX`
    * `json`


Especificación mvt, formato pbf, fichero mbtiles.

`[Caso práctico: tippecanoe]`