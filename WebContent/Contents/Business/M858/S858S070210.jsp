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
	
	String GV_PROD_CD = "", GV_PROD_REV = "";

	if(request.getParameter("prod_cd") != null) {
		GV_PROD_CD = request.getParameter("prod_cd");	
	}
	
	if(request.getParameter("prod_rev") != null) {
		GV_PROD_REV = request.getParameter("prod_rev");	
	}
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("prod_cd", GV_PROD_CD);
	jArray.put("prod_rev", GV_PROD_REV);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M858S070200E214", jArray);

	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS858S070210";
%>

<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [4],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
	   			{
		  			'targets': [5],
		  			'render': function(data){
		  				return addComma(data);
		  			},
		  			'className' : "dt-body-right"
		  		}],
				scrollX : true,
				order : [0, "DESC"]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
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
	      id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead>
		<tr>
			<th>생산일자</th>
			<th>제품코드</th>
			<th>제품명</th>
			<th>규격</th>
			<th style='width:0px; display: none;'>제품 수정이력번호</th>
			<th>현재재고</th>
			<th>유통기한</th>
			<th>비고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>