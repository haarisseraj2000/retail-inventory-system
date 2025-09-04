# Production Deployment Guide

## Deployment Options

### 1. Cloud Platforms (Recommended)

#### Heroku Deployment
```bash
# Install Heroku CLI
# Create Heroku app
heroku create retail-inventory-app

# Add MySQL addon
heroku addons:create cleardb:ignite

# Configure environment variables
heroku config:set SPRING_PROFILES_ACTIVE=production
heroku config:set MYSQL_URL=$(heroku config:get CLEARDB_DATABASE_URL)

# Deploy
git push heroku main
```

#### AWS Deployment
1. **RDS for MySQL**
   - Create RDS MySQL instance
   - Configure security groups
   - Note connection details

2. **Elastic Beanstalk for Backend**
   ```bash
   # Install EB CLI
   eb init
   eb create production
   eb deploy
   ```

3. **S3 + CloudFront for Frontend**
   - Upload frontend files to S3
   - Configure CloudFront distribution
   - Set up custom domain

#### Digital Ocean App Platform
```yaml
# .do/app.yaml
name: retail-inventory-system
services:
- name: backend
  source_dir: backend
  github:
    repo: your-username/retail-inventory-system
    branch: main
  run_command: java -jar target/retail-inventory-system-1.0.0.jar
  environment_slug: java
  instance_count: 1
  instance_size_slug: basic-xxs
  envs:
  - key: DATABASE_URL
    value: ${db.DATABASE_URL}
  - key: SPRING_PROFILES_ACTIVE
    value: production

- name: frontend
  source_dir: frontend
  github:
    repo: your-username/retail-inventory-system
    branch: main
  build_command: echo "Static files"
  run_command: echo "Static files"
  environment_slug: node-js
  instance_count: 1
  instance_size_slug: basic-xxs

databases:
- name: db
  engine: MYSQL
  version: "8"
  size: basic-xs
```

### 2. Docker Deployment

#### Docker Compose Setup
```yaml
# docker-compose.yml
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: retail_inventory
      MYSQL_ROOT_PASSWORD: secure_root_password
      MYSQL_USER: inventory_user
      MYSQL_PASSWORD: secure_password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./database/schema.sql:/docker-entrypoint-initdb.d/schema.sql
      - ./database/sample_data.sql:/docker-entrypoint-initdb.d/sample_data.sql
    restart: unless-stopped

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    environment:
      SPRING_PROFILES_ACTIVE: production
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/retail_inventory
      SPRING_DATASOURCE_USERNAME: inventory_user
      SPRING_DATASOURCE_PASSWORD: secure_password
    depends_on:
      - mysql
    restart: unless-stopped

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "80:80"
    depends_on:
      - backend
    restart: unless-stopped

volumes:
  mysql_data:
```

#### Backend Dockerfile
```dockerfile
# backend/Dockerfile
FROM openjdk:11-jre-slim

WORKDIR /app

COPY target/retail-inventory-system-1.0.0.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
```

#### Frontend Dockerfile
```dockerfile
# frontend/Dockerfile
FROM nginx:alpine

COPY . /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

### 3. Traditional Server Deployment

#### System Requirements
- **OS**: Ubuntu 20.04 LTS or CentOS 8
- **RAM**: Minimum 2GB, Recommended 4GB+
- **CPU**: 2+ cores
- **Storage**: 20GB+ SSD
- **Java**: OpenJDK 11
- **Database**: MySQL 8.0
- **Web Server**: Nginx (for frontend)

#### Server Setup
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Java 11
sudo apt install openjdk-11-jdk -y

# Install MySQL
sudo apt install mysql-server -y
sudo mysql_secure_installation

# Install Nginx
sudo apt install nginx -y

# Create application user
sudo useradd -m -s /bin/bash inventory
sudo mkdir -p /opt/retail-inventory
sudo chown inventory:inventory /opt/retail-inventory
```

#### Application Deployment
```bash
# Copy JAR file
sudo cp target/retail-inventory-system-1.0.0.jar /opt/retail-inventory/

# Create systemd service
sudo cat > /etc/systemd/system/retail-inventory.service << EOF
[Unit]
Description=Retail Inventory Management System
After=network.target mysql.service

[Service]
Type=simple
User=inventory
WorkingDirectory=/opt/retail-inventory
ExecStart=/usr/bin/java -jar retail-inventory-system-1.0.0.jar
Restart=always
RestartSec=10

Environment=SPRING_PROFILES_ACTIVE=production
Environment=SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/retail_inventory
Environment=SPRING_DATASOURCE_USERNAME=inventory_user
Environment=SPRING_DATASOURCE_PASSWORD=secure_password

[Install]
WantedBy=multi-user.target
EOF

# Start service
sudo systemctl daemon-reload
sudo systemctl enable retail-inventory
sudo systemctl start retail-inventory
```

#### Nginx Configuration
```nginx
# /etc/nginx/sites-available/retail-inventory
server {
    listen 80;
    server_name your-domain.com;

    # Frontend
    location / {
        root /var/www/retail-inventory;
        try_files $uri $uri/ /index.html;
    }

    # API proxy
    location /api/ {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Static assets
    location /static/ {
        root /var/www/retail-inventory;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## Security Configuration

### 1. Environment Variables
```bash
# /opt/retail-inventory/.env
SPRING_PROFILES_ACTIVE=production
MYSQL_URL=jdbc:mysql://localhost:3306/retail_inventory
MYSQL_USER=inventory_user
MYSQL_PASSWORD=your_secure_password_here
JWT_SECRET=your_jwt_secret_key_minimum_256_bits
ADMIN_EMAIL=admin@yourcompany.com
```

### 2. Database Security
```sql
-- Create production user with limited privileges
CREATE USER 'inventory_prod'@'localhost' IDENTIFIED BY 'very_secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON retail_inventory.* TO 'inventory_prod'@'localhost';
FLUSH PRIVILEGES;

-- Remove sample data in production
DELETE FROM users WHERE username = 'admin';
-- Add your admin user with proper password hash
```

### 3. SSL/HTTPS Setup
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your-domain.com

# Verify auto-renewal
sudo certbot renew --dry-run
```

### 4. Firewall Configuration
```bash
# UFW firewall rules
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

## Monitoring and Logging

### 1. Application Logging
```properties
# application-production.properties
logging.level.com.retailinventory=INFO
logging.file.name=/opt/retail-inventory/logs/application.log
logging.file.max-size=10MB
logging.file.max-history=30
```

### 2. Health Checks
```bash
# Health check endpoint
curl http://localhost:8080/actuator/health

# Create monitoring script
#!/bin/bash
# /opt/retail-inventory/health-check.sh
if curl -f http://localhost:8080/actuator/health > /dev/null 2>&1; then
    echo "Application healthy"
else
    echo "Application unhealthy - restarting"
    sudo systemctl restart retail-inventory
fi
```

### 3. Log Rotation
```bash
# /etc/logrotate.d/retail-inventory
/opt/retail-inventory/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    copytruncate
}
```

## Backup Strategy

### 1. Database Backup
```bash
#!/bin/bash
# /opt/retail-inventory/backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/retail-inventory/backups"
mkdir -p $BACKUP_DIR

mysqldump -u inventory_user -p retail_inventory > $BACKUP_DIR/backup_$DATE.sql
gzip $BACKUP_DIR/backup_$DATE.sql

# Keep only last 30 days
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +30 -delete
```

### 2. Application Files Backup
```bash
# Backup application and config files
tar -czf /opt/backups/retail-inventory-app_$DATE.tar.gz \
    /opt/retail-inventory \
    /etc/systemd/system/retail-inventory.service \
    /etc/nginx/sites-available/retail-inventory
```

## Performance Optimization

### 1. JVM Tuning
```bash
# Update service file
Environment=JAVA_OPTS=-Xmx1g -Xms512m -XX:+UseG1GC
```

### 2. Database Optimization
```sql
-- Optimize MySQL configuration
-- /etc/mysql/mysql.conf.d/mysqld.cnf
[mysqld]
innodb_buffer_pool_size = 1G
query_cache_type = 1
query_cache_size = 64M
```

### 3. Nginx Optimization
```nginx
# Gzip compression
gzip on;
gzip_types text/plain text/css application/json application/javascript;

# Caching
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

## Troubleshooting

### Common Issues

#### Application Won't Start
```bash
# Check logs
sudo journalctl -u retail-inventory -f

# Check Java process
ps aux | grep java

# Check port availability
netstat -tulpn | grep 8080
```

#### Database Connection Issues
```bash
# Test MySQL connection
mysql -u inventory_user -p retail_inventory

# Check MySQL service
sudo systemctl status mysql

# Verify user permissions
mysql -u root -p -e "SHOW GRANTS FOR 'inventory_user'@'localhost'"
```

#### High Memory Usage
```bash
# Monitor JVM memory
jstat -gc $(pgrep java)

# Check system memory
free -h
htop
```

## Scaling Considerations

### 1. Horizontal Scaling
- Use load balancer (Nginx, HAProxy)
- Implement session clustering
- Database read replicas

### 2. Vertical Scaling
- Increase server resources
- Optimize JVM heap size
- Database performance tuning

### 3. Caching
- Redis for session storage
- Application-level caching
- Database query caching

---

**Support**: For deployment issues, check logs and create a GitHub issue with deployment details.
