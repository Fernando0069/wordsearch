# APP


## Creación de la APP

*** COMANDO DE CREACION ***
oc new-app --name=wordsearch-app https://github.com/fernando0069/wordsearch.git --context-dir=app/ -l app=wordsearch, component=app