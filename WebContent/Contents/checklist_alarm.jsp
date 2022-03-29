<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<!-- <script src="../../Lib/js/d3.v3.min.js" charset="utf-8"></script> -->

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>
<%-- <script type="text/javascript" src="<%=Config.this_SERVER_path%>/Contents/Chart/chart_function.js"></script> --%>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@0.7.0"></script>
<script>
 $(document).ready(function () {
	 getData2();
	 getData3();
 });
     function getData2() {
     	$.post("<%=Config.this_SERVER_path%>/Contents/checklist_alarm2.jsp", function(html) {
 	    	$("#parent_page2").hide().html(html).fadeIn(100);
 		})
 	}
     function getData3() {
      	$.post("<%=Config.this_SERVER_path%>/Contents/ccp_monitoring.jsp", function(html) {
  	    	$("#parent_page3").hide().html(html).fadeIn(100);
  		})
  	}
	</script>

<!-- <div class="panel panel-default" style="margin-left: 5px; margin-top: 5px; margin-right: 5px; margin-bottom: 5px; width: 100%"> -->
<div class="panel panel-default" style="width: 100%;height: 800px;display: flex; flex-direction: column;">
	<!-- Default panel contents -->
	<div class="panel-heading" style="font-weight: bold" id="MenuTitle"></div>
	<div class="panel-body">
		<div class = "row">
			<div class ="col-md-6" id="parent_page2"></div>
			<div class ="col-md-6" id="parent_page3"></div>	
		</div>
	</div>
</div>