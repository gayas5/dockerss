# 🚀 Docker & Dockerfile — Complete Guide With Commands and Explanations

This document explains **Docker**, **Dockerfiles**, **Images**, **Containers**, **Volumes**, **Networks**, **Best Practices**, and **step-by-step commands** for development and production.

The goal:  
✔ Understand Docker clearly  
✔ Build and run containers  
✔ Write professional Dockerfiles  
✔ Use volumes, networks, environment variables  
✔ Implement multi-stage Docker builds  
✔ Use Docker Compose  

---

# 🐳 1. What is Docker?

Docker is a **containerization platform** that packages applications and their dependencies into **lightweight containers**.

### Benefits:
- 🚀 Fast deployment  
- 📦 Consistent environments  
- 🔄 Easy scaling  
- 🔐 Isolated apps  
- ⚡ Faster CI/CD  

---

# 🧱 2. What is a Docker Image?

A **Docker Image** is a blueprint of your application.

Contains:
- OS (base image)
- Application code
- Dependencies (Node.js, Python, etc.)
- Configuration

Think of it as a "template".

### Check images:
```bash
docker images
```

---

# 📦 3. What is a Docker Container?

A **container** = running instance of an image.

Commands:

### Run a container:
```bash
docker run -it ubuntu bash
```

### List containers:
```bash
docker ps
# all containers
docker ps -a
```

### Stop container:
```bash
docker stop <id>
```

### Remove container:
```bash
docker rm <id>
```

---

# 🏗️ 4. What is a Dockerfile?

A **Dockerfile** is a script containing instructions to build an image.

### Basic Dockerfile Example (Node.js)

```dockerfile
FROM node:18

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
```

### Build the image:
```bash
docker build -t myapp .
```

### Run container:
```bash
docker run -p 3000:3000 myapp
```

---

# 🔁 5. Multi-Stage Docker Build (Best Practice)

Reduces image size by separating build & runtime stages.

```dockerfile
# Stage 1 – Builder
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2 – Production
FROM node:18-slim
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY package.json .
RUN npm install --production

EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### Build:
```bash
docker build -t myapp-prod .
```

---

# 📁 6. Docker Volumes (Persistent Storage)

Used for logs, uploads, DB data.

### Create volume:
```bash
docker volume create mydata
```

### Use volume:
```bash
docker run -v mydata:/app/data myapp
```

### List volumes:
```bash
docker volume ls
```

---

# 🌐 7. Docker Networks

Used for container-to-container communication.

### Create network:
```bash
docker network create backend
```

### Run containers on network:
```bash
docker run --network backend mysql
docker run --network backend node-app
```

---

# 🔐 8. Environment Variables & Secrets

### Pass env vars:
```bash
docker run -e DB_HOST=localhost -e DB_PASS=123 myapp
```

### Using `.env` file:
```
DB_HOST=localhost
DB_USER=admin
DB_PASS=password
```

Run:
```bash
docker --env-file .env run myapp
```

---

# 🧩 9. Docker Compose (Multi-container setup)

**docker-compose.yml:**

```yaml
version: "3.8"

services:
  app:
    build: .
    ports:
      - "3000:3000"
    env_file: .env
    volumes:
      - logs:/app/logs
    depends_on:
      - db

  db:
    image: mysql:8
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: appdb
    volumes:
      - dbdata:/var/lib/mysql

volumes:
  logs:
  dbdata:
```

### Start all containers:
```bash
docker-compose up -d
```

### Stop:
```bash
docker-compose down
```

---

# 🛠 10. Useful Docker Commands (Cheat Sheet)

### Stop all containers:
```bash
docker stop $(docker ps -aq)
```

### Remove all containers:
```bash
docker rm $(docker ps -aq)
```

### Remove all images:
```bash
docker rmi $(docker images -q)
```

### Remove all volumes:
```bash
docker volume rm $(docker volume ls -q)
```

---

# 📝 11. Best Practices for Docker & Dockerfile

### ✔ Use multi-stage builds  
### ✔ Avoid copying entire directory  
Use `.dockerignore`:
```
node_modules
.git
.env
```

### ✔ Use small base images  
Examples:
```
node:18-slim
python:3.11-alpine
```

### ✔ Don’t run apps as root  
Add:
```dockerfile
USER node
```

### ✔ Keep images stateless  
Use **Volumes** for data.

### ✔ Use health checks  
```dockerfile
HEALTHCHECK CMD curl -f http://localhost:3000 || exit 1
```
