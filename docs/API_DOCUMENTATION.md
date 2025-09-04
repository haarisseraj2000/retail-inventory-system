# API Documentation - Retail Inventory Management System

## Base URL
```
http://localhost:8080/api
```

## Authentication
Currently, the API is open for development. In production, implement JWT authentication.

## Response Format
All API responses follow this format:

### Success Response
```json
{
    "status": "success",
    "data": { ... },
    "message": "Operation completed successfully"
}
```

### Error Response
```json
{
    "status": "error",
    "message": "Error description",
    "details": "Additional error information"
}
```

## Endpoints

### Products API

#### Get All Products
```http
GET /api/products
```

**Parameters:**
- `page` (optional): Page number (default: 0)
- `size` (optional): Page size (default: 20)
- `sort` (optional): Sort field (default: id)

**Response:**
```json
{
    "content": [
        {
            "id": 1,
            "sku": "LAPTOP001",
            "name": "Gaming Laptop Pro",
            "description": "High-performance gaming laptop",
            "unitPrice": 1299.99,
            "costPrice": 899.99,
            "category": {
                "id": 1,
                "name": "Electronics"
            },
            "supplier": {
                "id": 1,
                "name": "Tech Solutions Inc."
            },
            "barcode": "123456789012",
            "weight": 2.5,
            "dimensions": "35x25x2 cm",
            "minStockLevel": 5,
            "maxStockLevel": 100,
            "reorderPoint": 10,
            "isActive": true,
            "createdAt": "2024-01-01T10:00:00",
            "updatedAt": "2024-01-01T10:00:00"
        }
    ],
    "pageable": {
        "page": 0,
        "size": 20,
        "totalElements": 50,
        "totalPages": 3
    }
}
```

#### Get Product by ID
```http
GET /api/products/{id}
```

**Parameters:**
- `id` (required): Product ID

**Response:**
```json
{
    "id": 1,
    "sku": "LAPTOP001",
    "name": "Gaming Laptop Pro",
    ...
}
```

#### Get Product by SKU
```http
GET /api/products/sku/{sku}
```

**Parameters:**
- `sku` (required): Product SKU

#### Get Product by Barcode
```http
GET /api/products/barcode/{barcode}
```

**Parameters:**
- `barcode` (required): Product barcode

#### Search Products
```http
GET /api/products/search?searchTerm={term}
```

**Parameters:**
- `searchTerm` (required): Search term (searches name, SKU, description)

#### Get Products by Category
```http
GET /api/products/category/{categoryId}
```

**Parameters:**
- `categoryId` (required): Category ID

#### Get Products by Price Range
```http
GET /api/products/price-range?minPrice={min}&maxPrice={max}
```

**Parameters:**
- `minPrice` (required): Minimum price
- `maxPrice` (required): Maximum price

#### Create Product
```http
POST /api/products
```

**Request Body:**
```json
{
    "sku": "PHONE001",
    "name": "iPhone 14 Pro",
    "description": "Latest iPhone model",
    "unitPrice": 999.99,
    "costPrice": 699.99,
    "categoryId": 1,
    "supplierId": 2,
    "barcode": "123456789013",
    "weight": 0.2,
    "dimensions": "15x7x1 cm",
    "minStockLevel": 10,
    "maxStockLevel": 200,
    "reorderPoint": 20
}
```

#### Update Product
```http
PUT /api/products/{id}
```

**Parameters:**
- `id` (required): Product ID

**Request Body:** Same as Create Product

#### Delete Product (Soft Delete)
```http
DELETE /api/products/{id}
```

**Parameters:**
- `id` (required): Product ID

#### Get Product Count
```http
GET /api/products/count
```

**Response:**
```json
156
```

### Categories API

#### Get All Categories
```http
GET /api/categories
```

#### Get Category by ID
```http
GET /api/categories/{id}
```

#### Create Category
```http
POST /api/categories
```

**Request Body:**
```json
{
    "name": "Electronics",
    "description": "Electronic devices and accessories",
    "parentCategoryId": null
}
```

#### Update Category
```http
PUT /api/categories/{id}
```

#### Delete Category
```http
DELETE /api/categories/{id}
```

### Suppliers API

#### Get All Suppliers
```http
GET /api/suppliers
```

#### Get Supplier by ID
```http
GET /api/suppliers/{id}
```

#### Create Supplier
```http
POST /api/suppliers
```

**Request Body:**
```json
{
    "name": "Tech Solutions Inc.",
    "contactPerson": "John Smith",
    "email": "john@techsolutions.com",
    "phone": "555-0456",
    "address": "456 Tech Ave",
    "city": "San Francisco",
    "state": "CA",
    "zipCode": "94102",
    "country": "USA",
    "taxId": "12-3456789",
    "paymentTerms": "Net 30"
}
```

#### Update Supplier
```http
PUT /api/suppliers/{id}
```

#### Delete Supplier
```http
DELETE /api/suppliers/{id}
```

### Inventory API

#### Get Current Inventory
```http
GET /api/inventory
```

**Response:**
```json
[
    {
        "productId": 1,
        "sku": "LAPTOP001",
        "productName": "Gaming Laptop Pro",
        "locationId": 1,
        "locationName": "Main Store",
        "currentStock": 14,
        "minStockLevel": 5,
        "reorderPoint": 10,
        "stockStatus": "NORMAL"
    }
]
```

#### Get Inventory by Location
```http
GET /api/inventory/location/{locationId}
```

#### Get Low Stock Items
```http
GET /api/inventory/low-stock
```

#### Get Out of Stock Items
```http
GET /api/inventory/out-of-stock
```

#### Update Stock Level
```http
POST /api/inventory/update-stock
```

**Request Body:**
```json
{
    "productId": 1,
    "locationId": 1,
    "quantity": 50,
    "transactionType": "IN",
    "referenceNumber": "PO-123",
    "notes": "New shipment received"
}
```

### Sales API

#### Get All Sales Orders
```http
GET /api/sales
```

#### Get Sales Order by ID
```http
GET /api/sales/{id}
```

#### Create Sales Order
```http
POST /api/sales
```

**Request Body:**
```json
{
    "customerName": "John Doe",
    "customerEmail": "john@example.com",
    "customerPhone": "555-1234",
    "locationId": 1,
    "paymentMethod": "CARD",
    "items": [
        {
            "productId": 1,
            "quantity": 2,
            "unitPrice": 1299.99
        }
    ]
}
```

#### Get Sales by Date Range
```http
GET /api/sales/date-range?startDate={start}&endDate={end}
```

#### Get Sales Summary
```http
GET /api/sales/summary
```

### Users API

#### Get All Users
```http
GET /api/users
```

#### Get User by ID
```http
GET /api/users/{id}
```

#### Create User
```http
POST /api/users
```

**Request Body:**
```json
{
    "username": "john_manager",
    "email": "john@company.com",
    "password": "securePassword123",
    "firstName": "John",
    "lastName": "Manager",
    "role": "MANAGER"
}
```

#### Update User
```http
PUT /api/users/{id}
```

#### Delete User
```http
DELETE /api/users/{id}
```

### Reports API

#### Inventory Report
```http
GET /api/reports/inventory
```

**Response:**
```json
{
    "reportDate": "2024-01-01",
    "totalProducts": 156,
    "totalValue": 125000.00,
    "lowStockItems": 12,
    "outOfStockItems": 3,
    "topSellingProducts": [...],
    "slowMovingProducts": [...],
    "categoryBreakdown": [...]
}
```

#### Sales Report
```http
GET /api/reports/sales?startDate={start}&endDate={end}
```

#### Profit Report
```http
GET /api/reports/profit?period={month|quarter|year}
```

#### Stock Movement Report
```http
GET /api/reports/stock-movement?productId={id}&startDate={start}&endDate={end}
```

## Error Codes

| HTTP Status | Error Code | Description |
|-------------|------------|-------------|
| 400 | BAD_REQUEST | Invalid request data |
| 401 | UNAUTHORIZED | Authentication required |
| 403 | FORBIDDEN | Insufficient permissions |
| 404 | NOT_FOUND | Resource not found |
| 409 | CONFLICT | Resource already exists |
| 422 | UNPROCESSABLE_ENTITY | Validation failed |
| 500 | INTERNAL_SERVER_ERROR | Server error |

## Rate Limiting
- Default: 1000 requests per hour per IP
- Authenticated users: 5000 requests per hour
- Headers returned:
  - `X-RateLimit-Limit`: Request limit
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Reset time (Unix timestamp)

## Pagination
Endpoints that return lists support pagination:

**Parameters:**
- `page`: Page number (0-based, default: 0)
- `size`: Page size (default: 20, max: 100)
- `sort`: Sort field and direction (e.g., "name,asc")

**Response includes:**
```json
{
    "content": [...],
    "pageable": {
        "page": 0,
        "size": 20,
        "totalElements": 156,
        "totalPages": 8
    }
}
```

## Filtering and Sorting

### Common Filters
- `isActive`: Filter by active status (true/false)
- `createdAfter`: Filter by creation date (ISO 8601)
- `createdBefore`: Filter by creation date (ISO 8601)

### Sorting Options
- `id`: Sort by ID
- `name`: Sort by name
- `createdAt`: Sort by creation date
- `updatedAt`: Sort by update date
- `price`: Sort by price (products only)

**Example:**
```http
GET /api/products?isActive=true&sort=name,asc&page=0&size=50
```

## Swagger Documentation
Interactive API documentation is available at:
```
http://localhost:8080/swagger-ui.html
```

## Testing
Use the provided Postman collection in `/docs/postman/` for API testing.

## WebSocket Events (Future)
Real-time updates for:
- Stock level changes
- New sales orders
- Low stock alerts
- System notifications

## API Versioning
Current version: v1
Future versions will be supported via URL versioning: `/api/v2/`

---

**Next Steps**: See [DEPLOYMENT.md](DEPLOYMENT.md) for production deployment guide.
