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
	String yearMonth = "";

	if(request.getParameter("yearMonth") != null)
		yearMonth = request.getParameter("yearMonth");
	
	
	
	JSONObject jArray = new JSONObject();
	jArray.put("yearMonth", yearMonth);

    DoyosaeTableModel TableModel = new DoyosaeTableModel("M909S190100E104", jArray);
    MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS909S190100";
%>

<script type="text/javascript">

	$(document).ready(function () {
	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [],
					'createdCell': function (td) {
						$(td).attr('style', 'display:none;');
					}
				}],
				order : [[ 0, "desc" ]]
			
				
		}
				
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
		
		
		
	});
	    
   	function clickMainMenu(obj) {
   		console.log('clicked main manu');
   		
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		vStandard_date	= td.eq(0).text().trim();
		
		fn_DetailInfo_List();
    }
    
	function fn_Clear_varv() {
		
	}
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
			<th>기준연월</th>
			<th>출고기준 매출</th>
			<th>생산기준 매출</th>
			<th>원재료(포장 포함)</th>
			<th>실제 투입 노무비</th>
			<th>직접비</th>
			<th>간접비</th>
			<th>경비 계</th>
			<th>생산량기준 이윤</th>
			<th>생산량기준 이윤율</th>
			<th>출고량기준 이윤</th>
			<th>출고량기준 이윤율</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>