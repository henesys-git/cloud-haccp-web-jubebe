<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();/* 
	String member_key = session.getAttribute("member_key").toString();

	String GV_FROMDATE = "", GV_TODATE = ""; */
	
	String regist_seq_no = "";
	
	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");	

	JSONObject jArray = new JSONObject();
	/* jArray.put("member_key", member_key);
	jArray.put("fromdate", GV_FROMDATE);
	jArray.put("todate", GV_TODATE); */
	jArray.put("regist_seq_no", regist_seq_no);
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020500E114", jArray);	
 	MakeGridData makeGridData = new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "TableS838S020510";
%>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    });

    function clickSubMenu(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		seq_no			= td.eq(0).text().trim();
		regist_seq_no 	= td.eq(1).text().trim();
		visit_date 		= td.eq(2).text().trim();
		company 		= td.eq(3).text().trim();
		visitor_name 	= td.eq(4).text().trim();
		visit_purpose 	= td.eq(5).text().trim();
		visit_time 		= td.eq(6).text().trim();
		disease_checkyn = td.eq(7).text().trim();
		confirm_check 	= td.eq(8).text().trim();
		
    }
    
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>일련번호</th>
		     <th style='width:0px; display:none;'>작성일련번호</th>
		     <th>출입일자</th>
		     <th>업체명</th>
		     <th>성명</th>
		     <th>출입목적</th>
		     <th>방문시간</th>
		     <th>건강이상유무</th>
		     <th>확인</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>