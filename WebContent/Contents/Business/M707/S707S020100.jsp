<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.stream.*"%>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String selectDate = "", selectWeek = "";

	if(request.getParameter("selectDate") != null)
		selectDate = request.getParameter("selectDate");
	if(request.getParameter("selectWeek") != null)
		selectWeek = request.getParameter("selectWeek");
	
	JSONObject jArray = new JSONObject();
	jArray.put("selectDate", selectDate);
	jArray.put("selectWeek", selectWeek);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M707S020100E104", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
%>

<script>

    $(document).ready(function () {
    	
    	var dataArr = <%= makeGridData.getDataArray() %>;
    	var labelArr = new Array();
    	var valueArr = new Array();
    	for(x in dataArr){
    		labelArr.push(dataArr[x][1]);
    		valueArr.push(dataArr[x][3]);
    	}
    	
    	new Chart(document.getElementById("canvas"), {
    	    type: 'horizontalBar',
    	    data: {
    	    	labels: labelArr,
    	        datasets: [{
    	            label: '모니터링 빈도',
    	            data: valueArr,
    	            borderColor: "rgba(255, 201, 14, 1)",
    	            backgroundColor: "rgba(255, 201, 14, 0.5)",
    	            fill: false,
    	        }]
    	    },
    	    options: {
    	    	/*   responsive: true,
    	         title: {
    	            display: true,
    	            text: '모니터링 빈도'
    	        }, */
    	        tooltips: {
    	            mode: 'index',
    	            intersect: false,
    	        },
    	        hover: {
    	            mode: 'nearest',
    	            intersect: true
    	        },
    	        scales: { 
		            xAxes: [{
    	               	<%-- date or week 조건 선택 --%>
    	                <% if("".equals(selectWeek) || selectWeek == null){ %>
    	                	ticks: {
			        	        		stepSize: 5,
			       	        	        min: 0,
			       	        	        max: 60
			    		            }    	                	
    	                <% } else { %>
	    	                ticks: {
			        	        		stepSize: 25,
			       	        	        min: 0,
			       	        	        max: 300
			    		            }
    	                <% } %>
    	            }]
    	        } // scales
    	    } // options
    	});

    });

</script>
<div style="width:100%;">
	<canvas id="canvas" height="80px"></canvas>
</div>