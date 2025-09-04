# Retail Inventory Management System

[![Live Demo](https://img.shields.io/badge/Live%20Demo-Click%20Here-green)](https://your-username.github.io/retail-inventory-system)
[![Java](https://img.shields.io/badge/Java-11%2B-orange)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-2.7.0-brightgreen)](https://spring.io/projects/spring-boot)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)](https://www.mysql.com/)
[![Excel VBA](https://img.shields.io/badge/Excel%20VBA-Enabled-yellow)](https://docs.microsoft.com/en-us/office/vba/excel/concepts/excel-vba-reference)

A comprehensive retail inventory management system built with Java Spring Boot, MySQL database, and Excel VBA integration. This system provides complete inventory tracking, sales management, supplier management, and automated reporting capabilities.

## 🚀 Features

### Core Functionality
- **Product Management**: Add, update, delete, and search products
- **Inventory Tracking**: Real-time stock levels and movement history
- **Category Management**: Organize products by categories and subcategories
- **Supplier Management**: Maintain supplier information and purchase orders
- **Sales Management**: Process sales and track revenue
- **User Management**: Role-based access control (Admin, Manager, Staff)

### Advanced Features
- **Low Stock Alerts**: Automated notifications for inventory replenishment
- **Barcode Support**: Generate and scan product barcodes
- **Reporting Dashboard**: Visual analytics and insights
- **Excel Integration**: Import/Export data and automated reports via VBA
- **Multi-location Support**: Track inventory across multiple stores/warehouses
- **Audit Trail**: Complete transaction history and logging

## 🛠️ Technology Stack

- **Backend**: Java 11+, Spring Boot 2.7.0, Spring Security, Spring Data JPA
- **Database**: MySQL 8.0
- **Frontend**: HTML5, CSS3, JavaScript (ES6+), Bootstrap 5
- **Excel Integration**: VBA Macros for automated reporting and data management
- **Build Tool**: Maven
- **Version Control**: Git

## 📊 Database Schema

The system includes the following main entities:
- Products
- Categories
- Suppliers
- Inventory Transactions
- Sales Orders
- Users
- Locations

## 🖼️ Screenshots

### Dashboard
![Dashboard](docs/images/dashboard.png)

### Product Management
![Product Management](docs/images/product-management.png)

### Inventory Report
![Inventory Report](docs/images/inventory-report.png)

## 🚀 Quick Start

### Prerequisites
- Java 11 or higher
- MySQL 8.0
- Maven 3.6+
- Microsoft Excel (for VBA integration)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/retail-inventory-system.git
   cd retail-inventory-system
   ```

2. **Setup MySQL Database**
   ```sql
   CREATE DATABASE retail_inventory;
   ```
   Run the SQL scripts in `database/schema.sql`

3. **Configure Application**
   Update `backend/src/main/resources/application.properties` with your database credentials

4. **Build and Run**
   ```bash
   cd backend
   mvn clean install
   mvn spring-boot:run
   ```

5. **Access the Application**
   - Web Interface: http://localhost:8080
   - API Documentation: http://localhost:8080/swagger-ui.html

### Excel VBA Setup
1. Enable macros in Excel
2. Open `excel-integration/InventoryManager.xlsm`
3. Configure API endpoint in VBA code
4. Use the Excel interface for reporting and data management

## 📖 API Documentation

The REST API provides endpoints for:
- `/api/products` - Product management
- `/api/inventory` - Inventory operations
- `/api/sales` - Sales processing
- `/api/suppliers` - Supplier management
- `/api/reports` - Generate reports

Complete API documentation is available at `/swagger-ui.html` when the application is running.

## 🔧 Configuration

### Database Configuration
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/retail_inventory
spring.datasource.username=your_username
spring.datasource.password=your_password
```

### Excel VBA Configuration
Update the API base URL in the VBA modules:
```vba
Const API_BASE_URL = "http://localhost:8080/api"
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Developer**: Your Name
- **Email**: your.email@example.com
- **GitHub**: [@your-username](https://github.com/your-username)

## 🙏 Acknowledgments

- Spring Boot community for excellent framework
- Bootstrap team for responsive UI components
- MySQL for reliable database management
- Excel VBA community for integration examples

## 📞 Support

If you have any questions or need help with setup, please:
1. Check the [documentation](docs/)
2. Create an [issue](https://github.com/your-username/retail-inventory-system/issues)
3. Contact the development team

---

⭐ **Star this repository if you found it helpful!**
