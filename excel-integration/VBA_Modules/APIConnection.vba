' ====================================================================
' API Connection Module for Retail Inventory Management System
' ====================================================================

Option Explicit

' API Configuration
Public Const API_BASE_URL As String = "http://localhost:8080/api"
Public Const TIMEOUT_SECONDS As Long = 30

' API Functions
Public Function GetProducts() As String
    ' Fetch all products from the API
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    
    http.Open "GET", API_BASE_URL & "/products", False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send
    
    If http.Status = 200 Then
        GetProducts = http.responseText
    Else
        GetProducts = ""
        MsgBox "Error fetching products: " & http.Status & " - " & http.statusText, vbCritical
    End If
    
    Set http = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error connecting to API: " & Err.Description, vbCritical
    GetProducts = ""
    Set http = Nothing
End Function

Public Function GetProductById(productId As Long) As String
    ' Fetch specific product by ID
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    
    http.Open "GET", API_BASE_URL & "/products/" & productId, False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send
    
    If http.Status = 200 Then
        GetProductById = http.responseText
    Else
        GetProductById = ""
        If http.Status <> 404 Then
            MsgBox "Error fetching product: " & http.Status & " - " & http.statusText, vbCritical
        End If
    End If
    
    Set http = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error connecting to API: " & Err.Description, vbCritical
    GetProductById = ""
    Set http = Nothing
End Function

Public Function SearchProducts(searchTerm As String) As String
    ' Search products by term
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    
    Dim url As String
    url = API_BASE_URL & "/products/search?searchTerm=" & WorksheetFunction.EncodeURL(searchTerm)
    
    http.Open "GET", url, False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send
    
    If http.Status = 200 Then
        SearchProducts = http.responseText
    Else
        SearchProducts = ""
        MsgBox "Error searching products: " & http.Status & " - " & http.statusText, vbCritical
    End If
    
    Set http = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error connecting to API: " & Err.Description, vbCritical
    SearchProducts = ""
    Set http = Nothing
End Function

Public Function CreateProduct(productJson As String) As String
    ' Create new product
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    
    http.Open "POST", API_BASE_URL & "/products", False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send productJson
    
    If http.Status = 200 Then
        CreateProduct = http.responseText
        MsgBox "Product created successfully!", vbInformation
    Else
        CreateProduct = ""
        MsgBox "Error creating product: " & http.Status & " - " & http.statusText, vbCritical
    End If
    
    Set http = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error connecting to API: " & Err.Description, vbCritical
    CreateProduct = ""
    Set http = Nothing
End Function

Public Function UpdateProduct(productId As Long, productJson As String) As String
    ' Update existing product
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    
    http.Open "PUT", API_BASE_URL & "/products/" & productId, False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send productJson
    
    If http.Status = 200 Then
        UpdateProduct = http.responseText
        MsgBox "Product updated successfully!", vbInformation
    Else
        UpdateProduct = ""
        MsgBox "Error updating product: " & http.Status & " - " & http.statusText, vbCritical
    End If
    
    Set http = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error connecting to API: " & Err.Description, vbCritical
    UpdateProduct = ""
    Set http = Nothing
End Function

Public Function DeleteProduct(productId As Long) As Boolean
    ' Delete (soft delete) product
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    
    http.Open "DELETE", API_BASE_URL & "/products/" & productId, False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send
    
    If http.Status = 200 Then
        DeleteProduct = True
        MsgBox "Product deleted successfully!", vbInformation
    Else
        DeleteProduct = False
        MsgBox "Error deleting product: " & http.Status & " - " & http.statusText, vbCritical
    End If
    
    Set http = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error connecting to API: " & Err.Description, vbCritical
    DeleteProduct = False
    Set http = Nothing
End Function

Public Function GetInventoryReport() As String
    ' Get inventory report data
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    
    http.Open "GET", API_BASE_URL & "/reports/inventory", False
    http.setRequestHeader "Content-Type", "application/json"
    http.Send
    
    If http.Status = 200 Then
        GetInventoryReport = http.responseText
    Else
        GetInventoryReport = ""
        MsgBox "Error fetching inventory report: " & http.Status & " - " & http.statusText, vbCritical
    End If
    
    Set http = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error connecting to API: " & Err.Description, vbCritical
    GetInventoryReport = ""
    Set http = Nothing
End Function

Public Function TestAPIConnection() As Boolean
    ' Test if API is accessible
    Dim http As Object
    Set http = CreateObject("MSXML2.XMLHTTP")
    
    On Error GoTo ErrorHandler
    
    http.Open "GET", API_BASE_URL & "/products/count", False
    http.Send
    
    TestAPIConnection = (http.Status = 200)
    
    If Not TestAPIConnection Then
        MsgBox "API connection failed. Please ensure the backend server is running.", vbExclamation
    End If
    
    Set http = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error testing API connection: " & Err.Description, vbCritical
    TestAPIConnection = False
    Set http = Nothing
End Function
