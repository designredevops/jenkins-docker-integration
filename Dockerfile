FROM openjdk:17
COPY target/*.jar /webapp.jar
EXPOSE 8080
CMD ["/usr/bin/java", "-jar", "-Dspring.profiles.active=default", "/webapp.jar"]
