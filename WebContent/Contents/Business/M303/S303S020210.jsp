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
	
	String manufacturingDate = "",
		   requestRevNo = "",
		   prodPlanDate = "",
		   planRevNo = "",
		   prodCd = "", 
		   prodRevNo = ""; 
	
	if(request.getParameter("manufacturingDate") != null) {
		manufacturingDate = request.getParameter("manufacturingDate");
	}

	if(request.getParameter("requestRevNo") != null) {
		requestRevNo = request.getParameter("requestRevNo");
	}
	
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

	DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S020200E114", jArray);
 	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS303S040110";
%>

<script>
	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs : [{
				'targets': [5,6,7],
				'createdCell': function (td) {
					$(td).attr('style', 'display:none;');
				}
			},
   			{
	  			'targets': [1,2,3],
	  			
	  			'className' : "dt-body-right"
	  		}]
		}
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
    	);
    	
    	fn_Clear_varv();
	});
	
	function clickSubMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		vPartNm = td.eq(0).text().trim();
		vBlendingRatio = td.eq(1).text().trim();
		vBlendingAmtPlan = td.eq(2).text().trim();
		vBlendingAmtReal = td.eq(3).text().trim();
		vDiffReason = td.eq(4).text().trim();
		vPartCd = td.eq(5).text().trim();
		vPartRevNo = td.eq(6).text().trim();
		vBomRevNo = td.eq(7).text().trim();
	}

	function fn_Clear_varv(){

	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>원부재료명</th>
			<th>배합기준량</th>
			<th>계획 배합량</th>
			<th>실제 배합량</th>
			<th>불일치 사유</th>
			<th style="display:none; width:0px">원부재료 코드</th>
			<th style="display:none; width:0px">원부재료 수정이력</th>
			<th style="display:none; width:0px">배합정보 수정이력</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>   

<div id="UserList_pager" class="text-center">
</div>