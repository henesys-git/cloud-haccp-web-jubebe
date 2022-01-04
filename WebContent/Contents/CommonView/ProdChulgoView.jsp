<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	JSONObject jArray = new JSONObject();
	
	DoyosaeTableModel table = new DoyosaeTableModel("M858S010300E204", jArray);
	
	// 캘린더 처음 로딩 시 사용할 제품 코드 값
	String initialProdCode = table.getStrValueAt(0, 0);
	
	// 제품 목록이 담긴 select 태그를 만듬
	int rowLen = table.getRowCount();
	
	StringBuilder sb = new StringBuilder();
	sb.append("'<select class=\"form-control select2\" id=\"prodCd\">' + \n");
	
	for(int i = 0; i < rowLen; i++) {
		sb.append("'<option value="+table.getStrValueAt(i, 0)+">"+table.getStrValueAt(i, 1)+"</option>' + \n");
	}
	
	sb.append("'</select>' \n");
	String selectTag = sb.toString();
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
	
	<!-- FullCalendar CSS -->
	<link rel="stylesheet" href="<%=Config.this_SERVER_path%>/fullcalendar-5.5.0/lib/main.css">
	<!-- FullCalendar -->
	<script src="<%=Config.this_SERVER_path%>/fullcalendar-5.5.0/lib/main.js"></script>
	<!-- Henedate -->
	<script src="<%=Config.this_SERVER_path%>/js/setdate.js"></script>

<style>
  #calendar {
    max-width: 1100px;
    margin: 0 24px;
  }
</style>

<div id='calendar'></div>

<script type="text/javascript">

	$(document).ready(function () {
		var heneDate = new HeneDate();
		var today = heneDate.getToday();
		
		var ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CommonView/Product/ProdInOutHistory.jsp';
		
		var errMsg = '데이터 로딩 실패했습니다, 다시 시도해주세요';
		
		var calendarEl = document.getElementById('calendar');
	
	    var calendar = new FullCalendar.Calendar(calendarEl, {
			initialDate: today,
	      	editable: true,
	      	selectable: true,
	      	businessHours: true,
	      	dayMaxEvents: true,
	      	headerToolbar: {
            	left: '',
              	center: 'title',
              	right: 'prev,next today'
          	},
          	locale: 'ko',
	      	eventSources: [
	    		{
	    	    	url: ajaxUrl,
	    	      	type: 'POST',
	    	      	extraParams: {
  	    	        	prodCd: '<%=initialProdCode%>'
	    	      	},
	    	      	error: function() {
	    	        	heneSwal.warning(errMsg);
	    	      	}
	    	    }
	    	],
	    	eventDidMount: function(info) {
	    		var type = info.event.title.substring(0, 2);
	    		var value = info.event.title.substring(4, 6);
	    		var style = info.el.style;
	    		
	             if(type == '출하') {
					style.backgroundColor = "red";
					style.borderColor = "red";
	            } 
	            
	            if(value == 0) {
					style.display = "none";
					
	            }
	        }
	    });
	
	    calendar.render();
	    
	    // header에 제품 목록 drop down 추가
	    $(".fc-toolbar-chunk:eq(0)").append(<%=selectTag%>);
		
	    // 선택 제품 변경 시 새로 고침
	    $("#prodCd").change(function() {
	    	var newSrc = {
		        url: ajaxUrl,
		        type: 'POST',
		        extraParams: {
		            prodCd: $(this).val()
		        },
		        error: function() {
    	        	heneSwal.warning(errMsg);
    	      	}
		    };
			
	    	var orgSrc = calendar.getEventSources();
	    	orgSrc[0].remove();
	    	calendar.addEventSource(newSrc);
	    });
  	});
</script>