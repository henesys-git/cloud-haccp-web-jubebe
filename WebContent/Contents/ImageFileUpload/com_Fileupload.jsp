<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID == null || loginID.equals("")){                            		// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");	// 로그인 페이지로 리다이렉트 한다.
	}
%>     
  
<script type="text/javascript">
	var vProd_serial_no="";
	var vOrder_cnt ="";
	var vCustCode = ""; 
	
	var GV_PROCESS_STATUS ="";
	var GV_PROCESS_NEXT ="";
	var GV_ORDER_STATUS =""; 
	var GV_PROCESS_MODIFY="";
	var GV_PROCESS_DELETE="";
	
	$(document).ready(function () {
	});
</script>
 
<div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
	<div style="float: left">
		<form enctype="multipart/form-data" action="<%=Config.this_SERVER_path%>/Contents/FileUpload/FileUpload.jsp" method="POST" id="upload_form">
			파일1: <input type="file" name="file1"/><br>                                            
			파일2: <input type="file" name="file2"/><br>
			파일3: <input type="file" name="file3"/><br>
			파라미터1: <input type="text" name="param1"/><br>선택된 파일 없음
			파라미터2: <input type="text" name="param2"/><br>
			파라미터3: <input type="text" name="param3"/><br>
			<input type="submit" value="파일 전송" /><br>
		</form>
	</div>
</div>
