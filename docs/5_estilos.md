# Cómo simbolizar teselas vectoriales

## Maputnik

Es un editor visual gratuito y abierto para estilos Mapbox GL dirigidos tanto a desarrolladores como a diseñadores de mapas.

Se puede utilizar en línea en [*Maputnik editor*](https://maputnik.github.io/editor/) (todo se guarda en el almacenamiento local) ó se puede hacer una instalación local.

### Instalación 

Si vamos a la página de [*Releases*](https://github.com/maputnik/editor/releases) de Maputnik aparece que la última versión es la v1.0.2. Realmente existe una versión v1.1.0 que está en la página de releases pero que no está marcada como la última versión.

Descagaremos la versión v1.1.0 que es la última versión disponible para la fecha de este taller. 

```
wget https://github.com/maputnik/editor/archive/v1.1.0.tar.gz
tar -xzvf archivo.tar.gz
```

Vamos a la carpeta *editor-1.1.0* creada al descomprimir el archivo descargado he instalamos las dependencias del Maputnik

```
cd editor-1.1.0
npm install
```

Al finalizar la instalación comprobamos que no aparezca ningún error (pueden aparecer algunos WARN) y arrancamos el servidor de Maputnik

```
npm start
```

Abrir el navegador y escribir http://localhost:8888 y comprobar que aparece la página del Maputnik

![Maputnik](img/maputnik.png)
*Maputnik*

## Estilizar el mbtiles

### Agregar un origen de datos (Source)

En el editor del Maputnik en la barra de menú seleccionamos la opción de **Source** para desplegar el diálogo de gestionar fuentes de datos. En la parte inferior del diálogo esta el apartado para agregar una fuente nueva de datos *Add New Source*. Para agregar nuestra fuente de datos mbtiles tenemos dos opciones.

![Maputnik Add Source](img/maputnik_add_source.png)

*Maputnik agregar origen de datos*

1. Vector (TileJSON URL)

*Source ID*: identificador único de la capa: es el nombre que utilizaremos como referencia en las capas. En nuestro caso pondremos *natural_earth*

*Source Type*: tipo de la fuente de datos. Seleccionar la opción de *Vector (TileJSON URL)*

*TileJSON URL*: url del archivo JSON de descripción de la fuente. Pondremos la url de nuestro TileServerGL http://localhost:8181/data/natural_earth.json


2. Vector (XYZ URL)

*Source ID*: identificador único de la capa: es el nombre que utilizaremos como referencia en las capas. En nuestro caso pondremos *natural_earth_1*

*Source Type*: tipo de la fuente de datos. Seleccionar la opción de *Vector (XYZ URL)*

*TileJSON URL*: url del servicio de teselas. Pondremos la url de nuestro TileServerGL http://localhost:8181/data/natural_earth/{z}/{x}/{y}.pbf

*Min Zoom*: 0

*Max Zoom*: 5

### Agregar una capa

En el editor de Maputnik presionamos el botón de **Add Layer** para desplegar el diálogo de agregar capa al mapa. 

![Maputnik Add Layer](img/maputnik_add_layer.png)

*Maputnik agregar capa*

*ID*: identificador único de la capa. Pondremos *continentes*

*Type*: tipo de capa. Seleccionar la opción de *Fill*

*Source*: identificador del origen de datos. En nuestro caso pondremos *natural_earth*

*Source Layer*: identificador de la capa dentro del origen de datos. Pondremos *land* para agregar la capa de tierra firme.

### Agregar sprite y glyph

En el editor de Maputnik en la barra de menú seleccionamos la opción de **Style Settings** para desplegar el diálogo de gestionar la configuración del estilo.

![Maputnik Style Settings](img/maputnik_style_settings.png)

*Maputnik configuración de estilo*


*Sprite URL*: proporciona una plantilla para cargar imágenes pequeñas para usar en la representación de estilo del fondo, patrones de relleno, patrones de líneas e imagenes de iconos. En nuestro caso pondremos "https://openmaptiles.github.io/osm-bright-gl-style/sprite"

*Glyphs URL*: proporciona una plantilla para cargar conjuntos de glifos formato PBF. Aquí es donde se cargan las diferentes fuentes. En nuestro caso pondremos "https://free.tilehosting.com/fonts/{fontstack}/{range}.pbf?key=RiS4gsgZPZqeeMlIyxFo"
