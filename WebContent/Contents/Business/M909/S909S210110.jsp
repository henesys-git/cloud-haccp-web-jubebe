<%@ page import="java.net.URLDecoder"%>
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

	String shelf_type = "";
	
	if(request.getParameter("shelf_type") != null) {
		shelf_type = request.getParameter("shelf_type");
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("shelf_type", shelf_type);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S210100E114", jArray);	
 	
 	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S210110";
%>

<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	       		'targets': [1,2],
   	       		'createdCell':  function (td) {
   	          			$(td).attr('style', 'display: none;');
   	       		}
   	    	}]
    	}
    	
    	subTable = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
    });
    
    function clickSubMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
	 	
		prod_cd = td.eq(1).text().trim();
		prod_rev_no = td.eq(2).text().trim();
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>선반타입</th>
			<th style="display:none; width:0px">완제품 코드</th>
			<th style="display:none; width:0px">완제품 수정이력번호</th>
			<th>완제품명</th>
			<th>쟁반별 완제품 개수</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>