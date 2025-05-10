FROM registry.access.redhat.com/ubi9/nodejs-22-minimal:9.5

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de configuración primero para aprovechar la cache
COPY package.json ./

# Instala dependencias
RUN npm install

# Copia el resto de los archivos
COPY . .

# Expone el puerto (coincide con el de .env)
EXPOSE 3000

# Comando para arrancar la app
CMD ["npm", "start"]
