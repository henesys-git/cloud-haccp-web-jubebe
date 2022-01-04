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
%>

<style>

  #calendar {
    max-width: 1100px;
    margin: 0 auto;
  }

</style>

<div id='calendar'></div>

<script>
	
	$(document).ready(function () {
		var heneDate = new HeneDate();
		var today = heneDate.getToday();
		
		var ajaxUrl = '<%=Config.this_SERVER_path%>/js/realtime-board/tempDisplay_ProdPlan_Detail.jsp';
		
		var errMsg = '데이터 로딩 실패했습니다, 다시 시도해주세요';
		
		var calendarEl = document.getElementById('calendar');
	
	    var calendar = new FullCalendar.Calendar(calendarEl, {
			initialDate: today,
			initialView: 'dayGridWeek',
	      	selectable: true,
          	locale: 'ko',
          	hiddenDays: [0,6],
          	/*
          	headerToolbar : { // 상단에 title만 표시하고 select 버튼은 제거
          	start : 'title',
          	center : '',
          	end : ''
          	
          	},
          	*/
          	headerToolbar : false,
	      	eventSources: [
	    		{
	    	    	url: ajaxUrl,
	    	      	type: 'POST',
	    	      	error: function() {
	    	        	heneSwal.warning(errMsg);
	    	      	}
	    	    }
	    	],
	    	
	    	eventDidMount: function(info) {
	    		var title = info.event.title;
	    		var style = info.el.style;
	    		
	    		switch(title) {
	    			case "오전생산계획":
	    				//style.backgroundColor = "#003366";
	    				style.backgroundColor = "#800000";
	    				break;
	    			case "오후생산계획":
	    				style.backgroundColor = "#336699";
	    				break;
	    			
	    		}
	    		
	    		// title과 content를 합쳐서 달력에 표시
	    		var titleNode = info.el.getElementsByClassName('fc-event-title')[0];
	    		$(titleNode).append("<br><br>" + info.event.extendedProps.description);
	    		
	    		// key(날짜) : value(planRevNo)
	    		// 계획 수정, 삭제 시에 db 조회용
	    		//planRevNoObj[info.event.startStr] = info.event.extendedProps.planRevNo
	    	},
	    	dateClick: function(info) {
	    		selectedDate = info.dateStr;
				planRevNo = planRevNoObj[selectedDate];
	    	},
	    	
	    	contentHeight : 'auto', //높이 자동조절해서 여백을 없앰
	    	
	    });
	
	    calendar.render();
  	});
</script>