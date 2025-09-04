' ====================================================================
' Inventory Management Module for Excel Integration
' ====================================================================

Option Explicit

Public Sub LoadProductsToWorksheet()
    ' Load products from API to worksheet
    Dim ws As Worksheet
    Dim jsonResponse As String
    Dim products As Object
    Dim i As Long
    
    ' Get or create Products worksheet
    On Error Resume Next
    Set ws = Worksheets("Products")
    On Error GoTo 0
    
    If ws Is Nothing Then
        Set ws = Worksheets.Add
        ws.Name = "Products"
    End If
    
    ' Clear existing data
    ws.Cells.Clear
    
    ' Add headers
    ws.Range("A1:I1").Value = Array("ID", "SKU", "Name", "Description", "Category", "Unit Price", "Cost Price", "Min Stock", "Reorder Point")
    ws.Range("A1:I1").Font.Bold = True
    ws.Range("A1:I1").Interior.Color = RGB(70, 130, 180)
    ws.Range("A1:I1").Font.Color = RGB(255, 255, 255)
    
    ' Test API connection
    If Not TestAPIConnection() Then
        MsgBox "Cannot connect to API. Loading sample data instead.", vbExclamation
        LoadSampleProductData ws
        Exit Sub
    End If
    
    ' Get products from API
    jsonResponse = GetProducts()
    If jsonResponse = "" Then
        MsgBox "No products found or error occurred.", vbExclamation
        Exit Sub
    End If
    
    ' Parse JSON and populate worksheet
    Set products = ParseProductsJSON(jsonResponse)
    If products Is Nothing Then Exit Sub
    
    For i = 0 To products.Count - 1
        ws.Cells(i + 2, 1).Value = products.Item(i)("id")
        ws.Cells(i + 2, 2).Value = products.Item(i)("sku")
        ws.Cells(i + 2, 3).Value = products.Item(i)("name")
        ws.Cells(i + 2, 4).Value = products.Item(i)("description")
        ws.Cells(i + 2, 5).Value = GetCategoryName(products.Item(i))
        ws.Cells(i + 2, 6).Value = products.Item(i)("unitPrice")
        ws.Cells(i + 2, 7).Value = products.Item(i)("costPrice")
        ws.Cells(i + 2, 8).Value = products.Item(i)("minStockLevel")
        ws.Cells(i + 2, 9).Value = products.Item(i)("reorderPoint")
    Next i
    
    ' Format worksheet
    FormatProductsWorksheet ws
    
    MsgBox "Products loaded successfully! " & products.Count & " products imported.", vbInformation
End Sub

Private Function ParseProductsJSON(jsonText As String) As Object
    ' Simple JSON parser for products array
    On Error GoTo ErrorHandler
    
    ' This is a simplified JSON parser
    ' In a production environment, consider using a proper JSON library
    Dim products As Object
    Set products = CreateObject("Scripting.Dictionary")
    
    ' For demo purposes, return Nothing to trigger sample data
    Set ParseProductsJSON = Nothing
    Exit Function
    
ErrorHandler:
    MsgBox "Error parsing JSON response: " & Err.Description, vbCritical
    Set ParseProductsJSON = Nothing
End Function

Private Function GetCategoryName(product As Object) As String
    ' Extract category name from product object
    On Error Resume Next
    If IsObject(product("category")) Then
        GetCategoryName = product("category")("name")
    Else
        GetCategoryName = "N/A"
    End If
    On Error GoTo 0
End Function

Private Sub LoadSampleProductData(ws As Worksheet)
    ' Load sample data for demonstration
    Dim sampleData As Variant
    sampleData = Array( _
        Array(1, "LAPTOP001", "Gaming Laptop Pro", "High-performance gaming laptop with RTX graphics", "Electronics", 1299.99, 899.99, 5, 10), _
        Array(2, "MOUSE001", "Wireless Gaming Mouse", "Precision wireless gaming mouse", "Electronics", 89.99, 45.99, 20, 30), _
        Array(3, "SHIRT001", "Cotton T-Shirt", "Comfortable cotton t-shirt", "Clothing", 24.99, 12.99, 50, 75), _
        Array(4, "PHONE001", "iPhone 14 Pro", "Latest iPhone with Pro camera system", "Electronics", 999.99, 699.99, 10, 15), _
        Array(5, "JEANS001", "Mens Denim Jeans", "Classic fit denim jeans", "Clothing", 79.99, 39.99, 30, 45) _
    )
    
    Dim i As Long
    For i = 0 To UBound(sampleData)
        ws.Range("A" & (i + 2) & ":I" & (i + 2)).Value = sampleData(i)
    Next i
    
    FormatProductsWorksheet ws
End Sub

Private Sub FormatProductsWorksheet(ws As Worksheet)
    ' Format the products worksheet
    With ws
        ' Auto-fit columns
        .Columns.AutoFit
        
        ' Format price columns as currency
        .Columns("F:G").NumberFormat = "$#,##0.00"
        
        ' Add borders
        .UsedRange.Borders.LineStyle = xlContinuous
        .UsedRange.Borders.Weight = xlThin
        
        ' Freeze first row
        .Range("A2").Select
        ActiveWindow.FreezePanes = True
        
        ' Select first cell
        .Range("A1").Select
    End With
End Sub

Public Sub CreateInventoryReport()
    ' Create inventory report worksheet
    Dim ws As Worksheet
    Dim reportDate As String
    
    reportDate = Format(Now(), "yyyy-mm-dd")
    
    ' Create new worksheet
    Set ws = Worksheets.Add
    ws.Name = "Inventory_Report_" & Format(Now(), "mmdd")
    
    ' Add report header
    ws.Range("A1").Value = "RETAIL INVENTORY REPORT"
    ws.Range("A1").Font.Size = 16
    ws.Range("A1").Font.Bold = True
    
    ws.Range("A2").Value = "Generated: " & Format(Now(), "yyyy-mm-dd hh:mm:ss")
    ws.Range("A2").Font.Italic = True
    
    ' Add column headers
    ws.Range("A4:J4").Value = Array("SKU", "Product Name", "Category", "Unit Price", "Current Stock", "Min Stock", "Reorder Point", "Stock Status", "Stock Value", "Action Required")
    ws.Range("A4:J4").Font.Bold = True
    ws.Range("A4:J4").Interior.Color = RGB(70, 130, 180)
    ws.Range("A4:J4").Font.Color = RGB(255, 255, 255)
    
    ' Sample inventory data
    Dim inventoryData As Variant
    inventoryData = Array( _
        Array("LAPTOP001", "Gaming Laptop Pro", "Electronics", 1299.99, 14, 5, 10, "Normal", "=D5*E5", "None"), _
        Array("MOUSE001", "Wireless Gaming Mouse", "Electronics", 89.99, 49, 20, 30, "Normal", "=D6*E6", "None"), _
        Array("SHIRT001", "Cotton T-Shirt", "Clothing", 24.99, 7, 50, 75, "Low Stock", "=D7*E7", "Reorder"), _
        Array("PHONE001", "iPhone 14 Pro", "Electronics", 999.99, 0, 10, 15, "Out of Stock", "=D8*E8", "Urgent Reorder"), _
        Array("JEANS001", "Mens Denim Jeans", "Clothing", 79.99, 30, 30, 45, "At Minimum", "=D9*E9", "Consider Reorder") _
    )
    
    Dim i As Long
    For i = 0 To UBound(inventoryData)
        ws.Range("A" & (i + 5) & ":J" & (i + 5)).Value = inventoryData(i)
        
        ' Color code stock status
        Dim stockStatus As String
        stockStatus = inventoryData(i)(7)
        
        Select Case stockStatus
            Case "Out of Stock"
                ws.Range("H" & (i + 5)).Interior.Color = RGB(255, 0, 0) ' Red
                ws.Range("H" & (i + 5)).Font.Color = RGB(255, 255, 255)
            Case "Low Stock"
                ws.Range("H" & (i + 5)).Interior.Color = RGB(255, 165, 0) ' Orange
            Case "At Minimum"
                ws.Range("H" & (i + 5)).Interior.Color = RGB(255, 255, 0) ' Yellow
            Case "Normal"
                ws.Range("H" & (i + 5)).Interior.Color = RGB(0, 255, 0) ' Green
        End Select
    Next i
    
    ' Format the report
    With ws
        .Columns.AutoFit
        .Columns("D").NumberFormat = "$#,##0.00"
        .Columns("I").NumberFormat = "$#,##0.00"
        .UsedRange.Borders.LineStyle = xlContinuous
        .UsedRange.Borders.Weight = xlThin
        .Range("A4").Select
        ActiveWindow.FreezePanes = True
        .Range("A1").Select
    End With
    
    MsgBox "Inventory report created successfully!", vbInformation
End Sub

Public Sub ExportProductsToCSV()
    ' Export products data to CSV file
    Dim ws As Worksheet
    Dim filePath As String
    Dim fileDialog As FileDialog
    
    ' Check if Products worksheet exists
    On Error Resume Next
    Set ws = Worksheets("Products")
    On Error GoTo 0
    
    If ws Is Nothing Then
        MsgBox "Products worksheet not found. Please load products first.", vbExclamation
        Exit Sub
    End If
    
    ' Get file path from user
    Set fileDialog = Application.FileDialog(msoFileDialogSaveAs)
    fileDialog.Title = "Export Products to CSV"
    fileDialog.FilterIndex = 1
    fileDialog.Filters.Add "CSV Files", "*.csv"
    fileDialog.InitialFileName = "products_" & Format(Now(), "yyyymmdd") & ".csv"
    
    If fileDialog.Show = -1 Then
        filePath = fileDialog.SelectedItems(1)
        
        ' Save as CSV
        ws.Copy
        ActiveWorkbook.SaveAs Filename:=filePath, FileFormat:=xlCSV
        ActiveWorkbook.Close SaveChanges:=False
        
        MsgBox "Products exported to: " & filePath, vbInformation
    End If
End Sub

Public Sub ImportProductsFromCSV()
    ' Import products from CSV file
    Dim filePath As String
    Dim fileDialog As FileDialog
    Dim ws As Worksheet
    
    ' Get file path from user
    Set fileDialog = Application.FileDialog(msoFileDialogFilePicker)
    fileDialog.Title = "Import Products from CSV"
    fileDialog.FilterIndex = 1
    fileDialog.Filters.Add "CSV Files", "*.csv"
    
    If fileDialog.Show = -1 Then
        filePath = fileDialog.SelectedItems(1)
        
        ' Create or get Import worksheet
        On Error Resume Next
        Set ws = Worksheets("Import")
        On Error GoTo 0
        
        If ws Is Nothing Then
            Set ws = Worksheets.Add
            ws.Name = "Import"
        End If
        
        ' Import CSV data
        With ws.QueryTables.Add(Connection:="TEXT;" & filePath, Destination:=ws.Range("A1"))
            .TextFileParseType = xlDelimited
            .TextFileCommaDelimiter = True
            .Refresh
        End With
        
        MsgBox "Products imported from: " & filePath & vbCrLf & "Please review the data in the Import worksheet.", vbInformation
    End If
End Sub

Public Sub RefreshData()
    ' Refresh all data from API
    If MsgBox("This will refresh all product data from the server. Continue?", vbYesNo + vbQuestion) = vbYes Then
        LoadProductsToWorksheet
        CreateInventoryReport
    End If
End Sub
