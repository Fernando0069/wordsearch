# DB


## Creación de la db

*** COMANDO DE CREACION ***
oc new-app openshift/postgresql:15-el9 --name=wordsearch-db -e XXXX -l app=wordsearch, component=db


## ERD (Entity Relationship Diagram)

*** IMAGEN ***


## Configuración de la db
¿Qué hace wordsearch.sql?
```
Crea las tablas con su estructura y relaciones.
Añade índices para mejorar las consultas sobre campos importantes.
Define tres triggers:
•	Otorgar logros cuando se complete una acción específica.
•	Actualizar el leaderboard con la mejor puntuación y tiempo.
•	Notificar al usuario cuando sube de nivel.
Crea una tabla de notificaciones para almacenar mensajes del sistema.
```

¿Cómo lo ejecuto wordsearch.sql?
```
xxxxxxxx
```