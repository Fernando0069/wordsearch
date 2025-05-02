# Usar OpenJDK 21 como base
FROM registry.access.redhat.com/ubi9/ubi-minimal:latest as builder

# Instalar Maven en la imagen base
RUN microdnf update -y
RUN microdnf install maven -y 
RUN microdnf clean all

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el archivo pom.xml y las dependencias de la aplicación
COPY pom.xml /app/
COPY src /app/src/

# Ejecutar Maven para compilar la aplicación y crear el archivo JAR
RUN mvn clean package -DskipTests


# Usar OpenJDK 21 como base
FROM registry.redhat.io/ubi9/openjdk-21:latest

# Instalar Maven en la imagen base
RUN microdnf update

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar el jar creado
COPY --from=builder /app/target/wordsearch-api.jar wordsearch-api.jar

# Exponer el puerto por defecto de Spring Boot (8080)
EXPOSE 8080

# Comando para ejecutar la aplicación Spring Boot
CMD ["java", "-jar", "/app/target/wordsearch-api.jar"]
