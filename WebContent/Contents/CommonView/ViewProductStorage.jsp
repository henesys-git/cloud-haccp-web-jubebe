<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
완제품 재고 조회
yumsam
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String GV_CALLER = "", 
		   GV_PRODGUBUN_BIG = "" , 
		   GV_PRODGUBUN_MID = "";

	if(request.getParameter("caller") == null)
		GV_CALLER = "";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("prodgubun_big") == null)
		GV_PRODGUBUN_BIG = "";
	else
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");

	if(request.getParameter("prodgubun_mid") == null)
		GV_PRODGUBUN_MID = "";
	else
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");
	
	JSONObject jArray = new JSONObject();
	jArray.put("prodgubun_big", GV_PRODGUBUN_BIG);
	jArray.put("prodgubun_mid", GV_PRODGUBUN_MID);
		
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S060100E184", jArray);
	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableProductView";
%>

<script>
	var caller = "";

	$(document).ready(function () {
		
		setTimeout(function(){
		
			caller = "<%=GV_CALLER%>";
	    	
	    	var customOpts = {
	   			data : <%=makeGridData.getDataArray()%>,
	   			columnDefs : [{
	   	   			'targets': [2,4,5],
	   	   			'createdCell':  function (td) {
	   	   				$(td).attr('style', 'display: none;');
	   				}
	   		   	}],
	   		   	scrollX : true,
	   		   	scrollCollapse : true,
	   		   	autoWidth : true,
	   		   	processing : true,
	   		   	order : [[0, "desc"]],
	   		   	info : true,
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
	       		)
	    	};
		}, 200);
    	
	});
	
	function clickPopupMenu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;

		var prodName = td.eq(0).text().trim();
		var prodCode = td.eq(1).text().trim();
		var prodRevNo = td.eq(2).text().trim();
		var prodDate = td.eq(3).text().trim();
		var seqNo = td.eq(4).text().trim();
		
		parent.SetProductName_code(prodName, prodCode, prodRevNo, 
								   prodDate, seqNo);
		
		parent.$('#modalReport').modal('hide');
	}
	
	function clickPopup2Menu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;

		var prodName = td.eq(0).text().trim();
		var prodCode = td.eq(1).text().trim();
		var prodRevNo = td.eq(2).text().trim();
		var prodDate = td.eq(3).text().trim();
		var seqNo = td.eq(4).text().trim();
		
		parent.SetProductName_code(prodName, prodCode, prodRevNo, 
								   prodDate, seqNo);
		
		parent.$('#modalReport2').modal('hide');
	}
	
	function clickPopup3Menu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;

		var prodName = td.eq(0).text().trim();
		var prodCode = td.eq(1).text().trim();
		var prodRevNo = td.eq(2).text().trim();
		var prodDate = td.eq(3).text().trim();
		var seqNo = td.eq(4).text().trim();
		
		parent.SetProductName_code(prodName, prodCode, prodRevNo, 
								   prodDate, seqNo);
		
		parent.$('#modalReport3').modal('hide');
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>제품명</th>
		    <th>제품코드</th>
		    <th style='width:0px; display: none'>제품 수정이력번호</th>
		    <th>생산일자</th>
		    <th style='width:0px; display: none'>일련번호</th>
		    <th style='width:0px; display: none'>안전재고</th>
		    <th>현재고</th>
		    <th>유통기한</th>
		    <th>비고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>