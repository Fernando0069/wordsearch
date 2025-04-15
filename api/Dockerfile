# Usar OpenJDK 21 como base
FROM registry.redhat.io/ubi9/openjdk-21 as builder

# Instalar Maven en la imagen base
RUN microdnf update && microdnf install maven

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo pom.xml y las dependencias de la aplicación
COPY pom.xml /app/
COPY src /app/src/

# Ejecutar Maven para compilar la aplicación y crear el archivo JAR
RUN mvn clean package -DskipTests

# Exponer el puerto por defecto de Spring Boot (8080)
EXPOSE 8080

# Comando para ejecutar la aplicación Spring Boot
CMD ["java", "-jar", "/app/target/wordsearch-api.jar"]
