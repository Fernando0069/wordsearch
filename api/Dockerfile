FROM registry.access.redhat.com/ubi9/nodejs-22-minimal:9.5

# Crea el directorio y asigna permisos al usuario 'node'
RUN mkdir -p /app && chown -R node:node /app

# Usa el usuario no-root que ya viene en la imagen oficial
USER node

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia el archivo de configuración primero para aprovechar la cache
COPY --chown=node:node package.json ./

# Instala dependencias
RUN npm install

# Copia el resto de los archivos
COPY --chown=node:node . .

# Expone el puerto (coincide con el de .env)
EXPOSE 3000

# Comando para arrancar la app
CMD ["npm", "start"]
