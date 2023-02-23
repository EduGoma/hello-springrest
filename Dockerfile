FROM gradle:alpine AS builder
WORKDIR /home/gradle
COPY . /home/gradle
RUN ./gradle/gradlew assemble

FROM amazoncorretto:11-alpine AS runtime 
WORKDIR /app
COPY --from=builder /home/gradle/build/libs/rest-service-0.0.1-SNAPSHOT.jar .
CMD ["java", "-jar", "rest-service-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080
