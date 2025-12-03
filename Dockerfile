############################
# Stage 1 — Build WAR File #
############################
FROM maven:3.9.3-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy project source
COPY pom.xml .
COPY src ./src

# Build WAR (skip tests if needed)
RUN mvn clean package -DskipTests


################################
# Stage 2 — Tomcat Runtime     #
################################
FROM tomcat:9.0-jdk17-temurin

# Set env variables for RDS or DB
ENV DB_HOST=localhost \
    DB_PORT=3306 \
    DB_USER=root \
    DB_PASSWORD_FILE=/run/secrets/db_password

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from builder stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
