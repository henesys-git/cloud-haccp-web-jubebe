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
	
	String Fromdate = "", Todate = "", 
		   Custcode = "", GV_PROCESS_STATUS = "", 
		   GV_INSPECT_GUBUN = "", GV_JSPPAGE = ""; 

	if(request.getParameter("From") != null)
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To") != null)
		Todate = request.getParameter("To");	

	if(request.getParameter("Custcode") != null)
		Custcode = request.getParameter("Custc!ode");	
	
	if(request.getParameter("InspectGubun") != null)
		GV_INSPECT_GUBUN = request.getParameter("InspectGubun");	
	
	if(request.getParameter("jspPage") != null)
		GV_JSPPAGE = request.getParameter("jspPage");
	
	String param = Fromdate	+ "|" + Todate	+ "|" + 
				   Custcode + "|" +  GV_JSPPAGE;
	
	JSONObject jArray = new JSONObject();
	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M404S030100E104", jArray);	
    
	MakeGridData makeGridData = new MakeGridData(TableModel);
	makeGridData.htmlTable_ID	= "tableS404S030100";
%>
<script>
	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
	
		var customOpts = {
			data : <%=makeGridData.getDataArray()%>,
			columnDefs : [
				{
					'targets': [0,1,7,8],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [9],
					'render' : function(data, type, row, meta) {
						var totalCnt = row[5];
						var passCnt = row[6];
						var passOrNot = totalCnt - passCnt
						if(passOrNot > 0) {
							return '<span style="color:red">과량/경량 수: ' + passOrNot + '</span>';
						} else {
							return '<span style="color:blue">통과</span>';
						}
					}
				},
	   			{
		  			'targets': [5,6],
		  			'render': function(data){
		  				return addComma(data);
		  			},
		  			'className' : "dt-body-right"
		  		}
			],
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
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style="display:none; width:0px">센서 번호</th>
		     <th style="display:none; width:0px">센서 수정이력번호</th>
		     <th>제품명</th>
		     <th>측정일자</th>
		     <th>측정시간</th>
		     <th>총 계량 수(EA)</th>
		     <th>정량 수(EA)</th>
		     <th style="display:none; width:0px">완제품 ID</th>
		     <th style="display:none; width:0px">null</th>
		     <th>비고</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              