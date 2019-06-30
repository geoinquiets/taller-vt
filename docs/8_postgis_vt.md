# Cómo servir datos desde PostGIS

A partir de la versión 2.4.0 de PostGIS están disponibles dos nuevas funciones [`ST_AsMVTGeom`](https://postgis.net/docs/ST_AsMVTGeom.html) y [`ST_AsMVT`](https://postgis.net/docs/ST_AsMVT.html)

## Función ST_AsMVTGeom

La función ST_AsMVTGeom transforma una geometría al espacio de coordenadas de una tesela vectorial. Transforma las coordenadas de una geometría en coordenadas dentro de una tesela.

Ejemplo para la tesela 14/8289/6119 z=14 x=8289 y=6119
``` sql
SELECT gid, c_distri, n_distri, c_barri, n_barri, homes, dones, area, 
  ST_AsMvtGeom(
      geom,
      BBox(14, 8289, 6119),
      4096,
      256,
      true
  ) AS geom
FROM public.barrios
WHERE geom && BBox(14, 8289, 6119)
AND ST_Intersects(geom, BBox(14, 8289, 6119));
```

## Función ST_AsMVT

La función ST_AsMVT codifica una geometria en coordenadas de teselas como una capa (Layer) **mvt** (pbf)

Ejemplo para la capa barrios y la tesela 14/8289/6119
``` sql
SELECT ST_AsMVT(q, 'barrios', 4096, 'geom')
FROM (
  SELECT gid, c_distri, n_distri, c_barri, n_barri, homes, dones, area, 
    ST_AsMvtGeom(
      geom,
	  BBox(14, 8289, 6119),
	  4096,
	  256,
	  true
    ) AS geom
  FROM public.barrios
  WHERE geom && BBox(14, 8289, 6119)
  AND ST_Intersects(geom, BBox(14, 8289, 6119))
) AS q;
```

Como un **mvt** es una succesion de capas, para crear un vector tile multicapa se pueden concatenar varias consultas.

## Función BBox

Función que convierte las coordenadas de una tesela (z,x,y) en su correspondiente caja de coordenadas (bbox) en webmercator (EPSG:3857) 

``` sql
CREATE OR REPLACE FUNCTION BBox(zoom integer, x integer, y integer)
    RETURNS geometry AS
$BODY$
DECLARE
    max numeric := 6378137 * pi(); --20037508.34;
    res numeric := max * 2 / 2^zoom;
    bbox geometry;
BEGIN
    return ST_MakeEnvelope(
        -max + (x * res),
        max - (y * res),
        -max + (x * res) + res,
        max - (y * res) - res,
        3857);
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
```

En nuestro caso utilizaremos una función un poco más generalista que permite indicar el srid
``` sql
CREATE OR REPLACE FUNCTION public.tilebbox(
	z integer,
	x integer,
	y integer,
	srid integer DEFAULT 3857)
    RETURNS geometry
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
AS $BODY$
declare
    max numeric := 20037508.34; --6378137 * pi();
    res numeric := (max*2)/(2^z);
    bbox geometry;
begin
    bbox := ST_MakeEnvelope(
        -max + (x * res),
        max - (y * res),
        -max + (x * res) + res,
        max - (y * res) - res,
        3857
    );
    if srid = 3857 then
        return bbox;
    else
        return ST_Transform(bbox, srid);
    end if;
end;
$BODY$;

ALTER FUNCTION public.tilebbox(integer, integer, integer, integer)
    OWNER TO postgres;
```

## Crear la base de datos

!!! warning
    Si ya hemos creado la base de datos en el apartado anterior ignorar esta parte

Descargamos el archivo que contiene el script de creacion de la base de datos y las tablas correspondientes

``` bash
wget https://raw.githubusercontent.com/geoinquiets/taller-vt/master/resultado/datos/bcn_geodata.sql
```

Modificamos el archivo bcn_geodata.sql y remplazamos donde dice owner "user" por owner "postgres". Una vez modificado el archivo cargamos el script con psql

```bash
psql -U postgres -h localhost < bcn_geodata.sql
```

## Combinar varias capas en una misma tesela

Como comentamos anteriormente "un **mvt** es una succesion de capas, para crear un vector tile multicapa se pueden concatenar varias consultas".

Para combinar varias capas en una misma tesela podemos utilizar una serie de funciones desarrolladas por el ICGC https://github.com/gencat/ICGC-vt-postgis que facilitan este trabajo.

Descargar el archivo que permite crear las funciones y el esquema

``` bash
wget https://raw.githubusercontent.com/gencat/ICGC-vt-postgis/master/icgc-vt-postgis-create.sql
```

Crear el esquema y las funciones en la base de datos de bcn_geodata

``` bash
psql -U postgres -d bcn_geodata -h localhost -f icgc-vt-postgis-create.sql
```

Agregar la funcion tilebbox en nuestra base de datos y agregar las capas en la tabla icgc_vt.layers

``` sql
CREATE OR REPLACE FUNCTION public.tilebbox(
	z integer,
	x integer,
	y integer,
	srid integer DEFAULT 3857)
    RETURNS geometry
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
AS $BODY$
declare
    max numeric := 20037508.34; --6378137 * pi();
    res numeric := (max*2)/(2^z);
    bbox geometry;
begin
    bbox := ST_MakeEnvelope(
        -max + (x * res),
        max - (y * res),
        -max + (x * res) + res,
        max - (y * res) - res,
        3857
    );
    if srid = 3857 then
        return bbox;
    else
        return ST_Transform(bbox, srid);
    end if;
end;
$BODY$;

ALTER FUNCTION public.tilebbox(integer, integer, integer, integer)
    OWNER TO postgres;

INSERT INTO icgc_vt.layers(
            name, geometry_type, minz, maxz, sql)
    VALUES ('barrios', 'POLYGON', 10, 18, 'SELECT ST_AsBinary(geom) AS geom, gid, c_distri, n_distri, c_barri, n_barri, homes, dones, area FROM public.barrios WHERE geom && !BBOX!');

INSERT INTO icgc_vt.layers(
            name, geometry_type, minz, maxz, sql)
    VALUES ('distritos', 'POLYGON', 10, 18, 'SELECT ST_AsBinary(geom) AS geom, gid, c_distri, n_distri, homes, dones, area FROM public.distritos WHERE geom && !BBOX!');

INSERT INTO icgc_vt.layers(
            name, geometry_type, minz, maxz, sql)
    VALUES ('seccion_censal', 'POLYGON', 10, 18, 'SELECT ST_AsBinary(geom) AS geom, gid, c_distri, n_distri, c_barri, n_barri, c_aeb, c_seccens, homes, dones, area FROM public.seccion_censal WHERE geom && !BBOX!');
```

Podemos comprobar que la funcion que retorna todas las capas como una tesela funciona

``` sql
SELECT icgc_vt.tile_pbf(15,16578,12236);
```  

## Configurar un servidor web para que sirva las capas de postgis

Crearemos un servidor web utilizando el express server que nos permita servir los datos de la basa de datos como un Vector Tiles. Para ello utilizaremos una aplicación desarrollada por el ICGC https://github.com/gencat/ICGC-vtServer

Clonamos el repositorio 

``` bash
git clone https://github.com/gencat/ICGC-vtServer.git

cd ICGC-vtServer
```

Creamos el archivo .env que permitira la conexion a nuestra base de datos con el siguiente contenido

``` env
DB_USER=postgres
DB_HOST=localhost
DB_DATABASE=bcn_geodata
DB_PASS=postgres
DB_PORT=5432
```

Creamos un nuevo archivo el la carpeta de static con el nombre de bcn_geodata.json con el siguiente contenido

``` json
{
  "version": 8,
  "name": "ICGC",
  "metadata": {},
  "center": [
    1.537786,
    41.837539
  ],
  "zoom": 12,
  "bearing": 0,
  "pitch": 0,
  "sources": {
    "openmaptiles": {
      "type": "vector",
	    "tiles": [
        "http://localhost:3333/{z}/{x}/{y}.pbf"
	    ]
    }
  },
  "sprite": "https://geoserveis.icgc.cat/contextmaps/sprites/sprite@1",
  "glyphs": "https://geoserveis.icgc.cat/contextmaps/glyphs/{fontstack}/{range}.pbf",
  "layers": [
    {
      "id": "background",
      "type": "background",
      "paint": {
        "background-color": "#f8f4f0"
      }
    },
    {
      "id": "barrios",
      "type": "fill",
      "source": "openmaptiles",
      "source-layer": "barrios",
      "layout": {
        "visibility": "visible"
      },
      "paint": {
        "fill-color": "#ff0000",
        "fill-opacity": {
          "base": 1,
          "stops": [
            [
              9,
              0.9
            ],
            [
              22,
              0.3
            ]
          ]
        }
      }
    }
  ],
  "id": "bcn-geodata"
}
```

Modificar el archivo static/index3.html para que cargue nuestro estilo

``` html hl_lines="42"
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8' />
    <title>Swipe between maps</title>
    <meta name='viewport' content='initial-scale=1,maximum-scale=1,user-scalable=no' />
    <script src='https://api.tiles.mapbox.com/mapbox-gl-js/v0.49.0/mapbox-gl.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox-gl-js/v0.49.0/mapbox-gl.css' rel='stylesheet' />
    <style>
        body { margin:0; padding:0; }
        #map { position:absolute; top:0; bottom:0; width:100%; }
    </style>
</head>
<body>

<style>
body {
    overflow: hidden;
}

body * {
   -webkit-touch-callout: none;
     -webkit-user-select: none;
        -moz-user-select: none;
         -ms-user-select: none;
             user-select: none;
}

.map {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 100%;
}
</style>

<div id='after' class='map'></div>
<script>

var afterMap = new mapboxgl.Map({
    container: 'after',
    style: 'bcn_geodata.json',
    center: [2.16859, 41.3954],
	zoom: 13,
	maxZoom: 16,
	hash: true,
	pitch: 45
});

afterMap.on('click', function(e) {
	var features = afterMap.queryRenderedFeatures(e.point);
	var description = JSON.stringify(features, null, 2);
	console.log(description);
	/*
	new mapboxgl.Popup()
            .setLngLat(e.lngLat)
            .setHTML(description)
			.addTo(afterMap);
			*/
});

</script>

</body>
</html>
```

## Ejercicio 

Agregar las capas de distritos y seccion_censal al estilo bcn_geodata
