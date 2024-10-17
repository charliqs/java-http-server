FROM maven:3.8.4-openjdk-17 AS build
COPY . /app
WORKDIR /app
RUN mvn clean package

FROM openjdk:17-jdk-alpine
COPY --from=build /app/target/http-server-1.0-SNAPSHOT.jar /app/http-server-1.0-SNAPSHOT.jar
EXPOSE 8000
CMD ["java", "-jar", "/app/http-server-1.0-SNAPSHOT.jar"]