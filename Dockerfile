FROM alpine:3
COPY target/*.jar /app/
RUN apk --update add openjdk8-jre
ENTRYPOINT ["java", "-jar","/app/spring-petclinic-2.4.5.jar"]
