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
	
	String month = "", year = "", prod_cd = "";
	
	if(request.getParameter("month") != null)
		month = request.getParameter("month");
	
	if(request.getParameter("year") != null)
		year = request.getParameter("year");
	
	if(request.getParameter("prod_cd") != null)
		prod_cd = request.getParameter("prod_cd");
	
	JSONObject jArray = new JSONObject();
	
	DoyosaeTableModel table = new DoyosaeTableModel("M858S010300E204", jArray);
	
%>

<style>

  #calendar {
    max-width: 1100px;
    margin: 0 auto;
  }

</style>

<div id='calendar'></div>

<script>
	var year = "";
	var month = "";
	
	$(document).ready(function () {
		
		var year = '<%=year%>';
		var month = '<%=month%>';
		
		if(month < 10){
			var month = '0' + '<%=month%>';
		}
		else {
			var month = '<%=month%>';
		}
		
		var heneDate = new HeneDate();
		var today = heneDate.getToday();
		
		var ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CommonView/Product/ProdInOutHistory.jsp';
		
		var errMsg = '데이터 로딩 실패했습니다, 다시 시도해주세요';
		
		var calendarEl = document.getElementById('calendar');
	
	    var calendar = new FullCalendar.Calendar(calendarEl, {
			initialDate: year + '-' + month + '-01',
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
  	    	        	prodCd: '<%=prod_cd%>'
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