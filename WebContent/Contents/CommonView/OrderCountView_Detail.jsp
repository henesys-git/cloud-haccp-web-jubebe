<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String toDate = "";
	
	if(request.getParameter("toDate") != null)
		toDate = request.getParameter("toDate");	
	
	JSONObject jArray = new JSONObject();
    jArray.put("toDate", toDate);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M101S020100E714", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID = "tableOrderCountView";
	
	
%>

 <!-- Theme style -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/css/adminlte.min.css">
	
	<!-- Daterange picker -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.css">
	<!-- summernote -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/summernote/summernote-bs4.css">
	
	<!-- Henesys Icon -->
	<link rel="shotcut icon" type="image/x-icon" href="<%=Config.this_SERVER_path%>/images/henesys.jpg"/>
	<!-- SweetAlert2 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.css">
 	<!-- DataTables -->
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/css/select.bootstrap4.min.css">
    
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/cdnjs/select2.min.css">
  	<!-- Henesys CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/css/henesys.css">
  	
 	<!-- jQuery -->
 	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.js"></script>
 	<!-- Canvas 공통함수 부분 -->
	<script src="<%=Config.this_SERVER_path%>/js/canvas.comm.func.js"></script>
  	
	<!-- DataTables -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables/jquery.dataTables.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/js/dataTables.select.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
	
	<!-- For DataTables Default Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/datatables.custom.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/cdnjs/select2.min.js"></script>
	
	<!-- daterangepicker -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/moment/moment.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.js"></script>
	
	<!-- Henedate -->
	<script src="<%=Config.this_SERVER_path%>/js/setdate.js"></script>

<style>

table{
margin : 0;
padding : 0;
width : 100% !important;
}
#dataTableContainer,
#dataTableContainer>tbody,
#dataTableContainer>tbody>tr,
#dataTableContainer>tbody>tr>td {
  display: block;
}
</style>




<script type="text/javascript">
	
	
$(document).ready(function () {        
    
	setTimeout(function(){
	
	var customOpts = {
   			
			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	   			'targets': [],
   	   			'createdCell':  function (td) {
   	   				$(td).attr('style', 'display: none;');
   				}
   		   	}],
   		   	scrollX : true,
   		    scrollCollapse : true,
   		   	autoWidth : true,
   		   	processing : true,
   		   	order : [[0, "desc"]],
   		 	paging : true,
   		   	pageLength : 10
    	}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
	    		mergeOptions(henePopupTableOpts, customOpts)
	    	);
	
		}, 300);
	
    });
	


  
</script>

<table class='table table-bordered' id="<%=makeGridData.htmlTable_ID%>" style="width:100%;">
 <thead>
	<tr>
			<th>주문번호</th>
			<th>주문일자</th>
			<th>고객사명</th>
			<th>납기일자</th>
			<th>제품명</th>
			<th>주문수량</th>
			<th>비고</th>
	 </tr>
  </thead>
 <tbody id="<%=makeGridData.htmlTable_ID%>_body">		
 </tbody>
</table>