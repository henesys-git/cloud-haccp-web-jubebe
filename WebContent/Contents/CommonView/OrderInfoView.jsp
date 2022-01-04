<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>

<!-- 
주문정보조회 
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_CALLER = "0", LOCATION_TYPE = "";
	
	if(request.getParameter("caller") != null)
		GV_CALLER = request.getParameter("caller");
	
	if(request.getParameter("location_type") != null)
		LOCATION_TYPE = request.getParameter("location_type");	
	
    JSONObject jArray = new JSONObject();
    jArray.put("location_type", LOCATION_TYPE);
		
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M101S020100E614", jArray);
    MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableOderView";
%>
 
<script>
	var caller = "";
	
	$(document).ready(function () {
		setTimeout(function(){
		caller = "<%=GV_CALLER%>";
		
		var customOpts = {
	   			data : <%=makeGridData.getDataArray()%>,
	   			columnDefs : [{
	   	   			'targets': [1,6,7],
	   	   			'createdCell':  function (td) {
	   	   				$(td).attr('style', 'display: none;');
	   				}
	   		   	}],
	   		   	scrollX : true,
	   		   	scrollCollapse : true,
	   		   	autoWidth : true,
	   		   	processing : true,
	   		   	order : [[0, "desc"]],
	   		 	paging : true,
	   		   	pageLength : 10
	    	}
		
		if(caller == 0) {
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
   	    		mergeOptions(henePopupTableOpts, customOpts)
   	    	);
    	} else if(caller == 1) {
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
   	    		mergeOptions(henePopup2TableOpts, customOpts)
   	    	);	
    	} else if(caller == 2) {
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
   	    		mergeOptions(henePopup3TableOpts, customOpts)
   	    	);	
    	}
		
		},200);
	});
	
	function clickPopup2Menu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		let orderNo = td.eq(0).text().trim();
		let orderRevNo = td.eq(1).text().trim(); 
		let custName = td.eq(2).text().trim(); 
		let orderDate = td.eq(3).text().trim(); 
		let deliveryDate = td.eq(4).text().trim(); 
		let orderNote = td.eq(5).text().trim();
		let custCd = td.eq(6).text().trim();
		let custRevNo = td.eq(7).text().trim();
			
 		parent.setOrderInfo(orderNo, orderRevNo, custName,
 							orderDate, deliveryDate, orderNote, custCd, custRevNo);
		
 		if(parent.checkValue(checkval) == true){ 
			parent.$('#modalReport2').modal('hide');	
		}
		else if(parent.checkValue(checkval) == false) {
			parent.checkValue(true);
		}
		else {
			parent.$('#modalReport2').modal('hide');
		}
	}
	
	function clickPopup3Menu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		let orderNo = td.eq(0).text().trim();
		let orderRevNo = td.eq(1).text().trim(); 
		let custName = td.eq(2).text().trim(); 
		let orderDate = td.eq(3).text().trim(); 
		let deliveryDate = td.eq(4).text().trim(); 
		let orderNote = td.eq(5).text().trim();
		let custCd = td.eq(6).text().trim();
		let custRevNo = td.eq(7).text().trim();
			
 		parent.setOrderInfo(orderNo, orderRevNo, custName,
 							orderDate, deliveryDate, orderNote, custCd, custRevNo);

		parent.$('#modalReport3').modal('hide');
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>주문번호</th>
		    <th style='width:0px; display: none'>주문수정이력</th>
		    <th>고객사명</th>
		    <th>주문일자</th>
		    <th>납기일자</th>
		    <th>비고</th>
		    <th style='width:0px; display: none'>고객사코드</th>
		    <th style='width:0px; display: none'>고객사수정이력번호</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>