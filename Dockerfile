# Stage 1: Build the React frontend
FROM node:20-alpine AS build-frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Build the Spring Boot backend with the frontend assets
FROM maven:3.9-eclipse-temurin-21 AS build-backend
WORKDIR /app
# Copy the backend source code
COPY backend/ ./
# Copy the built frontend assets from the 'build-frontend' stage
# into the Spring Boot static resources directory.
COPY --from=build-frontend /app/frontend/dist/ /app/src/main/resources/static/
# Package the Spring Boot application
RUN mvn package -DskipTests

# Stage 3: Create the final, lean production image
FROM openjdk:21-slim
WORKDIR /app
# Copy the executable JAR from the 'build-backend' stage
COPY --from=build-backend /app/target/*.jar app.jar
# Expose the port the application runs on
EXPOSE 8080
# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
