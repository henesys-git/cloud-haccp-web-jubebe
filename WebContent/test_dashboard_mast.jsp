<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@0.7.0"></script>

<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/css/checklist_alarm.css">
<!-- Font Awesome -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/fontawesome-free/css/all.min.css">
	<!-- Ionicons -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/ionicons-2.0.1/css/ionicons.min.css">
	<!-- Tempusdominus Bbootstrap 4 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/tempusdominus-bootstrap-4/css/tempusdominus-bootstrap-4.min.css">
	<!-- iCheck -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/icheck-bootstrap/icheck-bootstrap.min.css">
	<!-- JQVMap -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jqvmap/jqvmap.min.css">
	<!-- Theme style -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/css/adminlte.min.css">
	<!-- overlayScrollbars -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
	<!-- Daterange picker -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.css">
	<!-- summernote -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/summernote/summernote-bs4.css">
	<!-- Google Font: Source Sans Pro -->
	<link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
	<!-- Henesys Icon -->
	<link rel="shotcut icon" type="image/x-icon" href="<%=Config.this_SERVER_path%>/images/henesys.jpg"/>
	<!-- SweetAlert2 -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.css">
 	<!-- DataTables -->
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/css/responsive.bootstrap4.min.css">
    <link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/css/select.bootstrap4.min.css">
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/cdnjs/select2.min.css">
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-buttons/css/buttons.bootstrap4.min.css">
  	<!-- FullCalendar CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/fullcalendar-5.5.0/lib/main.css">
  	<!-- Henesys CSS -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/css/henesys.css">
  	<!-- TimePicker -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-timepicker/jquery.timepicker.css">
  	<!-- datetimepicker -->
  	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datetimepicker/css/bootstrap-datetimepicker.css">
  		<!-- Date Picker -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css"></link>
	
	
	<!-- jQuery -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery/jquery.js"></script>
	<!-- jQuery UI 1.11.4 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-ui/jquery-ui.js"></script>
	
	<!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
	<script>
		$.widget.bridge('uibutton', $.ui.button)
	</script>
	
	<!-- Bootstrap 4 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
	<!-- ChartJS -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/chart.js/Chart.min.js"></script>
	<!-- Sparkline -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sparklines/sparkline.js"></script>
	<!-- JQVMap -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jqvmap/jquery.vmap.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jqvmap/maps/jquery.vmap.usa.js"></script>
	<!-- jQuery Knob Chart -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-knob/jquery.knob.min.js"></script>
	<!-- daterangepicker -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/moment/moment.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/daterangepicker/daterangepicker.js"></script>
	<!-- Tempusdominus Bootstrap 4 -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/tempusdominus-bootstrap-4/js/tempusdominus-bootstrap-4.min.js"></script>
	<!-- Summernote -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/summernote/summernote-bs4.min.js"></script>
	<!-- overlayScrollbars -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
	<!-- AdminLTE App -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/dist/js/adminlte.js"></script>
	<!-- DataTables -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables/jquery.dataTables.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-bs4/js/dataTables.bootstrap4.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-select/js/dataTables.select.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/dataTables.responsive.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-responsive/js/responsive.bootstrap4.min.js"></script>
	<!-- DataTables Buttons -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-buttons/js/dataTables.buttons.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-buttons/js/buttons.html5.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datatables-buttons/js/buttons.print.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jszip/jszip.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/pdfmake/pdfmake.min.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/pdfmake/vfs_fonts.js"></script>
	<!-- For Date Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/setdate.js"></script>
	<!-- For DataTables Default Setting -->
	<script src="<%=Config.this_SERVER_path%>/js/datatables.custom.js"></script>
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/cdnjs/select2.min.js"></script>
	<!-- Customized Modal Windows -->
	<script src="<%=Config.this_SERVER_path%>/js/modal.custom.js"></script>
	<!-- 데이터 처리 관련 기능 -->
	<script src="<%=Config.this_SERVER_path%>/js/data_control.js"></script>
	<!-- FullCalendar -->
	<script src="<%=Config.this_SERVER_path%>/fullcalendar-5.5.0/lib/main.js"></script>
	<!-- Canvas 공통함수 부분 -->
	<script src="<%=Config.this_SERVER_path%>/js/canvas.comm.func.js"></script>
	<!-- SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/sweetalert2/sweetalert2.min.js"></script>
	<!-- Customized SweetAlert -->
	<script src="<%=Config.this_SERVER_path%>/js/sweetalert.custom.js"></script>
	<!-- 환경 설정 -->
	<script src="<%=Config.this_SERVER_path%>/js/config.js"></script>
	<!-- 점검표 -->
	<script src="<%=Config.this_SERVER_path%>/js/checklist.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/checklist.builder.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/checklist.common.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/checklist.sign.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/checklist.modal.util.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/checklist.modal.js"></script>
	<!-- 숫자 관련 기능 -->
	<script src="<%=Config.this_SERVER_path%>/js/hene.number.js"></script>
	<!-- TimePicker -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/jquery-timepicker/jquery.timepicker.js"></script>
	<!-- JavaScript 공통 함수 -->
    <script src="<%=Config.this_SERVER_path%>/js/common/common.func.js"></script>
<%-- 	<!-- 사용자 권한 별 버튼 관리 -->
    <script src="<%=Config.this_SERVER_path%>/js/auth-button/auth-button.js"></script> --%>
	<!-- Main Contents Setting -->
	<%-- <script src="<%=Config.this_SERVER_path%>/js/content.comm.func.js"></script> --%>
    <!-- datetimepicker -->
    <script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/datetimepicker/js/bootstrap-datetimepicker.js"></script>
	<!-- RowsGroup -->
	<script src="<%=Config.this_SERVER_path%>/js/dataTables.rowsGroup.js"></script>
	<!-- Sidebar -->
	<script src="<%=Config.this_SERVER_path%>/js/components/sidebar.js"></script>
	<!-- Product -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/product.js"></script>
	<!-- User -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/user.js"></script>
	<!-- ChecklistInfo -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/ChecklistInfo.js"></script>
	<!-- CCP Sign-->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/CCPSign.js"></script>
	<!-- itemList-->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/itemList.js"></script>
	<!-- ChecklistData-->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/ChecklistData.js"></script>
	<!-- sensor-->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/sensor.js"></script>
	<!-- commonCode-->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/commonCode.js"></script>
	<!-- menu-->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/menu.js"></script>
	<!-- documentData -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/DocumentData.js"></script>
	<!-- limit -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/limit.js"></script>
	<!-- UploadChecklistData -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/UploadChecklistData.js"></script>
	<!-- MES -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/order.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/productStorage.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/rawmaterialStorage.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/chulhaInfo.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/productionPlan.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/productionResult.js"></script>
	<!-- raw material -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/rawmaterial.js"></script>
	<!-- customer -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/customer.js"></script>
	<!--bootstrap-datepicker -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.js"></script>  
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap-datepicker/dist/locales/bootstrap-datepicker.ko.min.js" charset="UTF-8"></script>
	<%-- <script src="<%=Config.this_SERVER_path%>/js/ottogiDashboard.js"> --%>
<script>

var setCount = 0;

	$(document).ready(function () {
		//getData4();
		//getData5();
		
		inTerVal = setInterval(function() {
	   		
	   		if(Number(setCount)%2 == 0 ) {
	   			<%-- $.post("<%=Config.this_SERVER_path%>/testDashBoard.jsp", function(html) {
	   	 	    	$("#parent_page4").hide().html(html).fadeIn(100);
	   	 	    	$("#parent_page5").attr("style", "display:none");
	   	 		}) --%>
	   	 		
	   	 	$.ajax({
     	        type: "POST",
     	        url: "<%=Config.this_SERVER_path%>/test_dashboard.jsp",
     	        success: function (html) {
     	            $("#parent_page4").hide().html(html).fadeIn(100);
     	            //$("#div2").attr("style", "display:none");
     	           	//$("#div1").attr("style", "display:block");
     	        }
     	    });
	   	 	
	   		}
	   		
	   		else if(Number(setCount)%2 == 1 ){
	   			<%-- $.post("<%=Config.this_SERVER_path%>/testDashBoard2.jsp", function(html) {
	   	  	    	$("#parent_page5").hide().html(html).fadeIn(100);
	   	  	   		$("#parent_page4").attr("style", "display:none");
	   	  		}) --%>
	   			
	   			$.ajax({
	     	        type: "POST",
	     	        url: "<%=Config.this_SERVER_path%>/test_dashboard2.jsp",
	     	        success: function (html) {
	     	            $("#parent_page4").hide().html(html).fadeIn(100);
	     	            //$("#div1").attr("style", "display:none");
	     	            //$("#div2").attr("style", "display:block");
	     	        }
	     	    });
	   		}
	   		 
	   		setCount += 1;
	   		
	   		console.log(setCount);
	   		
		}, 5000);
		
		
		
	});
	
	function getData4() {
		$.post("<%=Config.this_SERVER_path%>/Contents/testDashBoard.jsp", function(html) {
 	    	$("#parent_page4").hide().html(html).fadeIn(100);
 		})
 	}
	
	function getData5() {
      	$.post("<%=Config.this_SERVER_path%>/Contents/testDashBoard2.jsp", function(html) {
  	    	$("#parent_page5").hide().html(html).fadeIn(100);
  		})
  	}
	
</script>

<div id="dashboard-wrapper">
	<div class="row" id = "div1">
		<div class="col-lg-12" id="parent_page4"></div>
	</div>
	<!-- <div class="row" id = "div2">
		<div class="col-lg-12" id="parent_page5"></div>	
	</div> -->
</div>