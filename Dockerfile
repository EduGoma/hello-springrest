FROM gradle AS builder
WORKDIR /gradle/
COPY . .
RUN ./gradlew package

FROM alpine:3.16 AS runtime 
WORKDIR /otp/golang/
COPY --from=builder /go/golang/main .
CMD ["./main"]
EXPOSE 8888