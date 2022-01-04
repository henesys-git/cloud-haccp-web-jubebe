<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String memberKey = session.getAttribute("member_key").toString();	
	String startDate = "", endDate = "";

	JSONObject jArray = new JSONObject();
	jArray.put("empty", "empty");

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S210100E104", jArray);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S210100";
%>

<script>

	$(document).ready(function () {
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>
		}
				
		mainTable = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
	});
	    
   	function clickMainMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
	 	
		shelf_type = td.eq(0).text().trim();
		console.log(shelf_type);
		parent.DetailInfo_List.click();
    }
    
	function fn_Clear_varv() {
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>선반타입</th>
		    <th>선반 줄? 개수</th>
		    <th>선반 줄별 쟁반 개수</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>