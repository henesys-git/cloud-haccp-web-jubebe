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
    
	String selectedDate = "";
	
	if(request.getParameter("selectedDate") != null) {
		selectedDate = request.getParameter("selectedDate");
	}
    
	JSONObject jArray = new JSONObject();
	jArray.put("selectedDate", selectedDate);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M303S040100E174", jArray);
    MakeGridData makeGridData = new MakeGridData(TableModel);

    makeGridData.htmlTable_ID = "tableDailyPlanView";
%>

<script>
	$(document).ready(function () {
		
		setTimeout(function(){
		
		var customOpts = {
    			data : <%=makeGridData.getDataArray()%>,
    			columnDefs : [{
    	       		'targets': [1,5,6,7,8],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;'); 
    	       		}
    	    	}],
    	    	scrollX : true,
    	    	scrollCollapse : true,
    	    	autoWidth : true,
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
		
		}, 300);
	});
	
	function clickMainMenu(obj) {
		var tr = $(obj);
		var td = tr.children();
						
		var prodPlanDate = td.eq(0).text().trim();
		var planType = td.eq(1).text().trim();
		//var planTypeNm = td.eq(2).text().trim();
		var prodName = td.eq(3).text().trim(); 
		var planAmount = td.eq(4).text().trim(); 
		var planRevNo = td.eq(5).text().trim(); 
		var prodCd = td.eq(6).text().trim(); 
		var prodRevNo = td.eq(7).text().trim(); 
		var expirationDate = td.eq(8).text().trim();
		var gugyuk = td.eq(9).text().trim();

		parent.setValues(prodPlanDate, planType, prodName, planAmount,
						 planRevNo, prodCd, prodRevNo, 
						 expirationDate, gugyuk);
		
		$('#modalReport2').modal('hide');
		
		//parent.$('#modalReport_nd').hide();
	}
	
</script>	

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>생산계획일자</th>
			<th style='width:0px; display:none;'>계획구분타입</th>
			<th>계획구분</th>
			<th>제품명</th>
			<th>계획수량</th>
			<th style='width:0px; display:none;'>생산계획 수정이력</th>
			<th style='width:0px; display:none;'>제품코드</th>
			<th style='width:0px; display:none;'>제품 수정이력</th>
			<th style='width:0px; display:none;'>유통기한</th>
			<th>규격</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div> 