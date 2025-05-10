# API

API creada con Node.js, Express y se apoya en la base de datos de PostgreSQL.

## Creación de la API
```
oc new-app --name=wordsearch-api https://github.com/fernando0069/wordsearch.git --context-dir=api/ -l app=wordsearch,component=api
oc new-build --name=wordsearch-api --dockerfile=$(cat Dockerfile)
```

## Estructura de archivos
```
api/
├── src/
│   ├── config/
│   ├── controllers/
│   ├── services/
│   ├── repositories/
│   ├── models/
│   ├── routes/
│   ├── middleware/
│   └── index.js
├── .env
├── .gitignore
├── package.json
└── README.md
```
