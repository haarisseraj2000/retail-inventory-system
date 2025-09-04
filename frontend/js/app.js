// Configuration
// Use different API URL based on environment
const API_BASE_URL = window.location.hostname === 'haarisseraj2000.github.io' 
    ? 'https://demo-api.example.com/api'  // Demo API (will fallback to sample data)
    : 'http://localhost:8080/api';  // Local development

// Global variables
let currentSection = 'dashboard';
let products = [];
let salesChart = null;
let inventoryChart = null;

// Initialize application
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

function initializeApp() {
    // Check if running in demo mode (GitHub Pages)
    const isDemoMode = window.location.hostname === 'haarisseraj2000.github.io';
    
    if (isDemoMode) {
        showDemoNotification();
    }
    
    loadDashboardData();
    initializeCharts();
    setupEventListeners();
}

// Section Navigation
function showSection(sectionName) {
    // Hide all sections
    const sections = document.querySelectorAll('.content-section');
    sections.forEach(section => section.style.display = 'none');
    
    // Show selected section
    document.getElementById(sectionName).style.display = 'block';
    
    // Update navigation
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => link.classList.remove('active'));
    event.target.classList.add('active');
    
    currentSection = sectionName;
    
    // Load section-specific data
    if (sectionName === 'products') {
        loadProducts();
    } else if (sectionName === 'dashboard') {
        loadDashboardData();
    }
}

// Dashboard Functions
function loadDashboardData() {
    // Load statistics
    loadProductCount();
    loadTodaysSales();
    
    // Update charts
    updateCharts();
}

async function loadProductCount() {
    try {
        const response = await fetch(`${API_BASE_URL}/products/count`);
        if (response.ok) {
            const count = await response.json();
            document.getElementById('totalProducts').textContent = count;
        } else {
            console.error('Failed to load product count');
            // Use demo data count
            document.getElementById('totalProducts').textContent = '156';
        }
    } catch (error) {
        console.error('Error loading product count:', error);
        // Use demo data count
        document.getElementById('totalProducts').textContent = '156';
    }
}

function loadTodaysSales() {
    // Simulate today's sales data
    document.getElementById('todaysSales').textContent = '$2,340.50';
    document.getElementById('lowStockItems').textContent = '12';
    document.getElementById('outOfStock').textContent = '3';
}

function initializeCharts() {
    // Sales Chart
    const salesCtx = document.getElementById('salesChart').getContext('2d');
    salesChart = new Chart(salesCtx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Sales ($)',
                data: [1200, 1900, 3000, 2500, 2200, 3000, 2800],
                borderColor: '#3498db',
                backgroundColor: 'rgba(52, 152, 219, 0.1)',
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    // Inventory Chart
    const inventoryCtx = document.getElementById('inventoryChart').getContext('2d');
    inventoryChart = new Chart(inventoryCtx, {
        type: 'doughnut',
        data: {
            labels: ['In Stock', 'Low Stock', 'Out of Stock'],
            datasets: [{
                data: [85, 12, 3],
                backgroundColor: ['#27ae60', '#f39c12', '#e74c3c']
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
}

function updateCharts() {
    if (salesChart && inventoryChart) {
        // Update with real data when API is available
        salesChart.update();
        inventoryChart.update();
    }
}

// Product Management Functions
async function loadProducts() {
    const tableBody = document.getElementById('productsTableBody');
    const searchTerm = document.getElementById('productSearch').value;
    
    try {
        let url = `${API_BASE_URL}/products`;
        if (searchTerm) {
            url += `/search?searchTerm=${encodeURIComponent(searchTerm)}`;
        }
        
        const response = await fetch(url);
        
        if (response.ok) {
            const data = await response.json();
            products = Array.isArray(data) ? data : data.content || [];
            displayProducts(products);
        } else {
            console.error('Failed to load products');
            tableBody.innerHTML = '<tr><td colspan="7" class="text-center text-danger">Failed to load products</td></tr>';
        }
    } catch (error) {
        console.error('Error loading products:', error);
        // Show sample data for demo purposes
        loadSampleProducts();
    }
}

function loadSampleProducts() {
    // Sample data for demonstration
    const sampleProducts = [
        {
            id: 1,
            sku: 'LAPTOP001',
            name: 'Gaming Laptop Pro',
            category: { name: 'Electronics' },
            unitPrice: 1299.99,
            stock: 14,
            isActive: true
        },
        {
            id: 2,
            sku: 'MOUSE001',
            name: 'Wireless Gaming Mouse',
            category: { name: 'Electronics' },
            unitPrice: 89.99,
            stock: 49,
            isActive: true
        },
        {
            id: 3,
            sku: 'SHIRT001',
            name: 'Cotton T-Shirt',
            category: { name: 'Clothing' },
            unitPrice: 24.99,
            stock: 95,
            isActive: true
        },
        {
            id: 4,
            sku: 'PHONE001',
            name: 'iPhone 14 Pro',
            category: { name: 'Electronics' },
            unitPrice: 999.99,
            stock: 17,
            isActive: true
        },
        {
            id: 5,
            sku: 'TABLET001',
            name: 'iPad Pro 12.9"',
            category: { name: 'Electronics' },
            unitPrice: 1099.99,
            stock: 8,
            isActive: true
        },
        {
            id: 6,
            sku: 'HEADPHONE001',
            name: 'AirPods Pro',
            category: { name: 'Electronics' },
            unitPrice: 249.99,
            stock: 3,
            isActive: true
        },
        {
            id: 7,
            sku: 'JEANS001',
            name: 'Mens Denim Jeans',
            category: { name: 'Clothing' },
            unitPrice: 79.99,
            stock: 0,
            isActive: true
        },
        {
            id: 8,
            sku: 'SHOES001',
            name: 'Running Shoes',
            category: { name: 'Sports' },
            unitPrice: 129.99,
            stock: 25,
            isActive: true
        },
        {
            id: 9,
            sku: 'BOOK001',
            name: 'Programming in Java',
            category: { name: 'Books' },
            unitPrice: 49.99,
            stock: 42,
            isActive: true
        },
        {
            id: 10,
            sku: 'PLANT001',
            name: 'Monstera Deliciosa',
            category: { name: 'Home & Garden' },
            unitPrice: 39.99,
            stock: 18,
            isActive: true
        }
    ];
    
    products = sampleProducts;
    displayProducts(products);
}

function displayProducts(products) {
    const tableBody = document.getElementById('productsTableBody');
    
    if (!products || products.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="7" class="text-center">No products found</td></tr>';
        return;
    }
    
    const rows = products.map(product => {
        const stock = product.stock || 0;
        const stockStatus = stock === 0 ? 'Out of Stock' : stock < 10 ? 'Low Stock' : 'In Stock';
        const stockClass = stock === 0 ? 'danger' : stock < 10 ? 'warning' : 'success';
        
        return `
            <tr>
                <td>${product.sku}</td>
                <td>${product.name}</td>
                <td>${product.category ? product.category.name : 'N/A'}</td>
                <td>$${parseFloat(product.unitPrice).toFixed(2)}</td>
                <td>${stock}</td>
                <td><span class="badge bg-${stockClass}">${stockStatus}</span></td>
                <td>
                    <button class="btn btn-sm btn-outline-primary me-1" onclick="editProduct(${product.id})">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-sm btn-outline-danger" onclick="deleteProduct(${product.id})">
                        <i class="fas fa-trash"></i>
                    </button>
                </td>
            </tr>
        `;
    }).join('');
    
    tableBody.innerHTML = rows;
}

function openAddProductModal() {
    document.getElementById('addProductForm').reset();
    const modal = new bootstrap.Modal(document.getElementById('addProductModal'));
    modal.show();
}

async function saveProduct() {
    const form = document.getElementById('addProductForm');
    const formData = new FormData(form);
    
    const product = {
        sku: document.getElementById('productSku').value,
        name: document.getElementById('productName').value,
        description: document.getElementById('productDescription').value,
        unitPrice: parseFloat(document.getElementById('productUnitPrice').value),
        costPrice: parseFloat(document.getElementById('productCostPrice').value),
        minStockLevel: parseInt(document.getElementById('productMinStock').value) || 0,
        maxStockLevel: parseInt(document.getElementById('productMaxStock').value) || 1000,
        reorderPoint: parseInt(document.getElementById('productReorderPoint').value) || 10
    };
    
    try {
        const response = await fetch(`${API_BASE_URL}/products`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(product)
        });
        
        if (response.ok) {
            showAlert('Product added successfully!', 'success');
            bootstrap.Modal.getInstance(document.getElementById('addProductModal')).hide();
            loadProducts(); // Reload products
        } else {
            const error = await response.text();
            showAlert('Failed to add product: ' + error, 'danger');
        }
    } catch (error) {
        console.error('Error adding product:', error);
        showAlert('Error adding product. Please try again.', 'danger');
        
        // For demo purposes, add to sample data
        const newProduct = {
            ...product,
            id: Math.max(...products.map(p => p.id)) + 1,
            category: { name: 'General' },
            stock: 0,
            isActive: true
        };
        products.push(newProduct);
        displayProducts(products);
        bootstrap.Modal.getInstance(document.getElementById('addProductModal')).hide();
        showAlert('Product added successfully! (Demo mode)', 'success');
    }
}

function editProduct(productId) {
    showAlert('Edit functionality will be implemented in the full version.', 'info');
}

async function deleteProduct(productId) {
    if (!confirm('Are you sure you want to delete this product?')) {
        return;
    }
    
    try {
        const response = await fetch(`${API_BASE_URL}/products/${productId}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            showAlert('Product deleted successfully!', 'success');
            loadProducts(); // Reload products
        } else {
            showAlert('Failed to delete product', 'danger');
        }
    } catch (error) {
        console.error('Error deleting product:', error);
        // For demo purposes, remove from sample data
        products = products.filter(p => p.id !== productId);
        displayProducts(products);
        showAlert('Product deleted successfully! (Demo mode)', 'success');
    }
}

// Utility Functions
function showAlert(message, type = 'info') {
    const alertContainer = document.createElement('div');
    alertContainer.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    alertContainer.style.top = '20px';
    alertContainer.style.right = '20px';
    alertContainer.style.zIndex = '9999';
    alertContainer.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alertContainer);
    
    // Auto dismiss after 5 seconds
    setTimeout(() => {
        if (alertContainer.parentNode) {
            alertContainer.parentNode.removeChild(alertContainer);
        }
    }, 5000);
}

function setupEventListeners() {
    // Search functionality
    const productSearch = document.getElementById('productSearch');
    if (productSearch) {
        productSearch.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                loadProducts();
            }
        });
    }
}

// API Health Check
async function checkApiConnection() {
    try {
        const response = await fetch(`${API_BASE_URL}/products/count`);
        return response.ok;
    } catch (error) {
        return false;
    }
}

// Demo mode functions
function showDemoNotification() {
    const notification = document.createElement('div');
    notification.className = 'alert alert-info alert-dismissible fade show position-fixed';
    notification.style.top = '10px';
    notification.style.left = '50%';
    notification.style.transform = 'translateX(-50%)';
    notification.style.zIndex = '9999';
    notification.style.maxWidth = '600px';
    notification.innerHTML = `
        <strong>🎯 Live Demo Mode</strong><br>
        This is a frontend demo with sample data. For the complete system with backend API, 
        <a href="https://github.com/haarisseraj2000/retail-inventory-system" target="_blank" class="alert-link">view the repository</a>.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(notification);
    
    // Auto dismiss after 10 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 10000);
}

// Export functions for global access
window.showSection = showSection;
window.openAddProductModal = openAddProductModal;
window.saveProduct = saveProduct;
window.editProduct = editProduct;
window.deleteProduct = deleteProduct;
window.loadProducts = loadProducts;
