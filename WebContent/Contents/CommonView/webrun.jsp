<?xml version="1.0" encoding="EUC-KR" ?>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>

<%
String s = request.getParameter("run");

if("exe".equals(s)){
	try{ 
		Runtime.getRuntime().exec("C:\\Windows\\System32\\notepad.exe"); 
	}catch(Exception ex){ 
	} 
}//if
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR" />
<title></title>
</head>
<body>

</body>
</html>