<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%
	Config.this_SERVER_path = request.getContextPath();
	String loginID, login_name, bizNo = "";
	
	if(session.getAttribute("login_id") != null){
		loginID = session.getAttribute("login_id").toString();
		login_name = session.getAttribute("login_name").toString();
		bizNo = session.getAttribute("bizNo").toString();
	}
	else {
		loginID = "";
		login_name = "";
		bizNo = "";
		response.sendRedirect("index.jsp" + "?invalid_login=yy"); 
	}
	
	String userGroupCode = "GRCD001";
%>

<!DOCTYPE html>
<html style="height:auto">
<head>
	<meta charset="utf-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1">
  	<meta http-equiv="x-ua-compatible" content="ie=edge">
  	
  	<title>SMART HACCP SYSTEM Main</title>
  	
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
  	<!-- Global Configuration -->
  	<script>
  		// server root path
  		const heneServerPath = '<%=Config.this_SERVER_path%>';
  		const loggedUserId = '<%=loginID%>';
		const userGroupCode = '<%=userGroupCode%>';
		const heneBizNo = '<%=bizNo%>';
		
		console.log('heneServerPath: ' + heneServerPath);
		console.log('loggedUserId: ' + loggedUserId);
  	</script>
</head>
<style>
	.swal-button-container {
 		float: right !important;
	}
	
 	.content-wrapper {
 		margin-left : 0px;
	}
	
 	.modal-dialog.modal-checklist {
  		text-align: center;
	}

	@media screen and (min-width: 768px) {
		.modal.modal-checklist:before {
		  	display: inline-block;
		  	vertical-align: middle;
			content: " ";
			height: 100%;
		}
	}

	.modal-dialog.modal-checklist {
	  	display: inline-block;
	  	text-align: left;
	  	vertical-align: middle; 
	}
</style>
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">
		 
		<!-- Navbar -->
		<nav class="main-header navbar navbar-expand navbar-white navbar-light">
			<!-- Left navbar links -->
			<ul class="navbar-nav">
				<li class="nav-item">
					<a class="nav-link" data-widget="pushmenu" href="#" role="button">
						<i class="fas fa-bars"></i>
					</a>
				</li>
				<li class="nav-item d-none d-sm-inline-block">
					<a class="nav-link" href="MasterMainPage.jsp" role="button">
					   <i class="fas fa-home"></i>
					</a>
				</li>
				<!-- 
				<li class="nav-item d-none d-sm-inline-block">
					 <a class="nav-link" onclick="pop_fn_WinUpdateKakaoAlarmUser_View()" role="button">
					 	<i class="fas fa-clock"></i>
					 </a>
				</li>
				<li class="nav-item d-none d-sm-inline-block">
					<div class="nav-link">
	            		<div class="custom-control custom-switch">
	                    	<input type="checkbox" class="custom-control-input" id="customSwitch1">
	                       	<label class="custom-control-label" for="customSwitch1"></label>
	                    </div>
					</div>
	            </li>
				-->
			</ul> 
			
			<!-- Right navbar links -->
			<ul class="navbar-nav ml-auto">
				<li class="nav-item dropdown">
					<span style="color:black;"> <%=login_name%>님 환영합니다 </span>			
				</li>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<!-- <li>
					<button class="btn btn-secondary btn-circle btn-sm align-middle" onclick="pop_fn_WinUpdateUserPW_View()">
						<i class="fa fa-wrench"></i>
					</button>
				</li>
				&nbsp;&nbsp;&nbsp; -->
				<li>
					<button class="btn btn-secondary btn-circle btn-sm align-middle" onclick="logout(this)">
						<i class="fa fa-sign-out-alt white"></i>
					</button>
				</li>
				&nbsp;&nbsp;&nbsp;
			</ul>
		</nav>
		<!-- /.navbar -->		
 		
 
		<aside class="main-sidebar sidebar-dark-primary elevation-4">
			<a href="#" class="brand-link">
				<span class="brand-text font-weight-light">
					&nbsp;&nbsp;&nbsp;&nbsp;
					SMART HACCP SYSTEM
				</span>
			</a>
			<div class="sidebar">
				<nav class="mt-2" id="sidebar-nav-id">
				</nav>
			</div>
		</aside>
		
		<div class="content-wrapper">
			<div id="ContentPlaceHolder1"></div>
			<div id="ContentPlaceHolder2"></div>
		</div>
	    <!-- /.content-wrapper -->
	   	<footer class="main-footer">
		    <strong>Copyright &copy; 2021 <a href="http://www.henesys.co.kr">Henesys</a>.</strong>
		    All rights reserved.
		    <div class="float-right d-none d-sm-inline-block">
		      <b>Version</b> 1.0.0
		    </div>
	  	</footer>
		
	  	<!-- Control Sidebar -->
	  	<aside class="control-sidebar control-sidebar-dark">
	    	<!-- Control sidebar content goes here -->
	  	</aside>
	  	<!-- /.control-sidebar -->
	</div>
	<!-- ./wrapper -->
	
    <!-- 1st Modal form -->
	<div class="modal fade" id="modalReport" tabindex="-1" role="dialog" 
		 					aria-labelledby="modalReport_Title" aria-hidden="true">
    	<div class="modal-dialog modal-dialog-scrollable" id="modalDialogId">
    		<div class="modal-content">
        		<div class="modal-header">
        			<h4 class="modal-title" id="modalReport_Title"></h4>
            		<button type="button" class="close" data-dismiss="modal">
            			<span aria-hidden="true">&times;</span>
            			<span class="sr-only">Close</span>
            		</button>
          		</div>
          		<div class="modal-body" id="ReportNote">
        		</div>
		        <div class="modal-footer" id="modal-footerq">
		        </div>
        	</div>
      	</div>
    </div>
    <!-- end of 1st modal -->
    
	<!-- 2nd Modal form -->
	<div class="modal fade" id="modalReport2" tabindex="-1" role="dialog" 
		 					aria-labelledby="modalReport_Title2" aria-hidden="true">
    	<div class="modal-dialog modal-dialog-scrollable" id="modalDialogId2">
    		<div class="modal-content">
        		<div class="modal-header">
        			<h4 class="modal-title" id="modalReport_Title2"></h4>
            		<button type="button" class="close" data-dismiss="modal">
            			<span aria-hidden="true">&times;</span>
            			<span class="sr-only">Close</span>
            		</button>
          		</div>
          		<div class="modal-body" id="ReportNote2">
        		</div>
		        <div class="modal-footer" id="modal-footerq2">
		        </div>
        	</div>
      	</div>
    </div>
    <!-- end of 2nd modal -->
    
    <!-- 3rd Modal form -->
	<div class="modal fade" id="modalReport3" tabindex="-1" role="dialog" 
		 					aria-labelledby="modalReport_Title3" aria-hidden="true">
    	<div class="modal-dialog modal-dialog-scrollable" id="modalDialogId3">
    		<div class="modal-content">
        		<div class="modal-header">
        			<h4 class="modal-title" id="modalReport_Title3"></h4>
            		<button type="button" class="close" data-dismiss="modal">
            			<span aria-hidden="true">&times;</span>
            			<span class="sr-only">Close</span>
            		</button>
          		</div>
          		<div class="modal-body" id="ReportNote3">
        		</div>
		        <div class="modal-footer" id="modal-footerq3">
		        </div>
        	</div>
      	</div>
    </div>
    <!-- end of 3rd modal -->
	
<!-- 	         
2차 Pop Up 위 Pop Up 띄우는 DIV 시작
 -->
    <div class="modal collapse" role="dialog" id="modalReport_nd">
		<div class="modal-dialog">
    		<div class="modal-content panel panel-default">
                <div class="modal-header panel-heading">
                	<strong><span class="modal-title" id="modalReport_Title_nd" ></span></strong>
                    <a type="button" class="close" data-dismiss="modal" onclick="$('#modalReport_nd').hide()">
                    <span aria-hidden="true">&times;</span><span class="sr-only">Close</span></a>
                </div>
                <div class="modal-body panel-body">
					<div id="ReportNote_nd" class="modal-body panel-body" style="width: 100%;float:left">
					</div>
                </div>
                <div class="modal-footer justify-content-between">
	            	<!-- 
	            	<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
	            	<button type="button" class="btn btn-primary">저장</button> 
	            	-->
	            </div>
			</div>
		</div>
    </div>
<!-- 	         
2차 Pop Up 위 Pop Up 띄우는 DIV 끝
 -->	

<!-- 	         
2차 Pop Up_2 위 Pop Up 띄우는 DIV 시작
 -->
    <div class="modal collapse" role="dialog" id="modalReport_nd_2">
		<div class="modal-dialog">
    		<div class="modal-content panel panel-default">
                <div class="modal-header panel-heading">
                    <a type="button" class="close" data-dismiss="modal" onclick="$('#modalReport_nd_2').hide()">
                        <span aria-hidden="true">&times;</span><span class="sr-only">Close</span></a>
                    	<strong><span class="modal-title" id="modalReport_Title_nd_2" ></span></strong>
                </div>
                <div class="modal-body panel-body">
					<div id="ReportNote_nd_2" class="modal-body panel-body">
					</div>
                </div>
			</div>
		</div>
    </div>
<!-- 	         
2차 Pop Up_2 위 Pop Up 띄우는 DIV 끝
 -->	 
    <div class="modal alert collapse" id="modalFrame"  role="dialog"  style="modal:true; closeOnEscape:false; width: 100%; margin: 0 auto text-align:left ">
		<div class="modal-dialog" style="width: 100%; margin: 0 auto text-align:left ">
			<div class="modal-content panel panel-default">
				<div class="modal-header panel-heading">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<strong><span class="modal-title" id="modalFrame_Title" ></span></strong>
                </div>
				<div class="modal-body panel-body" style="height: 500px" >
					<iframe id="modalFrame_iframe" width="100%" height="100%" frameborder="0" ></iframe>
				</div>
			</div>
		</div>

    </div>
    <div class="modal alert collapse" id="modalFrameView" tabindex="-2" role="dialog" style="width: 100%; margin: 3px auto text-align:left ">
		<div class="modal-dialog"  style="width: 100%; margin: 0 auto text-align:left ">
            <div class="modal-content panel panel-default">
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    	<strong><span class="modal-title" id="modalFrameView_Title" ></span></strong>
                </div>
                <div class="modal-body panel-body" style="height: 500px">
                    <iframe id="modalFrameView_iframe" width="100%" height="100%" frameborder="0"></iframe>
                </div>
            </div>
        </div>
    </div>
    
    <div id="modalalert" class="modal fade" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="alertTitle"></h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body" id="alertNote"></div>
                <div class="modal-footer">
             		<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 점검표 등록용 모달창 -->
    <div class="modal fade" id="checklist-insert-modal" 
    	 data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog">
	  <div class="modal-dialog modal-checklist" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">점검표 등록</h5>
	      </div>
	      <div id="modal-checklist-insert-canvas" class="modal-body">
	      	<div id="checklist-insert-wrapper1" style="position:relative;">
				<canvas id="checklist-insert-canvas"></canvas>
			</div>
			<div id="checklist-insert-wrapper2" style="position:relative; display:none;">
				<canvas id="checklist-insert-canvas2"></canvas>
			</div>
			<div id="checklist-insert-wrapper3" style="position:relative; display:none;">
				<canvas id="checklist-insert-canvas3"></canvas>
			</div>
			<div id="checklist-insert-wrapper4" style="position:relative; display:none;">
				<canvas id="checklist-insert-canvas4"></canvas>
			</div>
			<div id="checklist-insert-wrapper5" style="position:relative; display:none;">
				<canvas id="checklist-insert-canvas5"></canvas>
			</div>
	      </div>
	      <div id="checklist-insert-footer" class="modal-footer">
	        <button type="button" id="checklist-insert-btn" class="btn btn-primary">등록</button>
	        <button type="button" id="checklist-insert-btn-close" class="btn btn-secondary">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 점검표 수정용 모달창 -->
    <div class="modal fade" id="checklist-update-modal" 
    	 data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog">
	  <div class="modal-dialog modal-checklist" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">점검표 수정</h5>
	      </div>
	      <div id="modal-checklist-update-canvas" class="modal-body">
	      	<div id="checklist-update-wrapper1" style="position:relative;">
				<canvas id="checklist-update-canvas"></canvas>
			</div>
			<div id="checklist-update-wrapper2" style="position:relative; display:none;">
				<canvas id="checklist-update-canvas2"></canvas>
			</div>
			<div id="checklist-update-wrapper3" style="position:relative; display:none;">
				<canvas id="checklist-update-canvas3"></canvas>
			</div>
			<div id="checklist-update-wrapper4" style="position:relative; display:none;">
				<canvas id="checklist-update-canvas4"></canvas>
			</div>
			<div id="checklist-update-wrapper5" style="position:relative; display:none;">
				<canvas id="checklist-update-canvas5"></canvas>
			</div>
	      </div>
	      <div id="checklist-update-footer" class="modal-footer">
	        <button type="button" id="checklist-update-btn" class="btn btn-primary">수정</button>
	        <button type="button" id="checklist-update-btn-close" class="btn btn-secondary">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 점검표 조회용 모달창 -->
    <div class="modal fade" id="checklist-select-modal" 
    	 data-keyboard="false" data-backdrop="static" tabindex="-1" role="dialog">
	  <div class="modal-dialog modal-checklist" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title">점검표 조회</h5>
	      </div>
	      <div id="modal-checklist-select-canvas" class="modal-body">
	      	<div id="checklist-select-wrapper1" style="position:relative;">
				<canvas id="checklist-select-canvas"></canvas>
			</div>
			<div id="checklist-select-wrapper2" style="position:relative; display:none;">
				<canvas id="checklist-select-canvas2"></canvas>
			</div>
			<div id="checklist-select-wrapper3" style="position:relative; display:none;">
				<canvas id="checklist-select-canvas3"></canvas>
			</div>
			<div id="checklist-select-wrapper4" style="position:relative; display:none;">
				<canvas id="checklist-select-canvas4"></canvas>
			</div>
			<div id="checklist-select-wrapper5" style="position:relative; display:none;">
				<canvas id="checklist-select-canvas5"></canvas>
			</div>
	      </div>
	      <div id="checklist-select-footer" class="modal-footer">
	        <button type="button" id="checklist-print-btn" class="btn btn-primary">출력</button>
	        <button type="button" id="checklist-select-btn-close" class="btn btn-secondary">닫기</button>
	      </div>
	    </div>
	  </div>
	</div>

	<form id="popform" name="popform" method="post" action="<%=Config.this_SERVER_path%>/Contents/CommonView/popup.jsp" target="popup_window">
  		<input type=hidden name="HeadmenuID" id="HeadmenuID" value="" />
  		<input type=hidden name="HeadmenuName" id="HeadmenuName" value="" />
  		<input type=hidden name="MenuTitle" id="MenuTitle" value="" />
  		<input type=hidden name="programId" id="programId" value="" />
  		<input type=hidden name="parm" id="parm" value="" />
	</form>
	
	<form id="spopform" name="spopform" method="post" action="<%=Config.this_SERVER_path%>/Contents/CommonView/spopup.jsp" target="popup_window">
  		<input type=hidden name="sHeadmenuID" id="sHeadmenuID" value="" />
  		<input type=hidden name="sHeadmenuName" id="sHeadmenuName" value="" />
  		<input type=hidden name="sMenuTitle" id="sMenuTitle" value="" />
  		<input type=hidden name="sprogramId" id="sprogramId" value="" />
  		<input type=hidden name="sparm" id="sparm" value="" />
	</form>
	
	<!-- *** 지우지마세요!!! -->
	<form id="haccpPopform" name="haccpPopform" method="post" action="<%=Config.this_SERVER_path%>/Contents/CommonView/popupPage.jsp" target="popup_window">
  		<input type=hidden name="pageUrl" id="pageUrl" value="" />
  		<input type=hidden name="paramData" id="paramData" value="" />
  		<input type=hidden name="pageTitle" id="pageTitle" value="" />
	</form>
	<!-- *** 지우지마세요!!! -->
	
	<form id="OrderPopform" name="OrderPopform" method="post" action="<%=Config.this_SERVER_path%>/Contents/CommonView/popupPageOrder.jsp" target="popup_window">
  		<input type=hidden name="OrderPageUrl" id="OrderPageUrl" value="" />
  		<input type=hidden name="OrderParamData" id="OrderParamData" value="" />
  		<input type=hidden name="OrderPageTitle" id="OrderPageTitle" value="" />
	</form>
	
    <form id="StockPopform" name="StockPopform" method="post" action="<%=Config.this_SERVER_path%>/Contents/CommonView/NwStockView.jsp" target="popup_window">
  		<input type=hidden name="StockPageUrl" id="StockPageUrl" value="" />
  		<input type=hidden name="StockPageTitle" id="StockPageTitle" value="" />
	</form>

	
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
	<!-- 사용자 권한 별 버튼 관리 -->
    <script src="<%=Config.this_SERVER_path%>/js/auth-button/auth-button.js"></script>
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
	<!-- MES -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/order.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/productStorage.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/rawmaterialStorage.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/productionPlan.js"></script>
	<script src="<%=Config.this_SERVER_path%>/js/services/api/mes/productionResult.js"></script>
	<!-- raw material -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/rawmaterial.js"></script>
	<!-- customer -->
	<script src="<%=Config.this_SERVER_path%>/js/services/api/customer.js"></script>
	<!--bootstrap-datepicker -->
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap-datepicker/dist/js/bootstrap-datepicker.js"></script>  
	<script src="<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/plugins/bootstrap-datepicker/dist/locales/bootstrap-datepicker.ko.min.js" charset="UTF-8"></script>
    <script>
    	/* 2020 12 12 최현수 필요없는 전역변수 찾아서 다 없애야됨! */
		var vOrderNo = "";
		var vTraceKey = ""; //안쓰는듯
		var vLotCount = ""; // 안쓰는듯?
		var vOrderDate = ""; //안쓰는듯
		var vCustCode = ""; //안쓰는듯
		var vCustRev = ""; //안쓰는듯
		var vCustName = ""; //안쓰는듯
		var vStatus = ""; //안쓰는듯
		var vProdCd = "";
		var vProdRev = "";
		var vProdNm = ""; //안쓰는듯
		var vPartNm = ""; //안쓰는듯
		var vPartCd = ""; //안쓰는듯
		var vPartRevNo = ""; //안쓰는듯
		var vDeliveryDate = ""; //안쓰는듯
		var vProductSerialNo = ""; //안쓰는듯
		var vProductSerialNoEnd = ""; //안쓰는듯
		var vBalju_no = ""; //안쓰는듯
		var vBaljuRevNo = ""; //안쓰는듯
		var vBaljuAmt = ""; //안쓰는듯
		var vProc_plan_no = "";
		var vOrderDetailSeq="";
		var vclass_jsp_page=""; //안쓰는듯
		var vIP_addr = '<%=request.getRemoteAddr()%>';
       	var MenuTitle = "";
       	var SubMenuTitle = "";
       	var ProgramID = "";
       	var REFRESHTIMEID=0;
       	var elem = document.getElementById("SubBody");
		var interVal;
		// 이력번호 전역변수로 선언 함
		var vHist_no = "";  //안쓰는듯
		
		// sweetalert 객체 생성
		let heneSwal = new SweetAlert();
		
        $(document).ready(async function() {
        	// 메뉴 생성 & 트리뷰 초기화
			var sidebar = new Sidebar();
        	var menus = await sidebar.getMenu();
        	await sidebar.generateMenu(menus);
        	
        	$('[data-widget="treeview"]').each(function () {
                $('[data-widget="treeview"]').Treeview.call($(this), 'init')
            });
        	
        	// 배포 시 로그 메시지 disable
			//logger.disableLogger();
        	
        	// input 자동입력 방지
        	$( document ).on( 'focus', ':input', function(){
		    	$( this ).attr( 'autocomplete', 'off' );
		   	});
        	
			modalFramePopup.initialize();
            modalFramePopupView.initialize();

			//알람 on/off 여부 체크
			var onoff = "N";
			
			if (onoff == 'Y') {
				$("input:checkbox[id='customSwitch1']").prop('checked', true);	 
			}
			else {
				$("input:checkbox[id='customSwitch1']").prop('checked', false);	 
			}
			
			//메인페이지 알람 토글 버튼 on/off
			$('#customSwitch1').on('click', function(){
			    if ( $(this).is(':checked') ) {
			        
			    	var check = confirm("온도데이터 이탈 안내 알람을 활성화 하시겠습니까?")
			    	
			    	if(check) {
			    		poweron();
			    	}
			    	else {
			    		return false;
			    	}
			    } 
			    else {
			    	
					var check = confirm("온도데이터 이탈 안내 알람을 비활성화 하시겠습니까?")
			    	
			    	if(check) {
			    		poweroff();
			    	}
			    	else {
			    		return false;
			    	}
			    }
			});	
			
			loadJs(heneServerPath + '/js/auth-button/auth-button.js');
			
			call_master_page_content(); // 점검표 알람 표시 영역 불러오는 함수
			//call_master_page_content2(); // ccp 모니터링 영역
        });

		function makeMenuHTML(htmlSideMenu){
            $("#SubMenuDiv").children().remove();
            $("#SubMenuDiv").html(htmlSideMenu).fadeIn(50);
		}
	
		function makeMainQueue(htmlQueue){
            $("#QueueDiv").children().remove();
            $("#QueueDiv").html(htmlQueue).fadeIn(50);
		}
		
        function fn_CommonPopup(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방) 
            var l = ((window.screen.availWidth - w ) / 2);
            var t = 10;

            var popupWin = window.open(sUrl, name, 'width=' + w + ',height=' + h + ',top=' + t + ',left=' + l + ',fullscreen=yes, toolbars=no, status=no, scrollbars=no,resizable=yes, location=no');
            if (popupWin) {
                popupWin.focus();
            }
            popupWin.opener = self;
        }
        
        function fn_CommonPopupModal(sUrl, name, w, h) { 
            var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
            + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
        	if(typeof(popupWin)=="undefine")
        		popupWin = window.returnValue;
    		return popupWin;
        } 
       
        function validateQty(event) {
            var key = window.event ? event.keyCode : event.which;
            if (event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 37 || event.keyCode == 39) {
                return true;
            }
            else if (key < 48 || key > 57) {
                return false;
            }
            else return true;
        };
        
		// 드랍다운 목록(submenu)에서 호출
        function fn_MainSubMenuSelected(obj, url, HeadmenuID, 
        								HeadmenuName, programId, SubmenuName) {
			console.debug("fn_MainSubMenuSelected()");
			console.debug(obj);
			console.debug(url);
			console.debug(HeadmenuID);
			console.debug(HeadmenuName);
			console.debug(programId);
			console.debug(SubmenuName);
			
			var $mstr = $(obj);
			var $mObj = $(obj);
			
			var mMenuTitle = "" + $mstr.text().trim();
			
			// 메인화면 알람 목록 눌렀을 때 메뉴 불러오는 함수에서 메뉴명 다르게 뜨는 것 수정하기 위함 
			if(programId == 'checklistAlarm') {
				mMenuTitle = mMenuTitle.split('(최근')[0];
			}
			
			else if(programId == 'checklistSign') {
				mMenuTitle = mMenuTitle.split('(서명')[0];
			}
			
			ProgramID = "" + programId;

            fn_SubMain(url, HeadmenuID, HeadmenuName, 
            		   programId, mMenuTitle, SubmenuName);
            return true;
        }

        //URL로 서브메뉴를 선택
        function fn_MainSubMenuSelectedByUrl() {
            $("#SubMenuDiv a").each(function () {
                var $a = $(this);
                var currentURL = document.location.pathname + document.location.search;
                if ($a.attr('href').indexOf(currentURL) > -1) {
                    fn_MainSubMenuSelect($a.text());
                }
            });
        }
        
        function fn_MainSubMenuSelect(obj) {
        	console.debug("fn_MainSubMenuSelect()");
			var mMenu="";
			var mobl = obj.toString().trim();
			
            for (var i = 0; i < $('#SubMenuDiv li').length; i++) {            	
            	mMenu = $($('#SubMenuDiv li')[i])[0].innerText;                
                if (mMenu.toString() == mobl.toString()) {                 	
                    $($('#SubMenuDiv li')[i]).attr('class', 'list-group-item active');                    
                }
                else {
                    $($('#SubMenuDiv li')[i]).attr('class', 'list-group-item'); 
                }
            }
            
            var vMenuTitleText = "", vMainButtonText = "", head_li ;
            if(SubMenuTitle.length > 0) {
            	/* 프로그램 ID 표시(개발용) */
             	vMenuTitleText = MenuTitle + " >> " + SubMenuTitle + " >> " + mobl + "(" + ProgramID.replace(".jsp","") + ")" ;
            	vMainButtonText = MenuTitle + " - " + SubMenuTitle + " - " + mobl.toString();
            	/* 프로그램 ID 미표시(배포용) */
            	/* vMenuTitleText = MenuTitle + " >> " + SubMenuTitle + " >> " + mobl;
            	vMainButtonText = MenuTitle + " - " + SubMenuTitle + " - " + mobl.toString(); */
            } else {
            	vMenuTitleText = MenuTitle + " >> " + mobl;
            	vMainButtonText = MenuTitle + " - " + mobl.toString();
            }
            
            $("#MenuTitle").text(vMenuTitleText);
            $('#mainButton').text(vMainButtonText);
        }

        //헤드메뉴에서 호출
        function fn_ContentMain(obj, urlPage, HeadmenuID, HeadmenuName, programId, mMenuTitle) {
        	console.debug("fn_ContentMain()");
        	MenuTitle = HeadmenuName.toString();
			ProgramID = programId;

			// 다른 서브메뉴&상위메뉴의 선택표시(active) 제거
			var SubMenuDiv = $(".dropdown-content");
            for (i = 0; i < SubMenuDiv.length; i++) {
            	var li = $(SubMenuDiv[i]).find("li");
            	for(j = 0; j < li.length; j++) {
            		$(li[j]).attr('class', 'list-group-item');
            	}
            }
            var HeadMenu = $("#head_ul").children();
            for (i = 0; i < HeadMenu.length; i++) {
           		$(HeadMenu[i]).attr('class', 'header');
            }
			
            $($(obj).parent()).attr('class', 'header hene-active');
            
            $.ajax({
                type: "POST",
                url: urlPage,
                data: "HeadmenuID=" + HeadmenuID + "&HeadmenuName=" + HeadmenuName + "&MenuTitle=" + mMenuTitle + "&programId=" + programId,
                beforeSend: function () {
                    $("#SubBody").children().remove();
                },
                success: function (html) {
                	$("#SubBody").hide().html(html).fadeIn(100);
                }
            });
        }
        
        //SubBody에서 호출
        function fn_SubMain(urlPage, HeadmenuID, HeadmenuName, programId, mMenuTitle, SubmenuName) {
        	console.debug("fn_SubMain()");
        	console.debug("urlPage:" + urlPage);
        	
        	MenuTitle = HeadmenuName.toString();
			ProgramID = programId;
			
			if(SubmenuName == undefined || SubmenuName == null) {
				SubMenuTitle = "";
			} else {
				SubMenuTitle = SubmenuName.toString();
			}
			
			let url = urlPage;
			let ccpUrl = "/Contents/checklist_ccp_integrated.jsp";
			
			var checklistParam = urlPage.substr(10, 9);
			var checklistParam2 = urlPage.substr(10, 10);
			var checklistNum = urlPage.substr(29,2);
			var checklistPath = urlPage.substr(0,29);
			var documentNum = urlPage.substr(27,2);
			var documentPath = urlPage.substr(0,27);
			
			console.debug("checklistParam:" + checklistParam);
			console.debug("checklistParam2:" + checklistParam2);
			console.debug("checklistNum:" + checklistNum);
			console.debug("checklistPath:" + checklistPath);
			console.debug("documentNum:" + documentNum);
			console.debug("documentPath:" + documentPath);
			
			let data = "HeadmenuID=" + HeadmenuID + 
					   "&HeadmenuName=" + HeadmenuName + 
					   "&MenuTitle=" + mMenuTitle + 
					   "&programId=" + programId;
			
			
			//선행요건 메뉴일 경우 checklist 번호를 parameter로 받아 function 진입
			if(checklistParam == 'checklist' && checklistParam2 == 'checklist/') {
				data = data + "&checklistNum=" + checklistNum;
				url = checklistPath + ".jsp?checklistNum=" + checklistNum;
			}
			//문서등록 메뉴일 경우 document 번호를 parameter로 받아 function 진입
			else if(checklistParam == 'document/') {
				data = data + "&documentNum=" + documentNum;
				url = documentPath + ".jsp?documentNum=" + documentNum;
			}
			//가열공정 점검표
			else if(urlPage === "/Contents/heating.jsp") {
				data = data + "&processCode=PC30&ccpType=heating";
				url = ccpUrl;
			}
			//금속검출공정 점검표
			else if(urlPage === "/Contents/metaldetector.jsp") {
				data = data + "&processCode=PC10&ccpType=metaldetect";
				url = ccpUrl;
			}
			//크림공정 점검표
			else if(urlPage === "/Contents/cream.jsp") {
				data = data + "&processCode=PC80&ccpType=cream";
				url = ccpUrl;
			}
           
			$.ajax({
	            type: "POST",
	            url: url,
	            data: data,
	            beforeSend: function () {
	                $("#ContentPlaceHolder1").children().remove();
	            },
	            success: function (html) {
	                $("#ContentPlaceHolder1").hide().html(html).fadeIn(100);
	            }
	        });	
			
			clearTimeout(REFRESHTIMEID);
			clearInterval(interVal);
        }
		
		
// ============================================================================

        function MM_swapImgRestore() { //v3.0
            var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
        }
        function MM_preloadImages() { //v3.0
            var d = document; if (d.images) {
                if (!d.MM_p) d.MM_p = new Array();
                var i, j = d.MM_p.length, a = MM_preloadImages.arguments; for (i = 0; i < a.length; i++)
                    if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
            }
        }

        function MM_findObj(n, d) { //v4.01
            var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
                d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
            }
            if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
            for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document);
            if (!x && d.getElementById) x = d.getElementById(n); return x;
        }

        function MM_swapImage() { //v3.0
            var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2); i += 3)
                if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
        }
//      ------------------------------------------------        
        var modalFramePopup = {
            setTitle: function (title) {
                $("#modalFrame_Title").text(title);
            },
            setHeight: function (height) {
                $("#modalFrame").find(".modal-body").css("Top", $('#modalFrame').scrollTop());
                $("#modalFrame").find(".modal-body").css("height", height);
            },
            setScroll: function (position) {
                $("#modalFrame").find(".modal-body").css("position",  position);
//                 position:fixed
//                 position: relative;
            },
            setWidth: function (widthCss) {
                //modal-sm , modal-md, modal-lg
                $("#modalFrame").find(".modal-dialog").removeClass("modal-sm").removeClass("modal-md").removeClass("modal-lg").addClass(widthCss);
            },
            setIFrameSrc: function (src) {
                $("#modalFrame_iframe").attr("src", src);
            },

            setWidth_px: function(width){
            	$("#modalFrame").find(".modal-dialog").css("width", width);
            },
            show: function (frameSrc, height, width) {
                if (frameSrc)
                    modalFramePopup.setIFrameSrc(frameSrc);
                if (height)
                    modalFramePopup.setHeight(height);
                if (width)
                    modalFramePopup.setWidth_px(width);

                $('#modalFrame').modal('show');
            },
            hide: function () {
                $('#modalFrame').modal('hide');
            },
            initialize: function () {
                $('#modalFrame').on('hide.bs.modal', function (e) {
                    $("#modalFrame_iframe").attr("src", "");
                });
            }
        };

        var modalFramePopupView = {
            setTitle: function (title) {
                $("#modalFrameView_Title").text(title);
            },
            setHeight: function (height) {
                $("#modalFrameView").find(".modal-body").css("height", height);
            },
            setWidth: function (widthCss) {
                //modal-sm , modal-md, modal-lg 
                $("#modalFrameView").find(".modal-dialog").removeClass("modal-sm").removeClass("modal-md").removeClass("modal-lg").addClass(widthCss);
            },
            setIFrameSrc: function (src) {
                $("#modalFrameView_iframe").attr("src", src);
            },

            setWidth_px: function(width){
            	$("#modalFrameView").find(".modal-dialog").css("width", width);
            },
            
            show: function (frameSrc, height, width) {
                if (frameSrc)
                    modalFramePopupView.setIFrameSrc(frameSrc);
                if (height)
                    modalFramePopupView.setHeight(height);
                if (width)
                    modalFramePopupView.setWidth_px(width);

                $('#modalFrameView').modal('show');
            },
            hide: function () {
                $('#modalFrameView').modal('hide');
            },
            initialize: function () {
                $('#modalFrameView').on('hide.bs.modal', function (e) {
                    $("#modalFrameView_iframe").attr("src", "");
                })
            }
        };
        
        function pop_fn_CustName_View(caller, Custom_gubun) {
			// var Custom_gubun = "B"; //발주:협력/외주업체
			// var Custom_gubun = "O"; //주문고객사
			var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/CustomView.jsp"
						+ "?Custom_gubun=" + Custom_gubun
						+ "&caller=" + caller;
			var footer = "";
			var title = "고객사 조회";
			let heneModal = new HenesysModal2(url, 'xlarge', title, footer);
			heneModal.open_modal();
         }
        
        function pop_fn_OrderInfor_View(caller) {
        	//caller = 1 : modalPopup1차에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/OrderInfoView.jsp?caller="+caller;
        	var footer = "";
        	var title = "주문정보 조회";
        	
        	var heneModal = new HenesysModal2(url, 'large', title, footer);
        	heneModal.open_modal();
        }

        function pop_fn_ImportInspectRequest_View(caller) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/ImportInspectRequestView.jsp?caller="+caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "수입검사신청 조회", '600px', '1160px');
    		return false;
        }

        function pop_fn_ProductInspectRequest_View(caller) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/ProductInspectRequestView.jsp?caller="+caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "제품검사신청 조회", '600px', '1160px');
    		return false;
        }
        
        function pop_fn_ProductName_View(caller, sub_caller, select_count) {
        	//caller = 0 : 일반화면에서 호출
        	//caller = 1 : modalFramePopup에서 호출
        	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/ProductViewHead.jsp"
				 		+ "?caller=" + caller + "&sub_caller=" + sub_caller + "&select_count=" + select_count;
        	var footer = "";
        	var title = "완제품 조회";
        	
        	var heneModal = new HenesysModal2(url, 'large', title, footer);
        	heneModal.open_modal();
        }
        
        function pop_fn_Chulgo_ProductName_View(caller, select_count) {
        	//caller = 0 : 일반화면에서 호출
        	//caller = 1 : modalFramePopup에서 호출
        	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/ChulgoProductViewHead.jsp"
				 		+ "?caller=" + caller + "&select_count=" + select_count;
        	var footer = "";
        	var title = "출고된 완제품 조회";
        	
        	var heneModal = new HenesysModal2(url, 'large', title, footer);
        	heneModal.open_modal();
        }

        function pop_fn_Product_View(caller) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/ProductView.jsp?caller="+caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "제품코드 조회", '750px', '1460px');
    		return false;
        }
        
        function pop_fn_projrctName_View(caller) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/projectName_View.jsp?caller="+caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "고객사/프로젝트 제품 조회", '600px', '1360px');
    		return false;
        }
        
        function pop_fn_deptName_View(caller) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/projectName_View.jsp?caller="+caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "부서 조회", '600px', '1360px');
    		return false;
        }

        function pop_fn_DocName_View(caller,num,doc_gubun,doc_no) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	//num = 2 : tr의 2번째(0부터 시작)
        	var url  = "<%=Config.this_SERVER_path%>/Contents/CommonView/DocCodeView.jsp"
        						+"?caller="+caller + "&num="+num+"&doc_gubun="+doc_gubun+"&doc_no="+doc_no;
        	var footer = "";
        	var title = "문서코드 조회";
        	
    		var heneModal = new HenesysModal2(url, 'xlarge', title , footer);
        	heneModal.open_modal();
        }
        
        function pop_fn_StorageName_View(caller) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/StorageView.jsp?caller="+caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "창고 조회", '600px', '1460px');
    		return false;
        }

        function pop_fn_PartList_View(caller) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/PartCodeViewHead.jsp" +
        				"?caller=" + caller;
        	var footer = "";
        	var title = "원부재료 조회";
        	
        	var heneModal = new HenesysModal2(url, 'xlarge', title, footer);
        	heneModal.open_modal();
        	
        }
        
        function pop_fn_PartList_View2(caller, cust_cd) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/PartCodeViewHead2.jsp" +
        				"?caller=" + caller + "&cust_cd=" + cust_cd;
        	var footer = "";
        	var title = "원부재료 조회";
        	
        	var heneModal = new HenesysModal2(url, 'xlarge', title, footer);
        	heneModal.open_modal();
        	
        }
        
        
        function pop_fn_PartIpgo_View(ipgo_date, caller) {
        
        
        	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/PartIpgoView.jsp" +
        				"?ipgo_date=" + ipgo_date
        				+"&caller=" +caller;
        	var footer = "";
        	var title = "입고 원부재료 정보조회";
        	
        	var heneModal = new HenesysModal2(url, 'xlarge', title, footer);
        	heneModal.open_modal();
        	
        }
        
        function pop_fn_SeolbiList_View(caller) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/SeolbiCodeView.jsp?caller="+caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "설비코드 조회", '600px', "75%");
    		return false;
        }
        
        function pop_fn_UserList_View(caller, rowId) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/UserListView.jsp?caller=" + caller + "&rowId=" + rowId;
			
        	pop_fn_popUpScr_nd(modalContentUrl, "사용자 목록 조회", '600px', "75%");
    		return false;
        }
        
        function pop_fn_Process_View(processGubun, caller) { /* 파라메터 알맞게 조정 필요 */
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/ProcessView.jsp?process_gubun="+ processGubun +"&caller=" + caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "공정 조회", '600px', '1024px');
    		return false;
        }

        function pop_fn_Oder_Doc_View(caller,squence, orderno) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/Oder_Doc_View.jsp?caller="+caller 
        			+ "&squence=" + squence + "&orderno=" + orderno + "&order_detail_seq=" + vOrderDetailSeq + "&LotNo=" + vLotNo;
        	pop_fn_popUpScr_nd(modalContentUrl, "주문관련 문서 조회", '600px', '80%');
    		return false;
        }
        
        function pop_fn_CheckList_View(caller,check_gubun) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/CheckListView.jsp?caller="+caller 
        			+ "&check_gubun=" + check_gubun ;
        	var footer = "";
        	var title = "체크리스트 조회";
        	var heneModal = new HenesysModal2(modalContentUrl, 'large', title, footer);
        	heneModal.open_modal();
        	return false;
        }
        
        function pop_fn_CodeBook_View(caller,code_cd) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/CodeBookView.jsp?caller="+caller 
        			+ "&code_cd=" + code_cd ;
        	pop_fn_popUpScr_nd(modalContentUrl, "공통코드 조회", '700px', '60%');
    		return false;
         }
        
        function pop_fn_Bom_View(caller,level,bom_cd) {
        	//caller = 1 : modalFramePopup에서 호출
        	//caller = 0 : 일반화면에서 호출
        	//level : sys_bom_id ='1'
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/BomView.jsp?caller="+caller 
        			+ "&level=" + level + "&bom_cd=" + bom_cd;
        	pop_fn_popUpScr_nd(modalContentUrl, "BOM 조회", '700px', '80%');
    		return false;
         }

    	function pop_fn_Trading_List(obj){   	
        	vOrderNo = $(obj).parent().parent().find("td").eq(1).text().trim();
    		vChulhaNo = $(obj).parent().parent().find("td").eq(0).text().trim();
    		vLotNo = $(obj).parent().parent().find("td").eq(2).text().trim();
    		vProdCd = $(obj).parent().parent().find("td").eq(3).text().trim();
    		vProdRev = $(obj).parent().parent().find("td").eq(4).text().trim();
    		var vChulhaSeq = $(obj).parent().parent().find("td").eq(9).text().trim();
    		var vCustCd   =  $(obj).parent().parent().find("td").eq(6).text().trim();
    		var vChulhaDt   =  $(obj).parent().parent().find("td").eq(7).text().trim();
    		
    		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040120_canvas.jsp"
        				+ "?OrderNo=" + vOrderNo + "&ChulhaNo=" + vChulhaNo + "&ChulhaSeq=" + vChulhaSeq + "&LotNo=" + vLotNo
        				+ "&prod_cd=" + vProdCd  + "&prod_rev=" + vProdRev  + "&cust_cd=" + vCustCd + "&chuha_dt=" + vChulhaDt;

    		pop_fn_popUpScr(url, "거래명세서 "+obj.innerText +"(S101S040120_canvas)", '800px', '1260px');
      	    return;
    	}
        
    	function pop_fn_Vehicle_View(caller) {
//         	var Custom_gubun = "B"; //발주:협력/외주업체
//         	var Custom_gubun = "O"; //주문고객사
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/VehicleView.jsp?caller="+caller;
        	pop_fn_popUpScr_nd(modalContentUrl, "차량 조회", '650px', '1360px');
    		return false;
        }
        
        function fn_CheckLogout() {
            return confirm('로그아웃 하시겠습니까?');
        }  

        function fn_Chart_View(){
            var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Chart/line-basic.jsp";
            modalFramePopup.setTitle("차트보기");
            pop_fn_popUpScr(modalContentUrl, obj.innerText, "700px", '80%');
            return false;
       } 

        function fn_Doc_Reg(){
            var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/FileUpload/FileUpload.jsp";
            modalFramePopup.setTitle("파일Upload");
            pop_fn_popUpScr(modalContentUrl, obj.innerText, "700px", '80%');
            return false;
       }

        var strWidth;
		var strHeight;

        function pop_fn_WinNwStock_View(){
			var pageUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/NwStockView.jsp";
			var pageTitle = "현재고량 조회";
	       	 
	    	window.open(pageUrl,"popup_window1","height=710, width=650, scrollbars=no, titlebar=no", "alwaysRaised=yes");
	    	window.focus();
		}
        
        function pop_fn_WinProdChulgo_View(){
			var pageUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/ProdChulgoView.jsp";
			var pageTitle = "생산/출고량 이력";
	       	 
	    	window.open(pageUrl,
	    			"popup_window2", "height=820, width=1000, scrollbars=no, titlebar=no", "alwaysRaised=yes");
	    	window.focus();
		}
        
        function pop_fn_WinOrder_View(){
			var pageUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/OrderCountView.jsp";
			var pageTitle = "주문량 조회";
	       	 	    	
	    	window.open(pageUrl,
	    			"popup_window3", "height=433, width=940, scrollbars=no, titlebar=no", "alwaysRaised=yes");
	    	window.focus();
		}
        
        function pop_fn_WinUpdateUserPW_View(){
			<%-- var pageUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/UpdateUserInfo.jsp";
			var pageTitle = "비밀번호 수정"; --%>
	       	
	    	window.open("<%=Config.this_SERVER_path%>/Contents/updateUserInfo.jsp",
	    			"popup_window4", "height=550px, width=700px, scrollbars=no"); 
		}
        
        function pop_fn_WinUpdateKakaoAlarmUser_View(){
			var pageUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/UpdateKakaoAlarmUser.jsp";
			var pageTitle = "카카오톡 알람 수신자 수정";
	       	
	    	window.open(pageUrl,
	    			"popup_window5", "height=360px, width=750px, scrollbars=no");
	    	window.focus();
		}
        
	         
		function pop_fn_BomUpdateDelete_View(prod_nm) {
			var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/BomUpdateDeleteView.jsp?prod_nm="+prod_nm;
			var footer = "";
			var title = "BOM 배합정보 원재료 목록";

			var heneModal = new HenesysModal2(url, 'large', title, footer);
			heneModal.open_modal();
		}
	         
		function pop_fn_Ordered_Part_View(BaljuNo, TraceKey){
	        var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/OrderedPartView.jsp"
	        		  +"?BaljuNo=" +BaljuNo + "&TraceKey=" + TraceKey;
	        var footer = "";
	        var title = "발주서 내 원부자재 목록"
	        
	        var heneModal = new HenesysModal2(url, 'large', title, footer);
			heneModal.open_modal();
		}
       
        function fn_pdf_View(regist_no, regist_no_rev, document_no,document_no_rev, fileName, jsp_page, user_id,view_revision) {
			var filem = fileName + "";
        	var ext = filem.slice(-3);
        	
			var parm = fileName 
					+ "%26regist_no%3d" + regist_no
					+ "%26regist_no_rev%3d" + regist_no_rev  
					+ "%26document_no%3d" + document_no 
					+ "%26jsp_page%3d" + jsp_page 
					+ "%26user_id%3d" + user_id 
					+ "%26orderno%3d" + vOrderNo 
					+ "%26IP_addr%3d" + vIP_addr
					+ "%26document_no_rev%3d" + document_no_rev;

			var xlparm = fileName 
					+ "&regist_no=" + regist_no
					+ "&regist_no_rev=" + regist_no_rev  
					+ "&document_no=" + document_no 
					+ "&jsp_page=" + jsp_page 
					+ "&user_id=" + user_id 
					+ "&orderno=" + vOrderNo 
					+ "&IP_addr=" + vIP_addr
					+ "&document_no_rev=" + document_no_rev;
			
			var logParm = regist_no 		+ "|"
						+ document_no 		+ "|"			
						+ fileName 			+ "|"
						+ jsp_page 			+ "|"
						+ user_id 			+ "|"
						+ vIP_addr 			+ "|"
						+ regist_no_rev 	+ "|"  
						+ document_no_rev 	+ "|";
			
			if(view_revision=='view') {
				if(filem.slice(-3) == "pdf" || filem.slice(-3) == "PDF"){
					fn_CommonPopup("<%=Config.this_SERVER_path%>/pdfjs-dist/web/viewer.html?file=http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=Config.this_SERVER_path%>" + fileName , "", 1024, 950);
				} else if(filem.slice(-3) == "xls" || filem.slice(-3) == "XLS" || filem.slice(-4) == "xlsx" || filem.slice(-4) == "XLSX") {
					window.open("http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=Config.this_SERVER_path%>" + fileName);
				} else{
					var url = "http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=Config.this_SERVER_path%>" + fileName;
					window.open(url);
				}
			} else {
				var url = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010122.jsp"
						+ "?RegistNo=" + regist_no 
		   				+ "&RevisionNo=" + regist_no_rev 
		   				+ "&DocumentNo=" + document_no 
		   				+ "&FileViewName=" + fileName
		   				+ "&jspPage=" + jsp_page 
		   				+ "&orderno=" + vOrderNo 
		   				+ "&order_detail_seq=" 
		   				+ vOrderDetailSeq 
		   				+ "&LotNo=" + vLotNo;

		   		pop_fn_popUpScr(url, "문서개정(S606S010122)", '600px', '650px');
			}
    		return false;
         }
        
       function fn_doc_view_log(bomdata,pid){
    	   $.ajax({
  	         type: "POST",
  	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
  	         data: "bomdata=" + bomdata + "&pid=" + pid
  	     });
       }

       function fn_Process_Review_n_Confirm(obj, pageName, OrderNo, OrderDetailSeq, processname, mainKey, actionKey, num_gubun, process_gubun) {
       	var actionProcess = pageName.split(".");
       	if(actionProcess[0].substr(8,3)=="300")
       		Action ="Review";
       	else if(actionProcess[0].substr(8,3)=="100")
       		Action ="Regist";
       	else
       		Action ="Confirm";
       	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/Approval_insert.jsp?Action_process=" + pageName 
       			+ "&Action_lebel=" + Action + "&OrderNo=" + OrderNo+ "&processname=" + processname 
       			+ "&OrderDetailSeq=" + OrderDetailSeq + "&mainKey=" + mainKey + "&actionKey=" + actionKey 
       			+ "&num_gubun=" + num_gubun + "&process_gubun=" + process_gubun + "&Lotno=" + vLotNo;

       	pop_fn_popUpScr(modalContentUrl, obj.innerText, '420px', '600px');
   		return false;
        }
	
        function pop_fn_popUpScr(url, title, height, width) {

        	var posX = $('#modalReport').offset().left - $(document).scrollLeft() - width + $('#modalReport').outerWidth();
        	var posY = $('#modalReport').offset().top - $(document).scrollTop() + $('#modalReport').outerHeight();

            $("#modalReport_Title").text(title);
            $("#modalReport").find(".modal-body").css("top", $('#modalReport').scrollTop());
			$("#modalReport").find(".modal-body").css("height", height);
			$("#modalReport").find(".modal-dialog").css("width", width);
     		
    		$.ajax({
    	    	type: "POST",
    	    	url:  url,
    	 	 	beforeSend: function () { 
    	            $("#ReportNote").children().remove();
    	   		},
    	   	  	success: function (html) {
    		   	  	$('#ReportNote').hide().html(html).fadeIn(100);
    				$('#modalReport').show();
    				$('#btn_Canc').on("click",function(){
    					$('#modalReport').hide();
    					
    				});
    	   	   	}
    		});
    		return false;
         }

        function pop_fn_popUpScr_nd(url, title, height, width) {
        	var posX = $('#modalReport_nd').offset().left - $(document).scrollLeft() - width + $('#modalReport_nd').outerWidth();
        	var posY = $('#modalReport_nd').offset().top - $(document).scrollTop() + $('#modalReport_nd').outerHeight();
            $("#modalReport_Title_nd").text(title);
            $("#modalReport_nd").find(".modal-body").css("top", $('#modalReport_nd').scrollTop());
            $("#modalReport_nd").find(".modal-body").css("height", height);
        	$("#modalReport_nd").find(".modal-dialog").css("width", width);
    		$("#modalReport_nd").attr("closeOnEscape", "false");
    		$.ajax({
    	    	type: "POST",
    	    	url:  url , 
    	 	 	beforeSend: function () { 
    	            $("#ReportNote_nd").children().remove();
    	   		},
    	   	  	success: function (html) {
    		   	  	$('#ReportNote_nd').html(html);
    				$('#modalReport_nd').show();
    				$('#btn_Canc').on("click",function(){
    					$('#modalReport_nd').hide();
    				});
    	   	   	},
    	   	 	error: function (xhr, option, error) {
    	   	  	}
    		});
    		return false;
         }

        function pop_fn_popUpScr_nd_2(url,title, height, width) {
        	var posX = $('#modalReport_nd_2').offset().left - $(document).scrollLeft() - width + $('#modalReport_nd_2').outerWidth();
        	var posY = $('#modalReport_nd_2').offset().top - $(document).scrollTop() + $('#modalReport_nd_2').outerHeight();
            $("#modalReport_Title_nd_2").text(title);
            $("#modalReport_nd_2").find(".modal-body").css("top", $('#modalReport_nd_2').scrollTop());
            $("#modalReport_nd_2").find(".modal-body").css("height", height);
        	$("#modalReport_nd_2").find(".modal-dialog").css("width", width);
    		$("#modalReport_nd_2").attr("closeOnEscape", "false");
    		$.ajax({
    	    	type: "POST",
    	    	url: url, 
    	 	 	beforeSend: function () { 
    	            $("#ReportNote_nd_2").children().remove();
    	   		},
    	   	  	success: function (html) {
    		   	  	$('#ReportNote_nd_2').html(html);
    				$('#modalReport_nd_2').show();
    				$('#btn_Canc').on("click",function(){
    					$('#modalReport_nd_2').hide();
    					
    				});
    	   	  	
    	   	   	},
    	   	 	error: function (xhr, option, error) {
    	   	  	}
    		});
    		return false;
         }   
        
        function fn_HACCP_View(sMenuTitle, Haccp_programId) {
        	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/CommonView/haccp_doc_image_wiew.jsp?sprogramId=" + Haccp_programId;
        	pop_fn_popUpScr_nd(modalContentUrl, sMenuTitle +' |' + Haccp_programId, '800px', '1060px');
    		return false;
        }
        
    	function com_fn_SubInfo_DOC_List(obj,OrderNo) { 	//문서개정 권한이 있는 경우
        	$.ajax({
           	        type: "POST",
           	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020120.jsp",
           	        data: "order_detail_seq=" +  "&OrderNo=" + vOrderNo + "&LotNo=" + vLotNo,
           	        success: function (html) {
           	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
           	        }
           	    }); 
    		return;
    	}
    	
    	function com_fn_SubInfo_DOC_List_Process(obj,OrderNo) {	//생산관리 => 문서개정 권한이 없을 경우
        	$.ajax({
      	        type: "POST",
      	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S010140.jsp",
      	        data: "&OrderNo=" + vOrderNo + "&LotNo=" + vLotNo,
      	        success: function (html) {
      	            $("#SubInfo_List_Doc").hide().html(html).fadeIn(100);
      	        }
			}); 
   			return;
    	}
    	
		function pop_fn_ProducCheckList(obj, JSPpage) {         	
	   		if(vOrderNo.length < 1) {
	   			heneSwal.warning('주문 정보를 선택하세요')
	    		return false;
	    	}
	    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030130.jsp?OrderNo=" + vOrderNo
	    			+ "&lotno=" + vLotNo;
	     	pop_fn_popUpScr(url, obj.innerText+"(S101S030130)", '70%', '90%');
	    	return;
		}
	        
		function pop_fn_ProcessCheckList(obj, JSPpage) {         	
			if(vOrderNo.length < 1){
				heneSwal.warning('주문 정보를 선택하세요')
				return false;
			} 
			var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030160.jsp?OrderNo=" + vOrderNo
					+ "&order_detail_seq="  + vOrderDetailSeq
					+ "&lotno=" + vLotNo ;
		   	pop_fn_popUpScr(url, obj.innerText+"(S101S030160)", '80%', '90%');
			return;
		}
	
	   	function pop_fn_BomList(obj, JSPpage) {         	
	   		if(vProc_plan_no.length < 1){
	   			heneSwal.warning('생산 정보를 선택하세요')
	   			return false;
	   		} 
	   		
	   		var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/OrderBomList.jsp"
	   				+ "?proc_plan_no=" + vProc_plan_no;
	       	pop_fn_popUpScr(url, obj.innerText, '90%', '70%');
	   		return;
	   	}       
	   	
	    function pop_fn_Release_part_search(obj, JSPpage) { /* 파라메터 알맞게 조정 필요 */
	    	
	   		if(vPart_cd.length < 1){
	   			heneSwal.warning('주문 정보를 선택하세요')
	   			return false;
	   		} 
	   		
	   		var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/Release_part_search.jsp?part_cd=" + vPart_cd
	   				;
	       	pop_fn_popUpScr(url, obj.innerText, '90%', '80%');
	   		return;
	   	}
	   	
	   	function pop_fn_Balju_form(obj){   	
    		vBaljuNo = $(obj).parent().parent().find("td").eq(1).text().trim();
    		vOrderNo = $(obj).parent().parent().find("td").eq(0).text().trim();
	 		var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/Balju_form_view_canvas.jsp"
        	var url = "<%=Config.this_SERVER_path%>/Contents/CommonView/Balju_form_view.jsp"
	    			   +"?OrderNo=" + vOrderNo+"&BaljuNo="+vBaljuNo;
	   		pop_fn_popUpScr(url, obj.innerText +"(Balju Canvas)", '85%', '1210px');
	  	    return;
		}
	    
	    function fn_Search(obj, vDataTable){
			var SearchString = $(obj).text().trim();
			vDataTable.search(SearchString);
			vDataTable.draw();
	    }
	    
		function urlencode(str) {
		    str = (str + '').toString();
		    return encodeURIComponent(str)
		        .replace(/!/g, '%21')
		        .replace(/'/g, '%27')
		        .replace(/\(/g, '%28')
		        .replace(/\)/g, '%29')
		        .replace(/\#/g, '%23')
		        .replace(/\*/g, '%2A')
		        .replace(/%20/g, '+');
		}
		
		function logout(){
			var check = confirm("로그아웃 하시겠습니까?");
		 
		  	if(check){
				location.href="logout.jsp";
		  	} else {
			 	return false;
		  	}  
		}
		
		//mainpage 카톡 알람 on
		function poweron() {
			var str = "on";
				
			var jsonData = new Object();
			jsonData.object = str;
			var jsonStr = JSON.stringify(jsonData);
		
			$.ajax({
                type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
                data: {"bomdata":jsonStr, "pid":"M000S100000E993"},
                success: function (receive) {
                	if(receive > -1) {
                		heneSwal.successTimer('온도데이터 알람 활성화 상태로 변경되었습니다');
                	} else {
                		heneSwal.errorTimer('상태 변경에 실패했습니다. 다시 시도해주세요.');
                	}
                }
            });	
		}
		
		//mainpage 카톡 알람 off
		function poweroff(){
		
			var str = "off";
			
			var jsonData = new Object();
			jsonData.object = str;
			var jsonStr = JSON.stringify(jsonData);
		
			$.ajax({
                type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
                data: {"bomdata":jsonStr, "pid":"M000S100000E994"},
                success: function (receive) {
                	if(receive > -1) {
                		heneSwal.successTimer('온도데이터 알람 비활성화 상태로 변경되었습니다');
                		
                	} else {
                		heneSwal.errorTimer('상태 변경에 실패했습니다. 다시 시도해주세요.');
                		
                	}
                }
            });
		}
		
		function call_master_page_content() {
        	$.ajax({
     	        type: "POST",
     	        url: "<%=Config.this_SERVER_path%>/Contents/checklist_alarm.jsp",
     	        success: function (html) {
     	            $("#ContentPlaceHolder1").hide().html(html).fadeIn(100);
     	        }
     	    });
    	}
		<%-- 
		function call_master_page_content2() {
        	$.ajax({
           	        type: "POST",
           	        url: "<%=Config.this_SERVER_path%>/Contents/ccp_monitoring.jsp",
           	        beforeSend: function () {
           	        },
           	        success: function (html) {
           	            $("#ContentPlaceHolder2").hide().html(html).fadeIn(100);
           	        },
           	        error: function (xhr, option, error) {
           	        }
           	    }); 
    	} --%>
		
		//뒤로가기 방지코드
		history.pushState(null, null, location.href);
		
		window.onpopstate = function(event) {
			history.go(1) 
		};
    </script>
</body>
</html>