<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>

<!-- 
주문량조회
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
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
section.content{
	margin : 0;
	padding: 0;
	width : 100% !important;
	display : block;
}
</style>
<script>
	var toDate = "";
	
	$(document).ready(function () {
		
		new SetSingleDate2("", "#OrderDate", 0);
		
       	toDate = $('#OrderDate').val();
        
       	fn_ChangeDate(toDate);
		
		 // 날짜 변경 시 새로고침
	    $('#OrderDate').change(function() {
	    toDate = $('#OrderDate').val();
        fn_ChangeDate(toDate);
        });
		
	});
	
	 function fn_ChangeDate(toDate) {
	       
	        $.ajax({
	            type: "POST",
	            url: "<%=Config.this_SERVER_path%>/Contents/CommonView/OrderCountView_Detail.jsp",
	            data : "toDate=" + toDate,
	            beforeSend: function () {
	            $("#MainInfo_List_contents").children().remove();
	            },
	            success: function (html) {
	            $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
	            }
	        });
	        
	    }
	
</script>

<section class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-12">
				<div class="card card-info">
                    <div class="card-header"> 
                     <h3 class="card-title">주문량 조회</h3>
                     	<div class="card-tools">
          	  				<div class="input-group input-group-sm" id="dateParent">
          	  				<input type="text" class="form-control float-right" id="OrderDate" autocomplete=off>
          	  	  		    </div>
          				</div>
                    </div> <!-- card-header -->
                    <div class="card-body" id="MainInfo_List_contents"> </div> <!-- card-body  -->
                    <div class="card-tools">
                    	<button id="btn_Canc"  class="btn btn-info" style="float:right;margin: 0 10px 10px 0;" onclick="window.close();">닫기</button>
                    </div>
				</div> <!-- card card-info -->
			</div> <!-- col-md-6 -->
		</div> <!-- row -->
	</div> <!-- container-fluid -->
</section> <!-- content -->