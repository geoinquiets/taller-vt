# Cómo servir datos dinámicos

## Partimos de una capa de edificios descargada de Catastro:




## Descarga datos de edificios de OSM

Abrimos en un navegador https://overpass-turbo.eu/. Situar la vista del mapa sobre una ciudad (en nuestro caso Barcelona) y copiar el siguiente código.

```
[out:json][timeout:25];
// gather results
(
  way["building"="yes"]({{bbox}});
);
// print results
out body;
>;
out skel qt;
```

Exportar el resultado como GeoJSON y guardarlo en un fichero llamado *buildings.geojson*

## Cargar los datos en Postgis

Para cargar los datos utilizaremos la librería de GDAL/OGR con el siguiente comando

```bash
ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:3857 -overwrite -f "PostgreSQL" -nln public.building PG:"host=127.0.0.1 user=postgres password=postgres dbname=postgres" buildings.geojson -lco GEOMETRY_NAME=geom  -skipfailures
```






```bash
psql < datos/buildings.sql
t_rex serve --dbconn postgresql://user:user@localhost/buildings
```

