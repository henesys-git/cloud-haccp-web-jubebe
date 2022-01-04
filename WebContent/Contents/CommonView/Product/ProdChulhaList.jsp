<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
완제품 출하 목록 조회
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String chulhaDate = "", modalLevel = "";

	if(request.getParameter("chulhaDate") != null)
		chulhaDate = request.getParameter("chulhaDate");
	
	if(request.getParameter("modalLevel") != null)
		modalLevel = request.getParameter("modalLevel");	
	
	JSONObject jArray = new JSONObject();
	jArray.put("chulhaDate", chulhaDate);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S060100E214", jArray);
	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableProductChulhaListView";
%>

<script>
	var modalLevel = <%=modalLevel%>;

	$(document).ready(function () {
    	
		setTimeout(function() {
		
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	   			'targets': [1,5],
   	   			'createdCell':  function (td) {
   	   				$(td).attr('style', 'display: none;');
   				}
   		   	}],
   		   	scrollX : true,
   		   	scrollCollapse : true,
   		   	autoWidth : true,
   		   	processing : true,
   		   	order : [[2, "desc"]],
   		   	paging : true
    	}
    	
    	if(modalLevel == 1) {
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
   	    		mergeOptions(henePopupTableOpts, customOpts)
   	    	);
    	} else if(modalLevel == 2) {
    		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
   	    		mergeOptions(henePopup2TableOpts, customOpts)
   	    	);	
    	}
    	
		},300);
    	
	});
	
	function clickPopupMenu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;

		var chulha_no = td.eq(0).text().trim();
		var chulha_rev_no = td.eq(1).text().trim();
		var chulha_date = td.eq(2).text().trim();
		var order_no = td.eq(4).text().trim();
		var order_rev_no = td.eq(5).text().trim();
		var note = td.eq(6).text().trim();
		
		parent.getChulhaMainInfo(chulha_no, chulha_rev_no, chulda_date,
								 order_no, order_rev_no, note);
		
		parent.$('#modalReport').modal('hide');
	}
	
	function clickPopup2Menu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;

		var chulha_no = td.eq(0).text().trim();
		var chulha_rev_no = td.eq(1).text().trim();
		var chulha_date = td.eq(2).text().trim();
		var order_no = td.eq(4).text().trim();
		var order_rev_no = td.eq(5).text().trim();
		var note = td.eq(6).text().trim();
		
		parent.getChulhaMainInfo(chulha_no, chulha_rev_no, chulha_date,
								   order_no, order_rev_no, note);
		
		parent.$('#modalReport2').modal('hide');
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>출하번호</th>
		    <th style='width:0px; display: none'>출하 수정이력번호</th>
		    <th>출하일자</th>
		    <th>가맹점명</th>
		    <th>주문번호</th>
		    <th style='width:0px; display: none'>주문 수정이력번호</th>
		    <th>비고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>