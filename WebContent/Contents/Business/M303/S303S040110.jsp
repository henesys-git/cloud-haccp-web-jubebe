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
	
	String requestRevNo = "", prodPlanDate = "", planRevNo = "",
		   prodCd = "", prodRevNo = "", manufacturingDate = "";

	System.out.println("1. requestRevNo is " + requestRevNo);
	
	if(request.getParameter("manufacturingDate") != null)
		manufacturingDate = request.getParameter("manufacturingDate");

	if(request.getParameter("requestRevNo") != null)
		requestRevNo = request.getParameter("requestRevNo");
	
	if(request.getParameter("prodPlanDate") != null) { 
		prodPlanDate = request.getParameter("prodPlanDate"); 
	}
	
	if(request.getParameter("planRevNo") != null) { 
		planRevNo = request.getParameter("planRevNo"); 
	}
	
	if(request.getParameter("prodCd") != null) { 
		prodCd = request.getParameter("prodCd"); 
	}
	
	if(request.getParameter("prodRevNo") != null) { 
		prodRevNo = request.getParameter("prodRevNo"); 
	}
		
	JSONObject jArray = new JSONObject();
	jArray.put("manufacturingDate", manufacturingDate);
	jArray.put("requestRevNo", requestRevNo);
	jArray.put("prodPlanDate", prodPlanDate);
	jArray.put("planRevNo", planRevNo);
	jArray.put("prodCd", prodCd);
	jArray.put("prodRevNo", prodRevNo);

	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S040100E114", jArray);

 	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS303S040110";
    
 	makeGridData.Check_Box = "false";
 	String[] HyperLink = {""};
 	makeGridData.HyperLink = HyperLink;
%>

<script>
	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			
   			columnDefs : [{
   				'targets' : [2,3],
	  			
	  			'className' : "dt-body-right"
   			}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneSubTableOpts, customOpts)
    	);
    	
    	fn_Clear_varv();
	});
	
	function clickSubMenu(obj) {
	}

	function fn_Clear_varv(){
		vJob_order_no = "";
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>원부재료명</th>
			<th>규격</th>
			<th>기준배합량</th>
			<th>계획배합량</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>   

<div id="UserList_pager" class="text-center">
</div>