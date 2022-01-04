<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String startDate = "",
		   endDate = "",
		   orderType = ""; 
	
	if(request.getParameter("startDate") != null)
		startDate = request.getParameter("startDate");

	if(request.getParameter("endDate") != null)
		endDate = request.getParameter("endDate");
	
	if(request.getParameter("orderType") != null)
		orderType = request.getParameter("orderType");
	
	JSONObject jArray = new JSONObject();
	jArray.put("startDate", startDate);
	jArray.put("endDate", endDate);
	jArray.put("orderType", orderType);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M101S020100E124", jArray);	
 	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS101S020120";
%>

<script>
    $(document).ready(function () {
    	
    	let customOpts = {
    			data : <%=makeGridData.getDataArray()%>,
    			columnDefs : [
		   			{
			  			'targets': [2],
			  			'className' : "dt-body-right",
			  			'render': function(data){
			  				return addComma(data);
			  			}
			  		}
	   			]
    	}
    	
    	let subtable = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
    	);
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>완제품 명</th>
			<th>규격</th>
			<th>주문 수량</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>
