# Trabajando con teselas vectoriales

Bienvenidos al taller de teselas vectoriales. Este manual está publicado aquí:

# https://geoinquiets.github.io/taller-vt/

## Autores

* Wladimir Szczerban (alias Bolo) *@bolosig*, [geostarter](http://betaportal.icgc.cat) (ICGC)
* Oscar Fonts *@oscarfonts*, desarrollador freelance en [geomati.co](http://geomati.co)

Y ambos somos [geoinquiets](http://geoinquiets.cat)!

!!! note "Condiciones de reutilización de estos apuntes"

    Estos materiales están publicados bajo licencia
    [CreativeCommons (by-sa) 4.0 internacional](https://creativecommons.org/licenses/by-sa/4.0/deed.es_ES)
    
    Usted es libre de:
    * Compartir — copiar y redistribuir el material en cualquier medio o formato
    * Adaptar — remezclar, transformar y crear a partir del material para cualquier finalidad, incluso comercial.
    
    Bajo las condiciones siguientes:
    * Reconocimiento — Debe reconocer adecuadamente la autoría, proporcionar un enlace a la licencia e indicar si se han realizado cambios. Puede hacerlo de cualquier manera razonable, pero no de una manera que sugiera que tiene el apoyo del licenciador o lo recibe por el uso que hace.
    * CompartirIgual — Si remezcla, transforma o crea a partir del material, deberá difundir sus contribuciones bajo la misma licencia que el original.
    * No hay restricciones adicionales — No puede aplicar términos legales o medidas tecnológicas que legalmente restrinjan realizar aquello que la licencia permite.


## Esenciales para moverse por OSGeo Live

* Usuario: "siglibre"
* Password: "siglibre"
* Para lanzar un programa de forma rápida: Menú inicio => Ejecutar
* `Shift + Ctrl + V` para pegar un texto del portapapeles en el terminal


## Descarga de los materiales para el taller

```bash
cd Desktop
wget https://geoinquiets.github.io/taller-vt/downloads/taller-vt.zip
unzip taller-vt.zip
cd taller-vt
ll
```

Así pues, la ruta `~/Desktop/taller-vt` será nuestro directorio base, donde iremos creando los recursos necesarios.
De momento tenemos los subdirectorios:

* `datos`
* `maputnik`


## Comprobación del software preinstalado

En el aula de la práctica se ha preinstalado una serie de software necesario para el taller.
En caso de que falte alguno, se pueden consultar las instrucciones de instalación en el siguiente apartado.

Comandos de comprobación: 

* `Alt + F2` => "terminator" debería abrir un terminal.
* `google-chrome http://tileserver.fonts.cat/styles/dark-matter/style.json` debería abrir Chrome y mostrar un JSON formateado y coloreado.
* `google-chrome http://tileserver.fonts.cat/styles/dark-matter-3d/?vector#16.09/41.3861/2.19226/-47.2/60` debería mostrar un mapa de Barcelona con edificios en 3D, y moverse con soltura.
* `node -v` Debería ser 6.x.x (NO mayor que 6, si aparece 8.x.x o 10.x.x, hay que cambiar de versión)
* `npm -v`
* `code -v`
* `tippecanoe -v`

## Instalación de requisitos de software

El software de base para el taller ya está instalado en los ordenadores del aula, pero indicamos aquí cómo instalarlo
tomando como base OSGeo Live 11 (también valdrá para Ubuntu 16.04, en el que además debería instalarse PostGIS).

1. [Google Chrome](https://www.google.com/chrome/)
2. La extensión [json-viewer](https://chrome.google.com/webstore/detail/json-viewer/gbmdgpbipfallnflgajpaliibnhdgobh) en Chrome
3. [Microsoft Visual Studio Code](https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions)
4. Terminator:
    ```bash
    sudo apt install terminator
    ```
5. node6 y npm (sobre nvm):

    Primero, instalar nvm:
    
    ```bash
      curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
    ```
    
    Cerrar y reabrir el terminal.
    Luego, instalar node 6 y npm:
    
    ```
      nvm install 6
      npm install -g npm
      # comprobar versiones
      node -v # Debería ser 6.x.x
      npm -v # Debería ser 6.x.x o mayor
    ```

6. tippecanoe:

    Instalar dependencias (librerías sqlite3 y zlib):
    
    ```bash
    sudo apt install build-essential libsqlite3-dev zlib1g-dev
    ```
    
    Bajarse el código fuente:
    
    ```bash
    git clone https://github.com/mapbox/tippecanoe.git
    cd tippecanoe
    ``` 
    
    Compilar:
    
    ```bash
    make -j
    sudo make install
    ```
    
    Comprobar la instalación:
    
    ```bash
    tippecanoe -v # Devolverá, por ejemplo, v1.29.0
    ```
    
    Una vez instalado el ejecutable, podemos borrar el código fuente:
    
    ```bash
    cd ..
    rm -rf tippecanoe
    ```

!!! danger
    Todo el taller se basa en tener un navegador con capacidades WebGL, que debería
     poder moverse RÁPIDO.
    
    1. Comprobar que al abrirse esta página, se ve un mapa de Barcelona con edificios:
    http://tileserver.fonts.cat/styles/dark-matter-3d/?vector#16.09/41.3861/2.19226/-47.2/60
    2. Comprobar que el mapa se mueve con soltura.
    3. Si no se puede correr el SO nativo (sería lo ideal), ajustar la configuración
    de VirtualBox para tener activadas las opciones:
        * System > Processor > "Enable PAE/NX"
        * Display > Screen > Aumentar MB disponibles para la tarjeta gráfica.
        * Display > Screen > "Enable 3D acceleration".
        * Tener instaladas las "VirtualBox Guest Additions" en la máquina virtual.


## Recursos adicionales

Mayormente de [Raf](https://twitter.com/fakeraf), nuestra fuente diaria de vitaminas, vía [Geoinquiets](https://twitter.com/geoinquiets). 

* [Awesome Vector Tiles](https://github.com/mapbox/awesome-vector-tiles) 
* [Natural Earth Vector Tiles by Lukas Martinelli](https://github.com/lukasmartinelli/naturalearthtiles)
* [Tutorial de los Geoinquietos de Londres](https://geovation.github.io/build-your-own-static-vector-tile-pipeline)
* [Tilemaker, de OSM a mbtiles de una tacada](https://github.com/systemed/tilemaker)
* [Qué son las teselas vectoriales (vector tiles) y cómo generarlos con PostGIS / GeoServer](https://mappinggis.com/2017/09/que-son-los-vector-tiles-y-como-generarlos-con-geoserver/)
* [Natural Earth Quickstart Style implemented with Tegola](http://www.gretchenpeterson.com/blog/archives/4901)
* [GeoServer MBStyle Cookbook](http://docs.geoserver.org/stable/en/user/styling/mbstyle/cookbook/index.html)
* [GeoServer MBStyle Styling Workbook](http://docs.geoserver.org/stable/en/user/styling/workshop/mbstyle/index.html)
