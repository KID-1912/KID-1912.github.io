[General]
SyntaxVersion=2
MacroID=0a3fe0a0-7d6b-4849-b148-534473f253be
[Comment]

[Script]
// 使用：
// headers = CreateObject("Scripting.Dictionary")
// headers("Authorization") = "Bearer abc123xyz"
// response = httpRequest(url, "GET", data, headers)


Function httpRequest(url, method, data, headers)
    Dim xmlhttp
    Set xmlhttp = CreateObject("MSXML2.ServerXMLHTTP")
    
    '处理请求头
    If Not IsNull(headers) Then
        For Each header In headers
            xmlhttp.setRequestHeader header, headers(header)
        Next
    End If
    
    ' 处理请求方法
    If UCase(method) = "GET" Then
        If Not IsNull(data) Then
            url = url & "?" & data
        End If
        xmlhttp.open "GET", url, False
        xmlhttp.send
    ElseIf UCase(method) = "POST" Then
        xmlhttp.open "POST", url, False
        xmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        xmlhttp.send data
    Else
        ' 不支持的请求方法
        MsgBox "Unsupported HTTP method: " & method
        Exit Function
    End If
    
    ' 获取响应内容
    Dim responseText
    responseText = xmlhttp.responseText
    
    ' 获取响应头中的 Content-Type
    Dim contentType
    contentType = xmlhttp.getResponseHeader("Content-Type")
    
    ' 释放对象
    Set xmlhttp = Nothing
    
    ' 返回响应内容
    httpRequest = responseText
 End Function

