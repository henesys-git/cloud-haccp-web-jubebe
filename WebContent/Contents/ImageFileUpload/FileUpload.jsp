<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>

<body>
<center>
<h3>파일 업로드 양식</h3>
<form  enctype="multipart/form-data" action="hcp_EdmsServerServlet" method="POST" id="upload_form">
	<table border="1" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2" align="center"> <h3>파일 업로드 폼 </h3> </td>
		</tr>
		<tr>
			<td > 등록자 </td>
			<td><input type="text" name="name"></td>
		</tr>
		<tr>
			<td> 등록업무(JSP) </td>
			<td><input type="text" name="subject"></td>
		</tr>
		<tr>
			<td> 파일명-1 </td>
			<td><input type="file" name="filename1"></td>
		</tr>
		<tr>
			<td> 파일명-2 </td>
			<td><input type="file" name="filename2"></td>
		</tr>
		<tr>
			<td> 파일명-3 </td>
			<td><input type="file" name="filename3"></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><input type="submit" value="전송"></td>
		</tr>
	</table>
</form>
</center>
</body>
</html>
