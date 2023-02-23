FROM amazoncorretto:11-alpine as builder
WORKDIR /tmp/app
COPY . .
RUN ./gradlew assemble

FROM amazoncorretto:11-alpine AS runtime 
WORKDIR /app
COPY --from=builder /tmp/app/build/libs/rest-service-0.0.1-SNAPSHOT.jar .
CMD ["java", "-jar", "rest-service-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080
