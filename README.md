# Teselas Vectoriales en la IDE

# https://geomati.co/taller-vt-jiide/

## Guión del taller

* Concepto de tesela vectorial: Qué es, para qué sirve y para qué no.
* Creación y almacenaje de teselas vectoriales: Especificación mvt, formato pbf, fichero mbtiles.
* Servicio básico teselas vectoriales: Especificación TileJSON, servicio XYZ.
* Publicación mediante estándares WMS y WMTS.
* Formatos usados para los iconos y las tipografías: sprites y glyphs.
* Especificación de estilo "Mapbox GL Style spec".
* Visualizadores web basados en "Mapbox GL JS".

## Herramienta de documentación

Se usa [mkdocs](http://mkdocs.org) con el tema [mkdocs-material](https://squidfunk.github.io/mkdocs-material/).

Desinstalar versiones anteriores de mkdocs:

```bash
    sudo pip uninstall mkdocs
```

E instalar con el comando:

```bash
pip install mkdocs-material
```

### Comandos mkdocs

* `mkdocs serve`: Arranca un servidor web con auto-recarga.
* `mkdocs build`: Compila la documentación en html.
* `mkdocs gh-deploy`: Publica la documentación en gh-pages.

### Layout

    mkdocs.yml    # El fichero de configuración.
    docs/
        index.md  # La portada.
        ...       # Otras páginas en markdown, imágenes, etc.

### Markdown

* Chuleta rápida sobre links, imágenes y tablas en markdown: http://www.mkdocs.org/user-guide/writing-your-docs/#linking-documents
* [Especificación Markdown](http://spec.commonmark.org/0.28/) completa.
* Visual Studio Code ofrece una vista de Preview que va mostrando el resultado del markdown en tiempo real sin tener que salir del editor.
