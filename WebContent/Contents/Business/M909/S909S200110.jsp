<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String memberKey = session.getAttribute("member_key").toString();	
	String GV_STANDARD_YEARMONTH = "", GV_WORKING_REV_NO = "";

	if(request.getParameter("standard_yearmonth") != null)
		GV_STANDARD_YEARMONTH = request.getParameter("standard_yearmonth");
	
	if(request.getParameter("working_rev_no") != null)
		GV_WORKING_REV_NO = request.getParameter("working_rev_no");
	
	
	
	JSONObject jArray = new JSONObject();
	jArray.put("standard_yearmonth", GV_STANDARD_YEARMONTH);
	jArray.put("working_rev_no", GV_WORKING_REV_NO);

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S200100E114", jArray);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S200110";
%>

<script type="text/javascript">

	$(document).ready(function () {
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [1,4],
					'createdCell': function (td) {
						$(td).attr('style', 'display:none;');
					}
				}],
				order : [[ 0, "asc" ]],
				paging : true,
				pageLength: 5
			
				
		}
				
		$('#<%=makeGridData.htmlTable_ID%>').removeAttr('width').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
		
		
		
	});
	    
   	function clickSubMenu(obj) {
   		console.log('clicked main manu');
   		
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		
	    }
    
	function fn_Clear_varv() {
		chulhaNo = "";
		orderRevNo = "";
		chulhaRevNo = "";
		chulhaeDate = "";
		orderNo = "";
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>날짜</th>
			<th style="display:none; width:0px">완제품코드</th>
			<th>완제품명</th>
			<th>소요시간</th>
			<th style="display:none; width:0px">노무정보 수정이력번호</th>
			
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>