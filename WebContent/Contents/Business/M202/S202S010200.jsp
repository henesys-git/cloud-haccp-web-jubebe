<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- yumsam -->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String Fromdate="", Todate="", custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE;

	if(request.getParameter("From") == null)
		Fromdate = "";
	else
		Fromdate = request.getParameter("From");
	
	if(request.getParameter("To") == null)
		Todate = "";
	else
		Todate = request.getParameter("To");
	
	if(request.getParameter("custcode") == null)
		custCode = "";
	else
		custCode = request.getParameter("custcode");
	
	if(request.getParameter("JSPpage") == null)
		GV_JSPPAGE = "";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");

	JSONObject jArray = new JSONObject();

 	jArray.put("fromdate", Fromdate);
	jArray.put("todate", Todate);
	jArray.put("custcode", custCode);
	jArray.put("member_key", member_key);
	
	DoyosaeTableModel TableModel = new DoyosaeTableModel("M202S010100E204", jArray);
	MakeGridData makeGridData= new MakeGridData(TableModel);
    makeGridData.htmlTable_ID = "tableS202S010200";
%>

<script>
	$(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [2,3,8,9,10],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}],
				order : [[ 4, "desc" ]]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneMainTableOpts, customOpts)
		);
	
	});
	
	function clickMainMenu(obj) {
		var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "selected");
		
		vBalju_no 			= td.eq(0).text().trim();
		vCust_nm 			= td.eq(1).text().trim();
		vBaljuRevNo 		= td.eq(2).text().trim();
		vTraceKey 			= td.eq(3).text().trim();
		vBalju_send_date 	= td.eq(4).text().trim();
		vBalju_nabgi_date 	= td.eq(5).text().trim();
		vNote 				= td.eq(6).text().trim();
		vBalju_status 		= td.eq(7).text().trim();
		vTelNo 				= td.eq(8).text().trim();
		vCust_cd 			= td.eq(9).text().trim();
		vCust_rev_no 		= td.eq(10).text().trim();
		
		parent.DetailInfo_List.click();
	}
	
    function fn_Clear_varv() {
    	vBalju_no = "";
		vBaljuRevNo = "";
		vLotNo = "";
	}
</script>

<table class="table table-bordered nowrap table-hover" 
		  id="<%=makeGridData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th>발주번호</th>
		     <th>고객사</th>
		     <th style='width:0px; display: none;'>발주 수정이력번호</th>
		     <th style='width:0px; display: none;'>이력추적 키</th>
		     <th>발주일</th>
		     <th>납기일</th>
		     <th>비고</th>
		     <th>발주상태</th>
		     <th style='width:0px; display: none;'>고객사전화번호</th>
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>고객사이력수정번호</th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">
	</tbody>
</table>