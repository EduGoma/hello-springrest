FROM amazoncorretto:11-alpine as builder
WORKDIR /tmp/app
COPY . .
RUN ./gradlew assemble

FROM amazoncorretto:11-alpine AS runtime 
WORKDIR /app
COPY --from=builder /tmp/app/build/libs/rest-service-0.0.1-SNAPSHOT.jar .
CMD ["java", "-jar", "rest-service-0.0.1-SNAPSHOT.jar"]
USER 1000
#Se puede usar USER para acceder a la imagen sin ser root y mejorar la seguridad.
#HEALTHCHECK
# --interval=5m --timeout=3s \
#  CMD curl -f http://localhost/ || exit 1
# Tambien se puede usar Healrhcheck para comprobar cada cierto tiempo el correcto funcionamiento
EXPOSE 8080
