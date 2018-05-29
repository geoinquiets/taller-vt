# Cómo crear teselas vectoriales

## Tippecanoe

Herramienta que permite crear tesalas vectoriales de colecciones grandes (o pequeñas) de elementos GeoJSON, Geobuf o CSV.

El objetivo de Tippecanoe es permitir una visión de sus datos independiente de la escala, de modo que en cualquier nivel desde el mundo entero hasta un solo edificio, podamos ver la densidad y la textura de los datos en lugar de una simplificación para eliminar características supuestamente sin importancia o agrupándolos o agregándolos.

Algunos ejemplos:

- Si le da todo OpenStreetMap y alejas la vista, le devolverá algo que se parece a "Todas las calles" en lugar de algo que parece un atlas de carretera interestatal.

- Si le das todas las huellas de edificios en Los Ángeles y alejas la vista lo suficiente como para que la mayoría de los edificios individuales ya no sean perceptibles, aún deberías poder ver la extensión y variedad del desarrollo en cada vecindario, no solo en los edificios más grandes del centro.


## Datos 

Descageremos algunos datos de [Natural Earth](http://www.naturalearthdata.com/) en nuestra carpeta de datos. En el apartado de descargas de Natural Earth hay varios conjuntos de datos (en formato Shapefile) según la escala. 

En el taller trabajaremos con un subconjunto de los datos de la escala 1:10m (1:10.000.000). Para ahorrarnos la transformación de Shapefile a GeoJSON utilizaremos los datos procedentes de [https://github.com/nvkelso/natural-earth-vector/](https://github.com/nvkelso/natural-earth-vector/tree/master/geojson)

Descagaremos las siguientes capas:

* Cultural
    * Admin 0 – Countries (247 países en el mundo. Groenlandia separada de Dinamarca)
    * Populated Places (Puntos de ciudades y pueblos)
    * Roads (Carreteras principales)
    * Railroads (Vías de Trenes)
    * Airports (Aeropuertos)
* Physical
    * Coastline (Línea de costa que incluyen islas principales)
    * Land (Polígonos terrestres que incluyen islas principales)
    * Ocean (Oceano)
    * Rivers + lake centerlines (Rios en única línea que incluyen líneas centrales de lagos)
    * Lakes + Reservoirs (Lagos naturales y artificiales)

Para descargar las capas escribiremos lo siguiente en nuestro terminal.

```bash
mkdir naturalearth
cd naturalearth
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_admin_0_countries.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_populated_places.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_roads.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_railroads.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_airports.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_coastline.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_land.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_ocean.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_rivers_lake_centerlines.geojson
wget https://raw.githubusercontent.com/nvkelso/natural-earth-vector/master/geojson/ne_10m_lakes.geojson
```

## Crear el mbtiles

Una vez descargados todos nuestros datos vamos a crear un mbtiles llamado *natural_earth.mbtiles* que contendrá nuestras 10 capas. 

Para crear el mbtiles utilizaremos las siguientes opciones del Tippecanoe ([Listado de opciones](https://github.com/mapbox/tippecanoe#options)):

* -o *nombre.mbtiles*: nombre del archivo de salida.
* -zg: Estima un maxzoom razonable basado en el espaciado de los elementos.
* --drop-densest-as-needed: Si una tesela es demasiado grande, intenta reducirla a menos de 500K aumentando el espacio mínimo entre los elementos.
* -L *nombre*:*archivo.json*: permite definir nombres de capa para cada archivo individual.  

Para generar el archivo mbtiles escribiremos lo siguiente en el terminal.

```
tippecanoe -o natural_earth.mbtiles -zg --drop-densest-as-needed \
  -L ocean:ne_10m_ocean.geojson \
  -L land:ne_10m_land.geojson \
  -L admin:ne_10m_admin_0_countries.geojson \
  -L coastline:ne_10m_coastline.geojson \
  -L lakes:ne_10m_lakes.geojson \
  -L rivers:ne_10m_rivers_lake_centerlines.geojson \
  -L rail:ne_10m_railroads.geojson \
  -L roads:ne_10m_roads.geojson \
  -L cities:ne_10m_populated_places.geojson \
  -L airports:ne_10m_airports.geojson
```

## Visualizar el mbtiles

Utilizaremos el TileServer para visualizar el mbtiles creado con el Tippecanoe. Para ello escribimos lo siguiente en el terminal:

```
mv natural_earth.mbtiles ../servidor/data
cd ../servidor
npx tileserver-gl-light data/natural_earth.mbtiles -p 8181
``` 

Abrir el navegador y escribir http://localhost:8181 y comprobar que aparece la página del TileServer con nuestro mbtiles

![TileServer GL Light](img/mbtiles_tippecanoe.png)
*TileServer GL Light*

Apretar el botón de **Inspect** y comprobar que en el mapa aparecen todas las capas agregadas al mbtiles

![Mbtiles Natural Earth](img/natural_earth_mbtiles.png)
*Mbtiles Natural Earth*
