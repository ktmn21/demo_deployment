# Use a base image with Java
FROM openjdk:17-jdk-slim as build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and install dependencies (this allows Docker to cache the dependencies layer)
COPY pom.xml .

# Download all dependencies (but not the code yet)
RUN ./mvnw dependency:go-offline

# Copy the rest of your application code to the container
COPY . .

# Package the application (this creates the .jar file)
RUN ./mvnw clean install

# Expose port 8080 to access the app from the outside
EXPOSE 8080

# Command to run the application inside the container
ENTRYPOINT ["java", "-jar", "/app/target/demo-deployment.jar"]
# Use an official OpenJDK 17 runtime as the base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the built JAR file from the target directory to the container
COPY target/demo_deployment-0.0.1-SNAPSHOT.jar /app/demo_deployment.jar

# Expose the application's port
EXPOSE 8080

# Set environment variables for MySQL (you can customize these as needed)
# Use host.docker.internal to access the host's MySQL server
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://dpg-ctiiqitumphs73f37uh0-a/inventory_management_vydk\
    SPRING_DATASOURCE_USERNAME=i_manager \
    SPRING_DATASOURCE_PASSWORD=fH6GV2MT7l0cD536aqwwsU2HeDjvey1C

# Command to run the application
ENTRYPOINT ["java", "-jar", "/app/Inventory-management.jar"]