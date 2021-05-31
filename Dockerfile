# Using Multistage build to keep the final docker image clean reduce size
# Using the final image same as base image to run the jar as non-root user (application)
# To reduce the size of final image we can also use a java-jre based image like openjdk:8-jre for the final stage
# to build the image use command :
# docker build -t testapp-centos7-java:v1 .
# to run the container use the command :
# docker run -it -e MYSQL_DB_USER="root" -e MYSQL_DB_USER_PASSWORD="testit" --link mysqlservice2:mysqlservice2 -e MYSQL_DB_HOST="mysqlservice2" -p 8080:8080 testapp-centos7-java:v1

FROM centos:7 AS base
WORKDIR /app
# updating pagkages, creating a non-root user and changing ownership of /app folder
RUN yum -y update && yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel \
    && export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.292.b10-1.el7_9.x86_64" \
    && groupadd -g 8877 application && useradd -u 8877 -g application application \
    && chown -R application:application /app
ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.292.b10-1.el7_9.x86_64"
ENV PATH="$JAVA_HOME/bin:$PATH"
ADD . /app/

# second stage to build the artifact (.jar file) 
FROM base AS build
RUN ./gradlew build

# Final Docker Image to be used to run the application
FROM base AS final
WORKDIR /app
COPY --from=build --chown=application:application /app/build/libs/*.jar /app/app.jar
RUN chmod 777 /app/app.jar
# Changing user to non-root
USER application
EXPOSE 8080
CMD java -jar app.jar
