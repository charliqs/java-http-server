FROM openjdk:17-jdk-alpine
COPY . /app
EXPOSE 8000
WORKDIR /app
RUN javac HttpServerExample.java
CMD ["java", "HttpServerExample"]
