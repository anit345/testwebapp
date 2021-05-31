This Project aims at Dockerising the Test web app and deploying it to Kubernetes Cluster using Helm.

Tools Used: 

- Docker
- OpenJDK 1.8
- Gradle
- Docker Image  MySQL5.7
- Helm 3

Steps Followed: 

A. Debugging the application 

    - The given source code was compiled to generate .jar package and test the functionality
    - The App was crashing with Error :
        "com.mysql.jdbc.exceptions.jdbc4.CommunicationsException: Communications link failure"
      and warning :
        " Establishing SSL connection without server's identity verification is not recommended. According to MySQL 5.5.45+, 5.6.26+ and 5.7.6+ requirements SSL connection must be established by default if explicit option isn't set. For compliance with existing applications not using SSL the verifyServerCertificate property is set to 'false'. You need either to explicitly disable SSL by setting useSSL=false"
    - Solution :
        Added annotation to skip ssl check in "application.properties" file. Comments added in file.
    - Dependencies Identified :
        MySQL 5.7 with a blank database named "db_example"
    - Post the changes and a MySQL Connection the app was wroking

B. Dockerising the Application 
    - A multistage Dockerfile was written to Build the Docker Image with Base Image as CentOS 7 as requested
    - A base image was created with a non-root user ("application") to run the application.
    - to test the app a MySQL 5.7 container was linked to get a reliable connection to database. the blank database was created for application to use.
    - Comments are added to Dockerfile
    - Command used to run the container :
        " docker run -it -e MYSQL_DB_USER="root" -e MYSQL_DB_USER_PASSWORD="testit" --link mysqlservice2:mysqlservice2 -e MYSQL_DB_HOST="mysqlservice2" -p 8080:8080 testapp-centos7-java:v1 "
    - Screenshots are attached to show the working app.
    - the Docker Image is pushed to Dockerhub and available at : anitsharma/testwebapp:version1

C. Deploy to Kubernetes:
    - Helm was used to create a helm chart for the application
    - templates were modified as per the application requirement 
    - secret was created to pass the environment varuables ( MYSQL_DB_USER, MYSQL_DB_USER_PASSWORD, MYSQL_DB_HOST )

    - to check the template syntax :
        helm lint  helm lint testwebapp/
    
    - to view the value substituted yamls for kubernetes resources to be created :
        helm template testwebapp testwebapp/
    
    - to test if everything is ready to be deployed :
        helm install --dry-run -o yaml testwebapp/
    
    - to deploy the chart to kubernetes Cluster :
        helm install testwebapp testwebapp/
    
    Note: 
        - MySQL details need to be updated in values.yaml to get the container working.

D. Next steps :
    - Create a helm package and store in a centeral helm repository (github-pages / s3 / gcs etc.)
    - Replace Kubernetes secrets with a more secure Secret manager like Hashicorp Vault / google secret manager etc.
    - use a DBaaS for database like RDS, CloudSQL etc.
