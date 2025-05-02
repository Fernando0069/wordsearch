# DB


## Creación de la DB
Se puede hacer de dos maneras:

### Crando todo de golpe:
```
oc apply -f db.yaml
```

### Creando todo pod partes:
```
vi wordsearch-db-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wordsearch-db-pvc
  namespace: fernando0069-dev
  labels:
    app: wordsearch
    component: db-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: gp3
oc apply -f wordsearch-db-pvc.yaml

vi wordsearch-db.yaml
kind: Secret
apiVersion: v1
metadata:
  name: wordsearch-db
  namespace: fernando0069-dev
  labels:
    app: wordsearch
    component: db-secret
data:
  POSTGRESQL_ADMIN_PASSWORD: RHIwd3NzNHAtdDAwcg==
  POSTGRESQL_DATABASE: d29yZHNlYXJjaC1kYg==
  POSTGRESQL_USER: d29yZHNlYXJjaC1kYg==
  POSTGRESQL_PASSWORD: YmQtaGNyNDNzZHIwVw==
type: Opaque
oc apply -f wordsearch-db.yaml
oc new-app openshift/postgresql:15-el9 --name=wordsearch-db -l app=wordsearch,component=db
oc set env deployment/wordsearch-db --from=secret/wordsearch-db
oc set volume deployment/wordsearch-db --add --name=wordsearch-db-storage --claim-name=wordsearch-db-pvc --mount-path=/var/lib/postgresql/data
```


### Objetos
Al final los dos métodos crean los mismos objetos:
 - PVC
 - Secret
 - Deployment
 - Service


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
oc get pods -l app=wordsearch-db
oc cp ./wordsearch.sql <POD_NAME>:/tmp/
oc rsh <POD_NAME>
psql -U wordsearch-db -d wordsearch-db -f /tmp/wordsearch.sql
```


## Eliminación de la DB
```
oc delete deployment wordsearch-db
oc delete service wordsearch-db
oc delete secret wordsearch-db
oc delete volume wordsearch-db-pvc
```