FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY target/nmtelecom-0.0.1-SNAPSHOT.war app.war

ENV PORT=8080
EXPOSE 8080

CMD ["java", "-jar", "app.war"]
