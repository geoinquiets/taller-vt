# Taller de Vector Tiles

## Herramienta de documentación

Para compilarla se usa [mkdocs.org](http://mkdocs.org). Acceder a la web para ver cómo instalar.

* Chuleta rápida sobre links, imágenes y tablas en markdown: http://www.mkdocs.org/user-guide/writing-your-docs/#linking-documents
* [Especificación Markdown](http://spec.commonmark.org/0.28/) completa.

Visual Studio Code ofrece una vista de Preview que va mostrando el resultado del markdown en tiempo real sin tener que salir del editor.

## Comandos mkdocs

* `mkdocs serve`: Arranca un servidor web con auto-recarga.
* `mkdocs build`: Compila la documentación en html.
* `mkdocs gh-deploy`: Publica la documentación en gh-pages.

## Layout

    mkdocs.yml    # El fichero de configuración.
    docs/
        index.md  # La portada.
        ...       # Otras páginas en markdown, imágenes, etc.
