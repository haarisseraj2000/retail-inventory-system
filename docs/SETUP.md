# Setup Guide - Retail Inventory Management System

## Prerequisites

Before setting up the Retail Inventory Management System, ensure you have the following installed:

### Required Software
- **Java 11+**: [Download OpenJDK](https://adoptopenjdk.net/)
- **MySQL 8.0+**: [Download MySQL](https://dev.mysql.com/downloads/mysql/)
- **Maven 3.6+**: [Download Maven](https://maven.apache.org/download.cgi)
- **Git**: [Download Git](https://git-scm.com/)
- **Microsoft Excel** (for VBA integration): Office 365 or Excel 2016+

### Optional Tools
- **MySQL Workbench**: For database management
- **Postman**: For API testing
- **VSCode or IntelliJ IDEA**: For development

## Step-by-Step Installation

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/retail-inventory-system.git
cd retail-inventory-system
```

### 2. Database Setup

#### 2.1 Start MySQL Service
```bash
# Windows
net start mysql80

# macOS (if installed via Homebrew)
brew services start mysql

# Linux
sudo systemctl start mysql
```

#### 2.2 Create Database and User
```sql
-- Connect to MySQL as root
mysql -u root -p

-- Create database
CREATE DATABASE retail_inventory;

-- Create application user (optional but recommended)
CREATE USER 'inventory_user'@'localhost' IDENTIFIED BY 'secure_password_123';
GRANT ALL PRIVILEGES ON retail_inventory.* TO 'inventory_user'@'localhost';
FLUSH PRIVILEGES;

-- Exit MySQL
exit;
```

#### 2.3 Run Database Schema
```bash
# Navigate to database directory
cd database

# Run schema creation
mysql -u root -p retail_inventory < schema.sql

# Run sample data (optional)
mysql -u root -p retail_inventory < sample_data.sql
```

### 3. Backend Configuration

#### 3.1 Update Database Credentials
Edit `backend/src/main/resources/application.properties`:
```properties
# Update these values according to your MySQL setup
spring.datasource.url=jdbc:mysql://localhost:3306/retail_inventory?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=inventory_user
spring.datasource.password=secure_password_123
```

#### 3.2 Build and Run Backend
```bash
# Navigate to backend directory
cd backend

# Clean and install dependencies
mvn clean install

# Run the application
mvn spring-boot:run
```

The backend will start on `http://localhost:8080`

### 4. Frontend Setup

#### 4.1 Serve Frontend Files
You can serve the frontend using any web server:

**Option A: Using Python (if installed)**
```bash
cd frontend
python -m http.server 3000
```
Access at: `http://localhost:3000`

**Option B: Using Node.js (if installed)**
```bash
cd frontend
npx http-server -p 3000
```

**Option C: Open directly in browser**
Open `frontend/index.html` in your web browser

### 5. Excel VBA Integration

#### 5.1 Enable Macros
1. Open Excel
2. Go to File → Options → Trust Center → Trust Center Settings
3. Select "Macro Settings"
4. Choose "Enable all macros" (for development)
5. Click OK

#### 5.2 Create Excel Workbook
1. Create a new Excel workbook
2. Save as "InventoryManager.xlsm" (macro-enabled workbook)
3. Press Alt+F11 to open VBA Editor
4. Insert → Module
5. Copy and paste the VBA code from `excel-integration/VBA_Modules/APIConnection.vba`
6. Insert another module and copy `InventoryManager.vba`

#### 5.3 Create Dashboard Worksheet
1. Create a new worksheet named "Dashboard"
2. Add buttons for each VBA function:
   - Load Products
   - Create Report
   - Export CSV
   - Import CSV
   - Refresh Data
   - Test Connection

3. Link each button to its corresponding VBA procedure

## Verification

### 1. Test Database Connection
```sql
mysql -u inventory_user -p retail_inventory
SELECT COUNT(*) FROM products;
```

### 2. Test Backend API
Open browser and visit:
- `http://localhost:8080/swagger-ui.html` - API Documentation
- `http://localhost:8080/api/products/count` - Should return product count

### 3. Test Frontend
- Open frontend in browser
- Navigate through different sections
- Try adding a new product

### 4. Test Excel Integration
- Open Excel workbook with VBA macros
- Click "Test Connection" button
- Try "Load Products" to import data

## Troubleshooting

### Common Issues

#### Backend won't start
1. Check Java version: `java -version`
2. Check MySQL is running: `mysql -u root -p`
3. Verify database exists: `SHOW DATABASES;`
4. Check application.properties file

#### Database connection failed
1. Verify MySQL service is running
2. Check username/password in application.properties
3. Ensure database `retail_inventory` exists
4. Check firewall settings

#### Excel VBA errors
1. Enable macros in Excel Trust Center
2. Ensure backend is running on localhost:8080
3. Check VBA references: Tools → References → Microsoft XML v6.0

#### Frontend not loading data
1. Check browser console for errors
2. Verify backend is running
3. Check CORS settings in backend
4. Try accessing API directly in browser

### Performance Optimization

#### Database
1. Ensure proper indexes are created (done by schema.sql)
2. Monitor slow query log
3. Consider connection pooling for production

#### Backend
1. Increase JVM heap size if needed: `-Xmx512m`
2. Enable Spring Boot caching for frequently accessed data
3. Use pagination for large datasets

#### Excel
1. Limit data imports to necessary fields only
2. Use background refresh for large datasets
3. Consider using pivot tables for analysis

## Production Deployment

### Database
1. Use environment-specific configuration
2. Set up regular backups
3. Configure SSL connections
4. Use proper user permissions

### Backend
1. Build production JAR: `mvn clean package -Pprod`
2. Use external configuration file
3. Set up logging to files
4. Configure security headers

### Frontend
1. Minify CSS/JS files
2. Use CDN for external libraries
3. Enable GZIP compression
4. Set up HTTPS

## Security Considerations

### Database Security
- Use strong passwords
- Limit user privileges
- Enable SSL connections
- Regular security updates

### Application Security
- Change default JWT secret
- Use HTTPS in production
- Implement rate limiting
- Regular dependency updates

### Excel Security
- Restrict macro execution
- Use signed macros in production
- Validate all data inputs
- Limit API access scope

## Support

For issues or questions:
1. Check this documentation
2. Review error logs
3. Create GitHub issue
4. Contact development team

---

**Next Steps**: See [API_DOCUMENTATION.md](API_DOCUMENTATION.md) for detailed API reference.
