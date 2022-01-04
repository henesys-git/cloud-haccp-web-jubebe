<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String regist_seq_no = "", drive_date = "";
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");

	if(request.getParameter("drive_date") != null)
		drive_date = request.getParameter("drive_date");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "regist_seq_no", regist_seq_no);
	jArray.put( "drive_date", drive_date);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S100200E114", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID	= "tableS838S100210";
%>
<script type="text/javascript">

	$(document).ready(function () {
		
		var htmlTable_ID = '<%=makeGridData.htmlTable_ID%>';
    	
    	var dataArr = <%=makeGridData.getDataArray()%>;
    	
    	var customOpts = {
				data : dataArr,
			    "pageLength": 5,
			    "lengthMenu": [5],
			    "scrollCollapse": true,
			    "paging": true,
				columnDefs : [{
					'targets': [0,1,2],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [7],
					'render': function(data) {
						if(data == '1') {
							var str = "냉장/냉동"
					  		
						} else if(data == '2') {
							var str = "냉장"
						} else {
							var str = "냉동"
						}
						return str;
					}
				}]
		}
		
 		var table = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		); 
   	});
	
	function clickSubMenu(obj){
		return false;
    }
</script>
<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th style='width:0px; display:none;'>작성일련번호</th>
			<th style='width:0px; display:none;'>운행일자</th>
			<th style='width:0px; display:none;'>상세일련번호</th>
			<th>운행구간</th>
		    <th>출발시간</th>
		    <th>도착시간</th>
		    <th>차량/운전자</th>
		    <th>냉장/냉동</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>
<div id="UserList_pager" class="text-center"></div>