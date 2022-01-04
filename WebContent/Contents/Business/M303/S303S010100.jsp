<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String startDate = "", endDate = "",
		   partGubunMid = "", partGubunBig = "";

	if(request.getParameter("startDate") != null)
		startDate = request.getParameter("startDate");
	
	if(request.getParameter("endDate") != null)
		endDate = request.getParameter("endDate");	

	if(request.getParameter("partGubunMid") != null)
		partGubunMid = request.getParameter("partGubunMid");	
	
	if(request.getParameter("partGubunBig") != null)
		partGubunBig = request.getParameter("partGubunBig");	

	JSONObject jArray = new JSONObject();
	jArray.put("startDate", startDate);
	jArray.put("endDate", endDate);
	jArray.put("partGubunMid", partGubunMid);
	jArray.put("partGubunBig", partGubunBig);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S010100E104", jArray);
	
	MakeGridData makeGridData= new MakeGridData(TableModel);
 	makeGridData.htmlTable_ID = "tableS303S010100";
%>
    
<script>
	$(document).ready(function () {
	
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs: [{
					'targets': [2],
						'createdCell':  function (td) {
							$(td).attr('style', 'display: none;');
						}
				}],
				order : [[ 0, "desc" ]]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)		
		);
		
	});
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th>날짜</th>
		     <th>내역</th>
		     <th>전기이월</th>
		     <th>입고</th>
		     <th>사용량</th>
		     <th>당일재고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>