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
	String history_yn = session.getAttribute("history_yn").toString();
	
	String yearMonth = "";

	if(request.getParameter("yearMonth") != null)
		yearMonth = request.getParameter("yearMonth");
	
	JSONObject jArray = new JSONObject();
	jArray.put("yearMonth", yearMonth);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M707S020200E104", jArray);
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID = "tableS707S020200";
%>

<script type="text/javascript">
    var prod_selected_row;
    var selectTable;

    $(document).ready(function () {
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
    			data : <%=makeGridData.getDataArray()%>,
    			columnDefs : [{
    	       		'targets': [1,7,8,9,10,11,12],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'display: none;');
    	       		}
    	    	},{
    	  			'targets': [4,5],
    	  			'render': function(data){
    	  				return addComma(data);
    	  			},
		  			'className' : "dt-body-right"
    	  		}],
    	    	pageLength : 10
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    });
    
    function clickMainMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
    }
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="tableS707S020200" style="width: 100%">
	<thead>
		<tr>
			<th>분류</th>
			<th style="display:none; width:0">반품 일련번호</th>
			<th>반품일자</th>
			<th>제품명</th>
			<th>출하량(EA)</th>
			<th>반품/폐기량(EA)</th>
			<th>비고</th>
			<th style="display:none; width:0">출하번호</th>
			<th style="display:none; width:0">출하 수정이력번호</th>
			<th style="display:none; width:0">생산일자</th>
			<th style="display:none; width:0">재고일련번호</th>
			<th style="display:none; width:0">제품코드</th>
			<th style="display:none; width:0">제품 수정이력번호</th>
		</tr>
	</thead>
	<tbody id="tablePartView_body">		
	</tbody>
</table>